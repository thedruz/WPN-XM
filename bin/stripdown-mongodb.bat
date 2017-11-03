@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Stripdown Script for MongoDB
:: |
:: +-----------------------------------------------------------------------<3

:: Accepts the "path to MongoDB" as first parameter

:: Use quotes on the argument, if the folder name contains spaces:
:: stripdown-mongodb.bat "c:\program files\somewhere"

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
    ECHO Could not find "%~1\bin\mongo.exe".
    GOTO EOF;
)

:: Ok, now we know where MongoDB resides...

SET MONGO_DIR=%~1

echo Found MongoDB in %MONGO_DIR%

echo.
echo [x] Stripdown MongoDB
echo.

:: process the /bin folder

:: # 1) delete pdb files (windows crashdumps debug files)

del /s /q "%MONGO_DIR%\bin\*.pdb"

:: DONE

echo.
echo [+] MongoDB stripdown done.
echo.
GOTO END;

:: EOF GOTO TARGET

:EOF
echo.
echo [-] MongoDB stripdown failed.
echo.
pause

:: Have a nice day.
:END