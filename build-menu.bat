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
echo   [x] Quit
echo.

:: ask for input

set input=0
set /p input="Your selection: "

:: accept input and forward to handlers

if %input%==1 goto OPTION1
if %input%==2 goto OPTION2
if %input%==3 goto OPTION3
IF %input%==x goto QUIT
goto SHOWMENU

:: handlers

:OPTION1
    echo One-Click Build
    call build.bat
goto END

:OPTION2
    echo Downloading all Components for the "not-web" Installation Wizards
    call bin\nant\bin\nant.exe -buildfile:build.xml download-components
goto END

:OPTION3
    echo Building "not-web" Installation Wizards (use existing Downloads)
    call bin\nant\bin\nant.exe -buildfile:build.xml compile-wpnxm-allinone-installer-no-download compile-wpnxm-bigpack-installer-no-download compile-wpnxm-lite-installer-no-download
goto END

:END
pause

:QUIT