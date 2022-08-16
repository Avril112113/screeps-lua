@echo off

call env.bat

SET RELEASE_DIR=release

if exist "%RELEASE_DIR%" rmdir /s /q "%RELEASE_DIR%"
mkdir "%RELEASE_DIR%"
copy "typing_screeps.lua" "%RELEASE_DIR%\\typing_screeps.lua"
copy "env.bat" "%RELEASE_DIR%\\env.bat"
copy "buildLua.py" "%RELEASE_DIR%\\buildLua.py"
copy "updateLua.bat" "%RELEASE_DIR%\\updateLua.bat"

mkdir "%RELEASE_DIR%\\src"
mkdir "%RELEASE_DIR%\\src\\screeps"
xcopy /Y /s "src\\screeps" "%RELEASE_DIR%\\src\\screeps"
(
	echo function Script.loop^(^)
	echo.
	echo end
) > "%RELEASE_DIR%\\src\\main.lua"

mkdir "%RELEASE_DIR%\\.vscode"
copy ".vscode\\tasks_release.json" "%RELEASE_DIR%\\.vscode\\tasks.json"

mkdir "%RELEASE_DIR%\\%BUILD_DIR%"
xcopy /Y /s "%BUILD_DIR%" "%RELEASE_DIR%\\%BUILD_DIR%"
del "%RELEASE_DIR%\\%BUILD_DIR%\\lua_files.js"
