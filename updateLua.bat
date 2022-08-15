@echo off

call env.bat

python buildLua.py

copy /Y "%BUILD_DIR%\lua_files.js" "%SCRIPT_DIR%\lua_files.js"
