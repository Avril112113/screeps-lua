@echo off

call env.bat

if exist "%BUILD_DIR%" rmdir "%BUILD_DIR%"
mkdir "%BUILD_DIR%"

python buildLua.py

cmd /C emcc^
 --bind -sWASM=1 -sWASM_ASYNC_COMPILATION=0 -sMODULARIZE -O2 --no-entry^
 -sEXPORTED_FUNCTIONS=_init,_loop,_eval,_callWrappedLuaFunction^
 -sEXPORTED_RUNTIME_METHODS=cwrap,FS^
 -I../lua-5.4.4/src^
 cpp/main.cpp lua.a^
 -o %BUILD_DIR%/lua.js^
 --js-library js/jslib.js
@REM  --embed-file src@/^

copy /Y "js\main.js" "%BUILD_DIR%\main.js"
move "%BUILD_DIR%\lua.js" "%BUILD_DIR%\lua_module.js"
xcopy /Y /s "%BUILD_DIR%" "%SCRIPT_DIR%"
