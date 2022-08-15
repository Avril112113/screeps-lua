@echo off

@REM Below runs `env.bat`
call buildLua.bat

copy /Y "%BUILD_DIR%\lua_files.js" "%SCRIPT_DIR%\lua_files.js"
