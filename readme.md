# screens-lua
This is a simple project to get Lua running inside of screeps.  
Though this project was successful and works, there is no guarantee for safety, performance or consistency.  

If you plan on doing anything with the JS code and would like typing info, run `yarn install`.  

## How to use?
These instructions are intended for windows.  

Prerequisites:  
- emscripten with `emcc` on your path.  

Building:  
- Modify `SCRIPT_DIR` in `build.bat` to the directory where to output the final files.  
- Run `build.bat` everytime you make a change to the JS, C++ or Lua.  
