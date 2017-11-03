@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Stripdown Script for Imagick
:: |
:: +-----------------------------------------------------------------------<3

:: Accepts the "path to Imagick" as first parameter

:: Use quotes on the argument, if the folder name contains spaces:
:: stripdown-imagick.bat "c:\program files\somewhere"

:: Check - Parameter is not empty

IF "%~1" == "" (
    ECHO Parameter missing.
    ECHO Please add the path to Imagick.
    GOTO EOF;
)

:: Check - Parameter is folder

IF NOT EXIST "%~1" (
    ECHO Folder "%~1" not found.
    ECHO Provide a valid path to the Imagick folder.
    GOTO EOF;
)

:: Check - Parameter is the Imagick folder

IF NOT EXIST "%~1\animate.exe" (
    ECHO Folder "%~1" exists, but is not the Imagick folder.
    ECHO Could not find "%~1\animate.exe".
    GOTO EOF;
)

:: Ok, now we know where Imagick resides...

SET IMAGICK_DIR=%~1

echo Found Imagick in %IMAGICK_DIR%

echo.
echo [x] Stripdown Imagick
echo.

:: process the /www folder

rd /s /q "%IMAGICK_DIR%\www"

:: DONE

echo.
echo [+] Imagick stripdown done.
echo.
GOTO END;

:: EOF GOTO TARGET

:EOF
echo.
echo [-] Imagick stripdown failed.
echo.
pause

:: Have a nice day.
:END