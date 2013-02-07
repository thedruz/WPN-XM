@echo off
:: Change this to ON when debugging this batch file.

SetLocal

cls

:: set window title
TITLE WPN-XM Server Stack for Windows - Build Script!

:: display a Menu

echo             WPN-XM Build Menu
echo             =================
echo.
echo   [1] One-Click Build
echo   [2] Download Components
echo   [3] Rebuild AllInOne Installation Wizard
echo.

:: ask for input

set input=0
set /p input="Your selection: "

:: accept input and forward to handlers

if %input%==1 goto OPTION1
if %input%==2 goto OPTION2
if %input%==3 goto OPTION3
goto END

:: handlers

:OPTION1
    echo One-Click Build
    call build.bat
goto END

:OPTION2
    echo Downloading all Components for the All-In-One Installation Wizard
    call bin\nant\bin\nant.exe -buildfile:build.xml download-components
goto END

:OPTION3
    echo Rebuild AllInOne Installation Wizard (use existing Downloads)
    call bin\nant\bin\nant.exe -buildfile:build.xml compile-wpnxm-allinone-installer-no-download
goto END

:END
pause
