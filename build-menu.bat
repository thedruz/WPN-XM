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
echo   [3] Build  packaged  Installation Wizards
echo   [4] Build    web     Installation Wizards
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
    echo Downloading all Components for packaging Installation Wizards
    echo.
    call bin\phing\phing.bat -f %~dp0build.xml download-components
goto END

:OPTION3
    echo.
    echo Building packaged Installation Wizards (using existing Downloads)
    echo.
    call bin\phing\phing.bat -f %~dp0build.xml compile-full compile-standard compile-lite
goto END

:OPTION4
    echo.
    echo Building Web-Installation Wizards
    echo.
    call bin\phing\phing.bat -f %~dp0build.xml compile-webinstaller
goto END

:END
pause

:QUIT