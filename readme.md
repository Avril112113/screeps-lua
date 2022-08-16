# screens-lua
This is a simple project to get Lua running inside of screeps.  
Though this project was successful and works, there is no guarantee for safety, performance or consistency.  

# How to use?
Prerequisites:  
- [`python`](https://www.python.org/) Any version should do.  

Go to the [Releases](https://github.com/Dude112113/screeps-lua/releases) and download the latest release.  
Extract the folder inside the downloaded ZIP to some memberable location and rename it.  
Open the folder in vscode.  
Modify `SCRIPT_SERVER=` in `env.bat` to the correct server, default is local host (found with `Open local folder`)  
Start screeping!  
After any changes, press `ctrl+shift+B` (default) to update your code.  

NOTE FOR **LINUX**:  
Nothing has been tested for linux and so the `updateLua.bat` and `env.bat` won't work for you.  
All you need to do is make sure the environment variables from `env.bat` are set and run `python updateLua.py`.  
You also need to copy the file `build/lua_files.js` to your local scripts folder.  
If you are automating this process, also update `tasks.json`. (maybe a PR? 😉)  


# Building from source.
This section only applies if you are modifying any `.js`, `.cpp`/`.hpp` files.  
If you plan on doing anything with the JS code and would like some degree of typing info, run `yarn install`. (Requires `yarn`)  

## How to build? (Windows)
Prerequisites:  
- [`emscripten`](https://emscripten.org/) with `emcc` available.  
- [`python`](https://www.python.org/) Any version should do.  

Building:  
- Modify `SCRIPT_SERVER` in `env.bat` to the server you wish to deploy (which can be found from `Open local folder`).  
- Run `build.bat` to build the JS and WASM code. (This also updates `src/`)  

## How to build? (Linux)
**Not tested** but should work... probably...  
Since no `.sh` files are setup for linux, follow the windows instructions but manually run the relevant commands.  
See: `build.bat`, `updateLua.bat`, and `buildLua.py`. They are very simple.  
