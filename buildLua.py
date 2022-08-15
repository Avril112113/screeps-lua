# I wasn't gonna make this is batch...
# And if someone tried to get this working on Linux, it'd be evil of me
# This doesn't require any non standard libraries

import os
import sys

SRC_PATH = "src/"
BUILD_DIR = "build"
OUTPUT_PATH = os.path.join(BUILD_DIR, "lua_files.js")

output = [
	"// THIS FILE IS GENERATED! DO NOT TOUCH!",
	"module.exports.write = function(FS) {",
]

dirs = []
files = []

def recurGen(base_path):
	for name in os.listdir(base_path):
		path = f"{base_path}/{name}"
		if os.path.isfile(path):
			files.append(path)
		elif os.path.isdir(path):
			dirs.append(path)
			recurGen(path)
		else:
			print(f"Unable to add file \"{path}\" as it is not a file or directory.", file=sys.stderr)

recurGen(SRC_PATH)

for path in dirs:
	output.append(f"\tFS.mkdir({path[len(SRC_PATH):]!r});")

for path in files:
	with open(path, "r") as f:
		contents = f.read()
	output.append(f"\tFS.writeFile({path[len(SRC_PATH):]!r}, {contents!r});")


output.append("}")

with open(OUTPUT_PATH, "w") as f:
	f.write("\n".join(output))
