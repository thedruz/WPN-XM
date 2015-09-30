@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Composer CLI Shortcut (Global Installation)
:: |
:: +-----------------------------------------------------------------------<3

:: set "\bin\composer"
SET COMPOSER_HOME="%~dp0"

:: set "\bin\composer\cache"
SET COMPOSER_CACHE_DIR="%~dp0cache"

:: call composer
echo "%~dp0..\php\php.exe" "%~dp0composer.phar" %*

pause