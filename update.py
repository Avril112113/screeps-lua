from genericpath import isfile
from glob import glob
import argparse
import base64
import shutil
import sys
import os
import json
import requests

from consts import *


SCREEPS_LUA_PATH = os.path.abspath(os.path.dirname(__file__))
if SCREEPS_LUA_PATH == os.getcwd():
	SCREEPS_LUA_PATH = "./"
else:
	SCREEPS_LUA_PATH = SCREEPS_LUA_PATH.replace("\\", "/") + "/"


def generateJS(dirs: list[str], files: dict[str, str]):
	output = [
		"// THIS FILE WAS GENERATED! AVOID MODIFYING.",
		"module.exports.write = function(FS) {",
	]
	for path in dirs:
		path = path.replace("\\", "/")
		output.append(f"\tFS.mkdir({'/' + path!r});")
	for srcPath, dstPath in files.items():
		dstPath = dstPath.replace("\\", "/")
		with open(srcPath, "r", encoding="utf8") as f:
			contents = f.read()
		# pythons repr() is good enough for JS since JS strings have nothing fancy
		output.append(f"\tFS.writeFile({dstPath!r}, {contents!r});")
	output.append("};\n")
	return "\n".join(output)

def dirsFilesFrom(search_path: str, base_path: str=None, dirs: list[str] = None, files: dict[str, str] = None):
	base_path = search_path if base_path is None else base_path
	dirs = [] if dirs is None else dirs
	files = {} if files is None else files
	for name in os.listdir(search_path):
		path = os.path.join(search_path, name)
		if os.path.isfile(path):
			files[path] = path[len(base_path):]
		elif os.path.isdir(path):
			dirs.append(path[len(base_path):])
			dirsFilesFrom(path, base_path, dirs, files)
		else:
			print(f"Unable to add file \"{path}\" as it is not a file or directory.", file=sys.stderr)
	return dirs, files

def generateLuaFilesJSFile(outfile: str, srcpath: str):
	if not os.path.isdir(srcpath):
		print(f"Directory does not exist \"{srcpath}\"", file=sys.stderr)
		exit(1)
	code = generateJS(*dirsFilesFrom(srcpath))
	with open(outfile, "w", encoding="utf8") as f:
		f.write(code)

def uploadFolder(srcpath: str, server: str):
	if not os.path.isfile("servers.json"):
		print("Missing `servers.json`.", file=sys.sys.stderr)
		exit(1)
	with open("servers.json", "r") as f:
		config = json.loads(f.read())
	details = config[server]
	if details is None:
		print(f"Failed to find server \"{server}\" in \"servers.json\"")
		exit(1)
	if "host" not in details:
		print(f"\"{server}\" in \"servers.json\" is missing \"host\"")
		exit(1)
	if "token" not in details and "username" not in details is None and "password" not in details is None:
		print(f"\"{server}\" in \"servers.json\" is missing \"token\" or \"username\" and \"password\"")
		exit(1)
	if "branch" not in details is None:
		details["branch"] = "default"
	host = details["host"].rstrip("/")
	url = f"{host}/api/user/code"
	files = {}
	for file in glob("build/*.js"):
		with open(file, "r") as f:
			files[os.path.splitext(os.path.basename(file))[0]] = f.read()
	for file in glob("build/*.wasm"):
		# print("WARNING: wasm file uploads are not working right now...", file=sys.stderr)
		with open(file, "rb") as f:
			files[os.path.splitext(os.path.basename(file))[0]] = {
				"binary": base64.b64encode(f.read()).decode("utf8")
			}
	data = {
		"modules": files,
		"branch": details["branch"],
	}
	headers = {"Content-Type": b"application/json; charset=utf-8"}
	auth = None
	if details.get("token", False):
		headers["X-Token"] = details["token"].encode("utf-8")
	else:
		auth = (details["username"], details["password"])
	print(f"Uploading \"{srcpath}\" to \"{host}\" on branch \"{details['branch']}\"")
	response = requests.post(url, json=data, headers=headers, auth=auth)
	response.raise_for_status()
	print(json.loads(response.content))

def create_project(srcpath: str):
	if not os.path.isdir(srcpath):
		shutil.copytree(f"{SCREEPS_LUA_PATH}project_base/src", srcpath)
	else:
		# TODO Ask to update `{srcpath}/screeps-lua` instead
		print(f"Skipped copying src_starter, \"{srcpath}\" exists. (update \"{srcpath}/screeps-lua\" manually if needed)")
	if not os.path.isdir(".vscode"):
		shutil.copytree(f"{SCREEPS_LUA_PATH}project_base/.vscode", ".vscode")
	if not os.path.isfile("servers.json"):
		shutil.copy(f"{SCREEPS_LUA_PATH}project_base/servers.json", "./")
	if not os.path.isdir("build"):
		os.mkdir("./build")
		shutil.copy(f"{SCREEPS_LUA_PATH}build/lua_wasm.wasm", "./build")
		shutil.copy(f"{SCREEPS_LUA_PATH}build/lua_module.js", "./build")
		shutil.copy(f"{SCREEPS_LUA_PATH}build/main.js", "./build")
		# We do this here, because if we are in the screeps-lua source or release folder, we don't want to nuke it.
		if os.path.isdir("typing"):
			shutil.rmtree("typing")
		shutil.copytree(f"{SCREEPS_LUA_PATH}typing", "typing")
	else:
		print(f"Skipped copying build as it exists. Please delete this directory and re-run if it's not within a release download or screeps-lua source.", file=sys.stderr)


if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("--create", action="store_true")
	parser.add_argument("--src", type=str)
	parser.add_argument("-u", "--upload", nargs="?", const="localhost")
	parser.add_argument("-j", "--js", action="store_true")
	args = parser.parse_args()
	src_path = SRC_PATH if args.src is None else args.src
	if args.create:
		print("Creating project...")
		create_project(src_path)
	print("Updating...")
	if args.js:
		from build import copyJSMain
		copyJSMain()
	generateLuaFilesJSFile("build/lua_files.js", src_path)
	if args.upload is not None:
		uploadFolder("build", args.upload)
