from genericpath import isfile
from posixpath import dirname
from pydoc import isdata
import shutil
import os

from build import build


release_files = [
	"build.py",
	"update.py",
	"consts.py",
	"screeps-lua.bat",

	"readme.md",

	"project_base",
	"typing",
	"build/main.js",
	"build/lua_wasm.wasm",
	"build/lua_module.js",
]


print("Building release WASM.")
build()

print("Copying files to ./release/")
if os.path.isdir("release"):
	shutil.rmtree("release")
os.mkdir("release")
for path in release_files:
	if os.path.isdir(path):
		shutil.copytree(path, f"release/{path}")
	elif os.path.isfile(path):
		dirpath = os.path.dirname(f"release/{path}")
		if not os.path.isdir(dirpath):
			os.makedirs(dirpath)
		shutil.copy(path, f"release/{path}")
