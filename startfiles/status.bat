@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Daemon Status Monitor
:: |
:: +-----------------------------------------------------------------------<3

:: set window title
TITLE WPN-XM Serverpack - Daemon Status Monitor

:LOOP-START

cls

echo Nginx
tasklist /FI "imagename eq nginx.exe"
echo.

echo PHP
tasklist /FI "imagename eq php-cgi.exe"
echo.

echo MariaDb
tasklist /FI "imagename eq mysqld.exe"
echo.

echo MongoDb
tasklist /FI "imagename eq mongod.exe"
echo.

echo Memcached
tasklist /FI "imagename eq memcached.exe"
echo.

echo Postgres
tasklist /FI "imagename eq postgres.exe"
echo.

echo PRESS ANY KEY TO REFRESH

pause>nul

GOTO LOOP-START