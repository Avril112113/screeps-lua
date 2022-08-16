@echo off

call env.bat

if exist "%BUILD_DIR%" rmdir "%BUILD_DIR%"
mkdir "%BUILD_DIR%"

python buildLua.py

@REM For finding memory leaks, NOTE: this is VERY heavy on perf and will often time out
@REM --profiling-funcs -fsanitize=leak -sINITIAL_MEMORY=157286400
cmd /C emcc^
 --bind --no-entry -sWASM=1 -sENVIRONMENT=shell -sWASM_ASYNC_COMPILATION=0 -sMODULARIZE -O3^
 -sASSERTIONS^
 -sEXPORTED_FUNCTIONS=_init,_loop,_eval,_callWrappedLuaFunction^
 -sEXPORTED_RUNTIME_METHODS=cwrap,FS^
 -I../lua-5.4.4/src^
 cpp/main.cpp lua.a^
 -o %BUILD_DIR%/lua.js^
 --js-library js/jslib.js

copy /Y "js\main.js" "%BUILD_DIR%\main.js"
move "%BUILD_DIR%\lua.js" "%BUILD_DIR%\lua_module.js"
xcopy /Y /s "%BUILD_DIR%" "%SCRIPT_DIR%"
