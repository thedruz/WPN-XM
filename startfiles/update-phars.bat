@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Updater for PHARs (Global Installation)
:: |
:: +-----------------------------------------------------------------------<3

"%~dp0php.exe" "%~dp0composer.phar" self-update

"%~dp0php.exe" "%~dp0phpunit.phar" --self-update

"%~dp0php.exe" "%~dp0php-cs-fixer.phar" self-update

pause