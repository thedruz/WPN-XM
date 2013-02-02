@echo off
:: Change this to ON when debugging this batch file.

:: +-------------------------------------------------------------------------
:: | MongoDB 2.2.1 win32 - Stripdown Script for WPN-XM Server Stack.
:: | http://wpn-xm.org/
:: | Author: Jens-André Koch
:: +-----------------------------------------------------------------------<3

:: ############# Accept "path to MongoDB" as first parameter

:: Because of possible spaces in the folder name,
:: one must use quotes on the argument, like so
:: create-mongodb-light-win32.bat "c:\program files\somewhere"

:: Check - Parameter is not empty

IF "%~1" == "" (
    ECHO Parameter missing.
    ECHO Please add the path to MongoDB.
    GOTO EOF;
)

:: Check - Parameter is folder

IF NOT EXIST "%~1" (
    ECHO Folder "%~1" not found.
    ECHO Provide a valid path to the MongoDB folder.
    GOTO EOF;
)

:: Check - Parameter is the MongoDB folder

IF NOT EXIST "%~1\bin\mongo.exe" (
    ECHO Folder "%~1" exists, but is not the MongoDB folder.
    GOTO EOF;
)

:: Ok, now we know where MongoDB resides...

SET MONGO_DIR=%~1

echo %MONGO_DIR%

:: ############# process the /bin folder

:: # 1) delete pdb files (windows crashdumps debug files)

del /s /q "%MONGDO_DIR%\bin\*.pdb"

:: ############# compress executables with UPX

upx/upx.exe -9 %MONGO_DIR%\bin\*.exe

:: ############# DONE

echo.
echo [+] MongoDB stripdown done.
GOTO END;

:: ############# EOF GOTO TARGET

:EOF
echo.
echo [-] MongoDB stripdown failed.
pause

:: ############# Have a nice day.
:END