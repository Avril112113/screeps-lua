# screeps-lua
This is a "simple" project to get Lua running inside of screeps.  
It is advised to not rely on the performance or consistency of this project as it isn't well tested.  

# How to use?
Prerequisites:  
- [`python3`](https://www.python.org/)  

Quick usage examples:  
- Update "`screeps-lua`"  
- Update and upload to `localhost`, "`screeps-lua -u`"  
- Update and upload to custom server, "`screeps-lua -u awesome_server`"  
- Update from custom directory, "`screeps-lua --src ./custom_src`"  

Running `screeps-lua` will update the Lua `./src`.  
The following arguments may be used:  
- `--create` (Default: `False`)  
  Creates a new project in the current directory.  
- `--src <path>` (Default: `./src`)  
  This will change the directory of the Lua source code to be updated.  
- `-u [server]` `--upload [server]` (Default: `localhost`)  
  This will upload the build to the screeps server, defaulting to `localhost` defined in `servers.json`  
- `-j` `--js` (Default: `False`)  
  This will also update the JS files from `./js`, however this is only used for testing screeps-lua.  

**Updating from linux is not tested**, however it *should* work.  
Follow the normal instructions but replace any use of `screeps-lua` with `python update.py`.  

## Adding to PATH (Windows only)
This project does support being added to the PATH.  
Simply add the directory containing `screeps-lua.bat` into your PATH and run `screeps-lua` whereever you need.  

# Building source.
This section only applies if you are modifying any `.js`, `.cpp`/`.hpp` files.  
Note that `screeps-lua --js` will also update the `.js` files.  

## How to build? (Windows)
Simply run `screeps-lua build` to build the wasm and JS files.  
The following arguments may be used:  
- `-a` `--wasm_async_compilation` (Default: `False`)  
  This will make the wasm binary be loaded asynchronously, however this isn't well tested.  
- `-p` `--preserve_func_Names` (Default: `False`)  
  If there are errors from the cpp code, this will preserve the function names, allowing easier debugging.  
- `-l` `--leak_detection` (Default: `False`)  
  WARNING: This will cause significant performance issues and should only be used on a private server.  
  This will enable address sanitisation to check for any memory issues.  
- `--skip_compile` (Default: `False`)  
  Skips building wasm.  
- `-u` `--upload [server]` (Default: `localhost`)  
  This will upload the build to the screeps server, defaulting to `localhost` defined in `servers.json`  

## How to build? (Linux)
**Building from linux is not tested**, however it *should* work.  
Follow the windows instructions but replace any use of `screeps-lua build` with `python build.py`.  
