@echo off

SET SCRIPT_DIR="C:\Users\dude\AppData\Local\Screeps\scripts\127_0_0_1___21025\default"

if exist "dist" rmdir "dist"
mkdir "dist"

cmd /C emcc --bind -s WASM=1 -s WASM_ASYNC_COMPILATION=0 -s MODULARIZE -s EXPORTED_FUNCTIONS=_init,_loop,_eval,_callWrappedLuaFunction -sEXPORTED_RUNTIME_METHODS=cwrap -I../lua-5.4.4/src -O1 --no-entry cpp/main.cpp lua.a -o dist/lua.js --embed-file src@/ --js-library js/jslib.js

copy /Y "js\main.js" "dist\main.js"
move "dist\lua.js" "dist\lua_module.js"
xcopy /Y /s "dist" %SCRIPT_DIR%
