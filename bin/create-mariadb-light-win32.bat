@echo off
:: Change this to ON when debugging this batch file.

:: +-------------------------------------------------------------------------
:: | MySQL 5.5.15 win32 - Stripdown Script
:: |
:: | Author: Jens-André Koch
:: +-----------------------------------------------------------------------<3

:: ############# Accept "path to mysql" as first parameter

:: Check - Parameter is not empty

IF "%1" == "" (
    ECHO Parameter missing.
    ECHO Please add the path to mysql.
    GOTO EOF;
)

:: Check - Parameter is folder

IF NOT EXIST "%1" (
    ECHO Folder "%1" not found.
    ECHO Provide a valid path to the mysql folder.
    GOTO EOF;
)

:. Check - Parameter is the mysql folder

IF NOT EXIST "%1\bin\mysqld.exe" (
    ECHO Folder "%1" exists, but is not the mysql folder.
    GOTO EOF;
)

:: Ok, now we know where mysql resides...

SET MYSQL_DIR=%1

echo %MYSQL_DIR%

:: ############# Toplevel remove *.ini - replaced by our own

:del /s /q "%MYSQL_DIR%\*.ini"

:: ############# remove these folders completely

rd /s /q "%MYSQL_DIR%\bin\debug"
rd /s /q "%MYSQL_DIR%\docs"
rd /s /q "%MYSQL_DIR%\include"
rd /s /q "%MYSQL_DIR%\mysql-test"
rd /s /q "%MYSQL_DIR%\scripts"
rd /s /q "%MYSQL_DIR%\sql-bench"

:: ############# process the /bin folder

:: # 1) delete pdb files (windows crashdumps debug files)

del /s /q "%MYSQL_DIR%\bin\*.pdb"

:: # 2) delete certain executables
:: This list of executables equals a MariaDB win32 msi install (with only database and no client executables)

del /q /f "%MYSQL_DIR%\bin\aria_chk.exe"
del /q /f "%MYSQL_DIR%\bin\aria_dump_log.exe"
del /q /f "%MYSQL_DIR%\bin\aria_ftdump.exe"
del /q /f "%MYSQL_DIR%\bin\aria_pack.exe"
del /q /f "%MYSQL_DIR%\bin\aria_read_log.exe"
:: keep my_print_defaults.exe
del /q /f "%MYSQL_DIR%\bin\myisam_ftdump.exe"
del /q /f "%MYSQL_DIR%\bin\myisamchk.exe"
del /q /f "%MYSQL_DIR%\bin\myisamlog.exe"
del /q /f "%MYSQL_DIR%\bin\myisampack.exe"
:: keep mysql.exe
del /q /f "%MYSQL_DIR%\bin\mysql_embedded.exe"
:: keep mysql_install_db.exe
del /q /f "%MYSQL_DIR%\bin\mysql_plugin.exe"
del /q /f "%MYSQL_DIR%\bin\mysql_tzinfo_to_sql.exe"
:: keep mysql_upgrade.exe
:: keep mysql_upgrade_service.exe
:: keep mysql_upgrade_wizard.exe
:: keep mysql_admin.exe
del /q /f "%MYSQL_DIR%\bin\mysqlbinlog.exe"
:: keep mysqlcheck.exe
:: keep mysqld.exe
del /q /f "%MYSQL_DIR%\bin\mysqlimport.exe"
del /q /f "%MYSQL_DIR%\bin\mysqlshow.exe"
del /q /f "%MYSQL_DIR%\bin\mysqld-debug.exe"
del /q /f "%MYSQL_DIR%\bin\mysqltest.exe"
del /q /f "%MYSQL_DIR%\bin\mysqltest_embedded.exe"
del /q /f "%MYSQL_DIR%\bin\mysql_client_test.exe"
del /q /f "%MYSQL_DIR%\bin\mysql_client_test_embedded.exe"
del /q /f "%MYSQL_DIR%\bin\echo.exe"
del /q /f "%MYSQL_DIR%\bin\mysqlslap.exe"
del /q /f "%MYSQL_DIR%\bin\replace.exe"
::keep perror.exe

:: # 3) delte certain perl files
del /q /f "%MYSQL_DIR%\bin\mysql_convert_table_format.pl"
del /q /f "%MYSQL_DIR%\bin\mysql_secure_installation.pl"
del /q /f "%MYSQL_DIR%\bin\mysqld_multi.pl"
del /q /f "%MYSQL_DIR%\bin\mysqldumpslow.pl"
del /q /f "%MYSQL_DIR%\bin\mysqlhotcopy.pl"

:: ############# process the /data folder

del /s /q "%MYSQL_DIR%\data\performance_schema\*.*"
rd /s /q "%MYSQL_DIR%\data\performance_schema"

del /s /q "%MYSQL_DIR%\data\test\*.*"
rd /s /q "%MYSQL_DIR%\data\test"

:: ############# process the /lib folder

del /s /q "%MYSQL_DIR%\lib\*.pdb"
del /s /q "%MYSQL_DIR%\lib\*.lib"

del /s /q "%MYSQL_DIR%\lib\debug\*.*"
rd /s /q "%MYSQL_DIR%\lib\debug"

del /s /q "%MYSQL_DIR%\lib\plugin\debug\*.*"
rd /s /q "%MYSQL_DIR%\lib\plugin\debug"

:: ############# process the /share folder

:: whats left in this folder? english, german...

rd /s /q "%MYSQL_DIR%\share\czech"
rd /s /q "%MYSQL_DIR%\share\danish"
rd /s /q "%MYSQL_DIR%\share\dutch"
rd /s /q "%MYSQL_DIR%\share\estonian"
rd /s /q "%MYSQL_DIR%\share\french"
rd /s /q "%MYSQL_DIR%\share\greek"
rd /s /q "%MYSQL_DIR%\share\italian"
rd /s /q "%MYSQL_DIR%\share\hungarian"
rd /s /q "%MYSQL_DIR%\share\japanese"
rd /s /q "%MYSQL_DIR%\share\korean"
rd /s /q "%MYSQL_DIR%\share\norwegian"
rd /s /q "%MYSQL_DIR%\share\norwegian-ny"
rd /s /q "%MYSQL_DIR%\share\polish"
rd /s /q "%MYSQL_DIR%\share\portuguese"
rd /s /q "%MYSQL_DIR%\share\romanian"
rd /s /q "%MYSQL_DIR%\share\russian"
rd /s /q "%MYSQL_DIR%\share\serbian"
rd /s /q "%MYSQL_DIR%\share\spanish"
rd /s /q "%MYSQL_DIR%\share\slovak"
rd /s /q "%MYSQL_DIR%\share\swedish"
rd /s /q "%MYSQL_DIR%\share\ukrainian"

:: ############# DONE

echo.
echo [+] MySQL stripdown done.
GOTO END;

:: ############# EOF GOTO TARGET

:EOF
echo.
echo [-] MySQL stripdown failed.
pause

:: ############# Have a nice day. jak, august 2011.
:END