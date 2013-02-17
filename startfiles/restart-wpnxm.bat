@echo off

if not exist "start-wpnxm.exe" (
    echo "ERROR: start-wpnxm.exe is missing."
    goto END
)

if not exist "stop-wpnxm.exe" (
    echo "ERROR: stop-wpnxm.exe is missing."
    goto END
)

:: start all daemons, if no argument given (default)
if "%1"=="" (
    echo "Provide the component to restart (php, mariadb, memcached, nginx) as first argument."
    goto restart-all
) else (
    :: restart specific daemon
    :: where $1 is the first cli argument, e.g. "restart-wpnxm.exe php"
    call:restart-%1 
)
goto END

:: the start functions

:restart-all
    goto restart-php
    goto restart-mariadb
    goto restart-memcached
    goto restart-nginx
goto END

:restart-php
    echo Restarting PHP FastCGI...
    call stop-wpnxm.exe php
    call start-wpnxm.exe php
    echo.
goto END

:restart-mariadb
    echo Restarting MariaDb...
    call stop-wpnxm.exe mariadb
    call start-wpnxm.exe mariadb
    echo.
goto END

:restart-memcached
    echo Restarting Memcached...
    call stop-wpnxm.exe memcached
    call start-wpnxm.exe memcached
    echo.
goto END

:restart-nginx
    echo Restarting nginx...
    call stop-wpnxm.exe nginx
    call start-wpnxm.exe nginx
    echo.
goto END

GOTO END

:ERROR
pause>nul

:END