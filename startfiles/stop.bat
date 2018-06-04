@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Stop Daemons
:: |
:: +-----------------------------------------------------------------------<3

if exist "%SystemRoot%\System32\taskkill.exe" (
    echo Using "taskkill" to kill the processes.
    SET KILL-PROCESS=taskkill /F /IM
    GOTO :kill-processes
)

REM can't get tskill to work...
if exist "%SystemRoot%\System32\tskill.exe" (
    echo Using "tskill" to kill the processes.
    SET KILL-PROCESS=tskill /A
    GOTO :kill-processes
)

echo Taskkill and tskill not found. Can't stop processes.
echo.
GOTO :EOF

:kill-processes

REM kill all daemons, if no argument given (default)
REM stop specific daemon, where %1 is the first cli argument, e.g. "stop-wpnxm.bat php"
IF "%1"=="" (
    call:stop-php
    call:stop-mariadb
    call:stop-memcached
    call:stop-nginx
) ELSE (
    call:stop-%1
)
GOTO END

:stop-nginx
    echo Stopping Nginx
    %KILL-PROCESS% nginx.exe
    echo.
goto :eof :: return to caller

:stop-php
    echo Stopping PHP-CGI
    %KILL-PROCESS% php-cgi-spawner.exe
    %KILL-PROCESS% php-cgi.exe
    echo.
goto :eof :: return to caller

:stop-mariadb
    echo Stopping MySQL
    bin\mariadb\bin\mysqladmin --defaults-file=bin\mariadb\my.ini -uroot -h127.0.0.1 --protocol=tcp shutdown
    echo.
goto :eof :: return to caller

:stop-memcached
    echo Stopping Memcached
    %KILL-PROCESS% memcached.exe
    echo.
goto :eof :: return to caller

goto END

:ERROR
pause>nul

:END