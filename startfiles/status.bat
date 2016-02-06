@ECHO OFF
REM change console charset "codepage" to UTF-8
CHCP 65001


:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Daemon Status Monitor
:: |
:: +-----------------------------------------------------------------------<3

:: set window title
TITLE WPN-XM Serverpack - Daemon Status Monitor

:LOOP-START
CLS
echo.
echo    WPN-XM Server Stack - Status Monitor
echo.

echo   ┌──────────────────────────────┐
echo   │            Nginx             │
echo   └──────────────────────────────┘
tasklist /FI "imagename eq nginx.exe"
echo.

echo   ┌──────────────────────────────┐
echo   │             PHP              │
echo   └──────────────────────────────┘
tasklist /FI "imagename eq php-cgi.exe"
echo.

echo   ┌──────────────────────────────┐
echo   │           MariaDb            │
echo   └──────────────────────────────┘
tasklist /FI "imagename eq mysqld.exe"
echo.

echo   ┌──────────────────────────────┐
echo   │           MongoDb            │
echo   └──────────────────────────────┘
tasklist /FI "imagename eq mongod.exe"
echo.

echo   ┌──────────────────────────────┐
echo   │           Memcached          │
echo   └──────────────────────────────┘
tasklist /FI "imagename eq memcached.exe"
echo.

echo   ┌──────────────────────────────┐
echo   │           Postgres           │
echo   └──────────────────────────────┘
tasklist /FI "imagename eq postgres.exe"
echo.

echo PRESS ANY KEY TO REFRESH

pause>nul

GOTO LOOP-START