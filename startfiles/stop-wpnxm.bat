@echo off
:: Change this to ON when debugging this batch file.

SET PATH-OF-WIN-CMDS=%SystemRoot%\System32

if exist "%PATH-OF-WIN-CMDS%\taskkill.exe" (
    echo Using "taskkill" to kill the processes.
    SET KILL-PROCESS=taskkill /F /IM
    GOTO :kill-processes
)

if exist "%~dp0bin\tools\killprocess\Process.exe" (
    echo Using "process" to kill the processes.
    SET KILL-PROCESS=%~dp0bin\tools\killprocess\Process.exe -k
    GOTO :kill-processes
)

: can't get tskill to work...
if exist "%PATH-OF-WIN-CMDS%\tskill.exe" (
    echo Using "tskill" to kill the processes.
    SET KILL-PROCESS=tskill /A
    GOTO :kill-processes
)

echo Taskkill and tskill not found. Can't stop processes.
echo.
GOTO :EOF

:kill-processes

:: kill all daemons, if no argument given (default)
IF "%1"=="" (
    call:stop-php
    call:stop-mariadb
    call:stop-memcached
    call:stop-nginx
    call:stop-browser
) ELSE ( 
    :: stop specific daemon
    :: where $1 is the first cli argument, e.g. "stop-wpnxm.bat php"
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
    %KILL-PROCESS% php-cgi.exe
    echo.
goto :eof :: return to caller

:stop-mariadb
    echo Stopping MySQL
    %KILL-PROCESS% mysqld.exe
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