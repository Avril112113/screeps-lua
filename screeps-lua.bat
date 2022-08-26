@echo off
SET SCREEPS_LUA_PATH=%~dp0
SET ARGS=%*
IF "%~1"=="build" (
	SET ARGS=%ARGS:build=%
	GOTO build
) ELSE IF "%~1"=="update" (
	SET ARGS=%ARGS:update=%
	GOTO build
) ELSE (
	GOTO update
)
GOTO finish

:build
python "%SCREEPS_LUA_PATH%build.py" %ARGS%
GOTO finish

:update
python "%SCREEPS_LUA_PATH%update.py" %ARGS%
GOTO finish

:finish
