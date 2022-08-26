from functools import reduce
from glob import glob
from subprocess import Popen
import argparse
import shutil
import sys
import os

from consts import *
from update import *

SCREEPS_LUA_PATH = os.path.abspath(os.path.dirname(__file__))
if SCREEPS_LUA_PATH == os.getcwd():
	SCREEPS_LUA_PATH = "./"
else:
	SCREEPS_LUA_PATH = SCREEPS_LUA_PATH.replace("\\", "/") + "/"


# functions from C/C++ that are to be exported to use within JS ("_" prefix is required)
EXPORTED_FUNCTIONS = [
	# js_for.cpp
	"_callWrappedLuaFunction",

	# main.cpp
	"_init",
	"_loop",
	"_reload",
	"_eval",
]
# methods to be made available to JS via the WASM module (Ones provided by emscripten or a js-lib)
EXPORTED_RUNTIME_METHODS = [
	"cwrap",
	"FS",
]


def copyJSMain():
	shutil.copyfile(f"{SCREEPS_LUA_PATH}js/screeps_main.js", "build/main.js")


def build(wasm_async_compilation=False, preserve_func_Names=False, leak_detection=False, skip_compile=False):
	if preserve_func_Names:
		print("WARNING: Preserve function names is on, this will hurt load speed and might timeout when trying to load!")
	if leak_detection:
		print("WARNING: Memory leak detection is on, this will hurt performance drastically and should be tested on a private world!")

	emcc_path = shutil.which(EMCC)
	if emcc_path is None:
		print(f"Unable to find {EMCC} on the PATH.", file=sys.stderr)
		return 1
	args = [
		emcc_path,
		f"--no-entry",  # We don't this isn't a standalone WASM file
		f"--bind",  # So we can use embind
		f"-sASSERTIONS",  # Use assertions, helps find issues
		f"-sWASM=1",  # Just want standalone WASM (check emscripten docs for more details)
		f"-sENVIRONMENT=shell",  # Assertions complain otherwise
		f"-sWASM_ASYNC_COMPILATION={int(wasm_async_compilation)}",
		f"-sMODULARIZE",  # We want a JS module so we can control when to create the WASM module
		f"-sALLOW_MEMORY_GROWTH",  # Idk if this actually works for us?
		*(["--profiling-funcs"] if preserve_func_Names else []),
		*(["-fsanitize=address", "-sINITIAL_MEMORY=157286400"] if leak_detection else []),
		# *(["-fsanitize=leak", "-sINITIAL_MEMORY=157286400"] if leak_detection else []),
		f"-O3",  # We need it optimised, otherwise it takes too long to load
		f"-sEXPORTED_FUNCTIONS={','.join(EXPORTED_FUNCTIONS)}",
		f"-sEXPORTED_RUNTIME_METHODS={','.join(EXPORTED_RUNTIME_METHODS)}",
		f"--js-library", f"{SCREEPS_LUA_PATH}js/emlib.js",
		*reduce(lambda a,b: a+b, [(f"-I", f"{SCREEPS_LUA_PATH}include/{path}") for path in os.listdir(f"{SCREEPS_LUA_PATH}include")]),
		*[path for path in glob(f"{SCREEPS_LUA_PATH}lib/**/*.a", recursive=True)],
		*[path for path in glob(f"{SCREEPS_LUA_PATH}cpp/**/*.c", recursive=True) + glob(f"{SCREEPS_LUA_PATH}cpp/**/*.cpp", recursive=True)],
		f"-o", f"build/lua_module.js",
	]
	if not os.path.isdir("build"):
		os.mkdir("build")
	if not skip_compile:
		p = Popen(args)
		p.wait()
		if p.returncode != 0:
			return p.returncode
		os.replace("build/lua_module.wasm", "build/lua_wasm.wasm")
	copyJSMain()
	if not os.path.isdir("src"):
		os.mkdir("src")
	generateLuaFilesJSFile("build/lua_files.js", SRC_PATH)
	return 0


if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("-a", "--wasm_async_compilation", action="store_true")
	parser.add_argument("-p", "--preserve_func_Names", action="store_true")
	parser.add_argument("-l", "--leak_detection", action="store_true")
	parser.add_argument("--skip_compile", action="store_true")
	parser.add_argument("-u", "--upload", nargs="?", const="localhost")
	args = parser.parse_args()
	print("Building...")
	if build(
		wasm_async_compilation=args.wasm_async_compilation,
		preserve_func_Names=args.preserve_func_Names,
		leak_detection=args.leak_detection,
		skip_compile=args.skip_compile
	) == 0 and args.upload is not None:
		uploadFolder("build", args.upload)
