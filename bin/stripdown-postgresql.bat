@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Stripdown Script for PostgreSQL
:: |
:: +-----------------------------------------------------------------------<3

:: Accepts the "path to PostgreSQL" as first parameter

:: Use quotes on the argument, if the folder name contains spaces:
:: stripdown-postgresql.bat "c:\program files\somewhere"

:: Check - Parameter is not empty

IF "%~1" == "" (
    ECHO Parameter missing.
    ECHO Please add the path to PostgreSQL.
    GOTO EOF;
)

:: Check - Parameter is folder

IF NOT EXIST "%~1" (
    ECHO Folder "%~1" not found.
    ECHO Provide a valid path to the PostgreSQL folder.
    GOTO EOF;
)

:: Check - Parameter is the PostgreSQL folder

IF NOT EXIST "%~1\bin\pg_ctl.exe" (
    ECHO Folder "%~1" exists, but is not the PostgreSQL folder.
    ECHO Could not find "%~1\bin\pg_ctl.exe".
    GOTO EOF;
)

:: Ok, now we know where PostgreSQL resides...

SET POSTGRESQL_DIR=%~1

echo Found PostgreSQL in %POSTGRESQL_DIR%

echo.
echo [x] Stripdown PostgreSQL
echo.

:: process the /bin folder

:: # 1) delete pdb files (windows crashdumps helpers / debug symbols)

del /s /q "%POSTGRESQL_DIR%\symbols\*.pdb"

rd /s /q "%POSTGRESQL_DIR%\symbols"
rd /s /q "%POSTGRESQL_DIR%\doc"
rd /s /q "%POSTGRESQL_DIR%\include"

:: compress executables with UPX

IF EXIST "%~dp0upx\upx.exe" (
    echo.
    echo [x] Compressing PostgreSQL executables with UPX.
    echo.

    %~dp0upx\upx.exe -9 %POSTGRESQL_DIR%\bin\*.exe
)

:: DONE

echo.
echo [+] PostgreSQL stripdown done.
echo.
GOTO END;

:: EOF GOTO TARGET

:EOF
echo.
echo [-] PostgreSQL stripdown failed.
echo.
pause

:: Have a nice day.
:END