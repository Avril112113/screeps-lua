# screens-lua
This is a simple project to get Lua running inside of screeps.  
Though this project was successful and works, there is no guarantee for safety, performance or consistency.  

If you plan on doing anything with the JS code and would like some degree of typing info, run `yarn install`. (Requires `yarn`)  

## How to use? (Windows)
Prerequisites:  
- [`emscripten`](https://emscripten.org/) with `emcc` available.  
- [`python`](https://www.python.org/)  

Building:  
- Modify `SCRIPT_SERVER` in `env.bat` to the server you wish to deploy (which can be found from `Open local folder`).  
- Run `build.bat` to build the JS and WASM code. (This also updates `src/`)  

Once built, any changes in `src/` can be updated quickly by running `updateLua.bat`.  
NOTE: Using `updateLua.bat` require the `build/` directory and it's contents to remain.  
In the future I **may** provide releases.  

## How to use? (Linux)
**Not tested** but should work... probably...  
Since no `.sh` files are setup for linux, follow the windows instructions but manually run the relevant commands.  
See: `build.bat`, `updateLua.bat`, and `buildLua.py`. They are very simple.  
