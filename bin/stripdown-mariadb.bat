@echo off
:: Change this to ON when debugging this batch file.

:: +-------------------------------------------------------------------------
:: | MariaDB - Stripdown Script for WPN-XM Server Stack.
:: | http://wpn-xm.org/
:: | Author: Jens-André Koch
:: +-----------------------------------------------------------------------<3

:: ############# Accepts the "path to MariaDB" as first parameter

:: Use quotes on the argument, if the folder name contains spaces
:: stripdown-mariadb.bat "c:\program files\somewhere"

:: Check - Parameter is not empty

IF "%~1" == "" (
    ECHO Parameter missing.
    ECHO Please add the path to MariaDB.
    GOTO EOF;
)

:: Check - Parameter is folder

IF NOT EXIST "%~1" (
    ECHO Folder "%~1" not found.
    ECHO Provide a valid path to the MariaDB folder.
    GOTO EOF;
)

:: Check - Parameter is the MariaDB folder

IF NOT EXIST "%~1\bin\mysqld.exe" (
    ECHO Folder "%~1" exists, but is not the MariaDB folder.
    GOTO EOF;
)

:: Ok, now we know where MariaDB resides...

SET MARIADB_DIR=%~1

echo Found MariaDB in %MARIADB_DIR%

echo.
echo [x] Stripdown MariaDB
echo.

:: ############# Toplevel remove *.ini - replaced by our own

del /s /q "%MARIADB_DIR%\*.ini"

:: ############# remove these folders completely

rd /s /q "%MARIADB_DIR%\docs"
rd /s /q "%MARIADB_DIR%\include"
rd /s /q "%MARIADB_DIR%\mysql-test"
rd /s /q "%MARIADB_DIR%\sql-bench"

:: ############# process the /bin folder

:: # 1) delete pdb files (windows crashdumps debug files)

del /s /q "%MARIADB_DIR%\bin\*.pdb"

:: # 2) delete certain executables
:: This list of executables equals a MariaDB win32 msi install (with only database and no client executables)

del /q /f "%MARIADB_DIR%\bin\aria_chk.exe"
del /q /f "%MARIADB_DIR%\bin\aria_dump_log.exe"
del /q /f "%MARIADB_DIR%\bin\aria_ftdump.exe"
del /q /f "%MARIADB_DIR%\bin\aria_pack.exe"
del /q /f "%MARIADB_DIR%\bin\aria_read_log.exe"
:: keep my_print_defaults.exe
del /q /f "%MARIADB_DIR%\bin\myisam_ftdump.exe"
del /q /f "%MARIADB_DIR%\bin\myisamchk.exe"
del /q /f "%MARIADB_DIR%\bin\myisamlog.exe"
del /q /f "%MARIADB_DIR%\bin\myisampack.exe"
:: keep mysql.exe
del /q /f "%MARIADB_DIR%\bin\mysql_embedded.exe"
:: keep mysql_install_db.exe
del /q /f "%MARIADB_DIR%\bin\mysql_plugin.exe"
del /q /f "%MARIADB_DIR%\bin\mysql_tzinfo_to_sql.exe"
:: keep mysql_upgrade.exe
:: keep mysql_upgrade_service.exe
:: keep mysql_upgrade_wizard.exe
:: keep mysqladmin.exe
del /q /f "%MARIADB_DIR%\bin\mysqlbinlog.exe"
:: keep mysqlcheck.exe
:: keep mysqld.exe
del /q /f "%MARIADB_DIR%\bin\mysqlimport.exe"
del /q /f "%MARIADB_DIR%\bin\mysqlshow.exe"
del /q /f "%MARIADB_DIR%\bin\mysqltest.exe"
del /q /f "%MARIADB_DIR%\bin\mysqltest_embedded.exe"
del /q /f "%MARIADB_DIR%\bin\mysql_client_test.exe"
del /q /f "%MARIADB_DIR%\bin\mysql_client_test_embedded.exe"
del /q /f "%MARIADB_DIR%\bin\echo.exe"
del /q /f "%MARIADB_DIR%\bin\mysqlslap.exe"
del /q /f "%MARIADB_DIR%\bin\replace.exe"
::keep perror.exe

:: # 3) delete certain perl files
del /q /f "%MARIADB_DIR%\bin\mysql_convert_table_format.pl"
del /q /f "%MARIADB_DIR%\bin\mysql_secure_installation.pl"
del /q /f "%MARIADB_DIR%\bin\mysqld_multi.pl"
del /q /f "%MARIADB_DIR%\bin\mysqldumpslow.pl"
del /q /f "%MARIADB_DIR%\bin\mysqlhotcopy.pl"

:: ############# process the /data folder

del /s /q "%MARIADB_DIR%\data\performance_schema\*.*"
rd /s /q "%MARIADB_DIR%\data\performance_schema"

del /s /q "%MARIADB_DIR%\data\test\*.*"
rd /s /q "%MARIADB_DIR%\data\test"

:: ############# process the /lib folder

del /s /q "%MARIADB_DIR%\lib\*.pdb"
del /s /q "%MARIADB_DIR%\lib\*.lib"

:: ############# process the /share folder

:: whats left in this folder? english & german

rd /s /q "%MARIADB_DIR%\share\czech"
rd /s /q "%MARIADB_DIR%\share\danish"
rd /s /q "%MARIADB_DIR%\share\dutch"
rd /s /q "%MARIADB_DIR%\share\estonian"
rd /s /q "%MARIADB_DIR%\share\french"
rd /s /q "%MARIADB_DIR%\share\greek"
rd /s /q "%MARIADB_DIR%\share\italian"
rd /s /q "%MARIADB_DIR%\share\hungarian"
rd /s /q "%MARIADB_DIR%\share\japanese"
rd /s /q "%MARIADB_DIR%\share\korean"
rd /s /q "%MARIADB_DIR%\share\norwegian"
rd /s /q "%MARIADB_DIR%\share\norwegian-ny"
rd /s /q "%MARIADB_DIR%\share\polish"
rd /s /q "%MARIADB_DIR%\share\portuguese"
rd /s /q "%MARIADB_DIR%\share\romanian"
rd /s /q "%MARIADB_DIR%\share\russian"
rd /s /q "%MARIADB_DIR%\share\serbian"
rd /s /q "%MARIADB_DIR%\share\spanish"
rd /s /q "%MARIADB_DIR%\share\slovak"
rd /s /q "%MARIADB_DIR%\share\swedish"
rd /s /q "%MARIADB_DIR%\share\ukrainian"

:: ############# process the /support-files folder

:: wtf? a solaris script in a windows distribution?

rd /s /q "%MARIADB_DIR%\support-files"

:: ############# compress executables with UPX

::IF EXIST "%~dp0\upx\upx.exe" (
::    echo.
::   echo [x] Compressing MariaDB executables.
::    echo.
::
::    %~dp0\upx\upx.exe -9 %MARIADB_DIR%\bin\*.exe
::)

:: ############# DONE

echo.
echo [+] MariaDB stripdown done.
echo.
GOTO END;

:: ############# EOF GOTO TARGET

:EOF
echo.
echo [-] MariaDB stripdown failed.
echo.
pause

:: ############# Have a nice day.
:END