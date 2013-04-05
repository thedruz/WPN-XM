@echo off

:: set window title
TITLE WPN-XM Serverpack - Relocate

:: adjust nginx.conf (include path)

:: adjust php.ini

:: adjust mariadb my.ini
:: log-error=$PATH/logs/mariadb_error.log

:: delete all temporary files
del /s /q temp

echo.
echo WPN-XM was successfully relocated!