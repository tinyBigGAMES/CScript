@echo off
cd /d "%~dp0"

:: Remove exist Lumina.dll
if exist "resdata.zip" del "resdata.zip"
if %errorlevel% neq 0 (
    echo Failed to delete existing resdata.zip
    exit /b %errorlevel%
)

:: Create resdata.zip
cd ".\root"
call ..\7za a -tzip -mx=9 ..\resdata.zip *
if %errorlevel% neq 0 (
    echo Failed to create resdata.zip
    exit /b %errorlevel%
)
cd ..

:: Convert zip to a .res file
call brcc32.exe "resdata.rc" -v -fo..\CScript.Deps.res
if %errorlevel% neq 0 (
    echo Failed to convert zip to .res file
    exit /b %errorlevel%
)

