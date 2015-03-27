@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Updater for PHARs (Global Installation)
:: |
:: +-----------------------------------------------------------------------<3

IF EXIST "%~dp0composer.phar" (
    "%~dp0php.exe" "%~dp0\composer.phar" self-update
)

IF EXIST "%~dp0phpunit.phar" (
    "%~dp0php.exe" "%~dp0\phpunit.phar" --self-update
)

IF EXIST "%~dp0php-cs-fixer.phar" (
    "%~dp0php.exe" "%~dp0\php-cs-fixer.phar" self-update
)

pause