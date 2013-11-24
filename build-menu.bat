@echo off
:: Change this to ON when debugging this batch file.

SetLocal

cls

:: set window title
TITLE WPN-XM Server Stack for Windows - Build Script!

:: display a Menu

:SHOWMENU
cls
echo.
echo             WPN-XM Build Menu
echo             =================
echo.
echo   [1] Start "One-Click Build"
echo   [2] Download Components for the "not-web" Installation Wizards
echo   [3] Build the "not-web" Installation Wizards
echo   [4] Build the "Server-Control-Panel" (Tray Application)
echo   [x] Quit
echo.

:: ask for input

set input=0
set /p input="Your selection: "

:: accept input and forward to handlers

if %input%==1 goto OPTION1
if %input%==2 goto OPTION2
if %input%==3 goto OPTION3
if %input%==4 goto OPTION4
IF %input%==x goto QUIT
goto SHOWMENU

:: handlers

:OPTION1
    echo.
    echo One-Click Build
    echo.
    call build.bat
goto END

:OPTION2
    echo.
    echo Downloading all Components for the "not-web" Installation Wizards
    echo.
    call bin\nant\bin\nant.exe -buildfile:build.xml download-components
goto END

:OPTION3
    echo.
    echo Building "not-web" Installation Wizards (use existing Downloads)
    echo.
    call bin\nant\bin\nant.exe -buildfile:build.xml compile-wpnxm-allinone-installer-no-download compile-wpnxm-bigpack-installer-no-download compile-wpnxm-lite-installer-no-download
goto END

:OPTION4
    echo.
    echo Building the "Server-Control-Panel" (Tray Application)
    echo.
    call bin\nant\bin\nant.exe -buildfile:build.xml compile-server-control-panel
goto END

:END
pause

:QUIT