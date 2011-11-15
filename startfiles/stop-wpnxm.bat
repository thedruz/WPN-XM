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

echo Stopping Nginx
%KILL-PROCESS% nginx.exe
echo.

echo Stopping PHP-CGI
%KILL-PROCESS% php-cgi.exe
echo.

echo Stopping MySQL
%KILL-PROCESS% mysqld.exe
echo.

echo Stopping Memcache
%KILL-PROCESS% memcached.exe
echo.

:EOF