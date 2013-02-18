@echo off

if not exist "start-wpnxm.bat" (
    echo "ERROR: start-wpnxm.bat is missing."
    goto END
)

if not exist "stop-wpnxm.bat" (
    echo "ERROR: stop-wpnxm.bat is missing."
    goto END
)

:: start all daemons, if no argument given (default)
if "%1"=="" (
    echo "Provide the component to restart (php, mariadb, memcached, nginx) as first argument."
    goto restart-all
) else (
    :: restart specific daemon
    :: where $1 is the first cli argument, e.g. "restart-wpnxm.bat php"
    goto restart-%1
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
    call stop-wpnxm.bat php
    call start-wpnxm.bat php
    echo.
goto END

:restart-mariadb
    echo Restarting MariaDb...
    call stop-wpnxm.bat mariadb
    call start-wpnxm.bat mariadb
    echo.
goto END

:restart-memcached
    echo Restarting Memcached...
    call stop-wpnxm.bat memcached
    call start-wpnxm.bat memcached
    echo.
goto END

:restart-nginx
    echo Restarting nginx...
    call stop-wpnxm.bat nginx
    call start-wpnxm.bat nginx
    echo.
goto END

GOTO END

:ERROR
pause>nul

:END