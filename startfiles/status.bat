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

tasklist /FI "imagename eq nginx.exe"
echo.

tasklist /FI "imagename eq php-cgi.exe"
echo.

tasklist /FI "imagename eq mysqld.exe"
echo.

tasklist /FI "imagename eq memcached.exe"
echo.

tasklist /FI "imagename eq postgres.exe"
echo.

echo PRESS ANY KEY TO REFRESH

pause>nul

GOTO LOOP-START