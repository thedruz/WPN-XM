@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Restart Daemons
:: |
:: +-----------------------------------------------------------------------<3

if not exist "run.bat" (
    echo "ERROR: run.bat is missing."
    goto END
)

if not exist "stop.bat" (
    echo "ERROR: stop.bat is missing."
    goto END
)

REM start all daemons, if no argument given (default)
REM else restart specific daemon, where $1 is the first cli argument, e.g. "restart.bat php"
if "%1"=="" (
    echo "Provide the component to restart (php, mariadb, memcached, nginx) as first argument."
    goto restart-all
) else (
    goto restart-%1
)
goto END

REM the start functions

:restart-all
    goto restart-php
    goto restart-mariadb
    goto restart-memcached
    goto restart-nginx
goto END

:restart-php
    echo Restarting PHP FastCGI...
    call stop.bat php
    call run.bat php
    echo.
goto END

:restart-mariadb
    echo Restarting MariaDb...
    call stop.bat mariadb
    call run.bat mariadb
    echo.
goto END

:restart-memcached
    echo Restarting Memcached...
    call stop.bat memcached
    call run.bat memcached
    echo.
goto END

:restart-nginx
    echo Restarting Nginx...
    call stop.bat nginx
    call run.bat nginx
    echo.
goto END

GOTO END

:ERROR
pause>nul

:END