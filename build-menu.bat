@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Build Menu
:: |
:: +-----------------------------------------------------------------------<3

SetLocal
cls

:: set window title
TITLE WPN-XM Server Stack for Windows - Build Menu

:: display a Menu

:SHOWMENU
cls
echo.
echo             WPN-XM Build Menu
echo             =================
echo.
echo   [1] Start "One-Click Build"
echo   [2] Download Components for all packaging Installation Wizards
echo   [3] Build the packaging Installation Wizards
echo   [4] Build the   web     Installation Wizard
echo   [5] Build the "Server-Control-Panel" (Tray Application)
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
if %input%==5 goto OPTION5
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
    echo Downloading all Components for packaging Installation Wizards
    echo.
    call bin\phing\phing.bat -f %~dp0build.xml download-components
goto END

:OPTION3
    echo.
    echo Building packaged Installation Wizards (use existing Downloads)
    echo.
    call bin\phing\phing.bat -f %~dp0build.xml compile-full-no-download compile-standard-no-download compile-lite-no-download
goto END

:OPTION4
    echo.
    echo Building Web-Installation Wizards
    echo.
    call bin\phing\phing.bat -f %~dp0build.xml compile-webinstaller compile-webinstaller-debug
goto END

:OPTION5
    echo.
    echo Building the "Server-Control-Panel" (Tray Application)
    echo.
    call bin\phing\phing.bat -f %~dp0build.xml build-server-control-panel
goto END

:END
pause

:QUIT