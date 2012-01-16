@echo off

if not exist "%cd%\temp" (
    echo Creating Directories for Temporary Files...
    mkdir "%cd%\temp"
)

if not exist "%cd%\logs" (
    echo Creating Directories for Logs...
    mkdir "%cd%\logs"
)

SET HIDECONSOLE=%cd%\bin\tools\RunHiddenConsole.exe

echo Starting PHP FastCGI...

:: 
:: PHP Bug?
::
:: PHP assumes the base path as "C:\php" and fails to load extensions
::
:: The two following lines will not work as expected:
::
:: SET PHPRC=%cd%\bin\php is not working
:: %HIDECONSOLE% %cd%\bin\php\php-cgi.exe -b 127.0.0.1:9000 -c %cd%\bin\php\php.ini

:: change dirs, so php will look in the current path for extensions first
%HIDECONSOLE% cd %cd%\bin\php
%HIDECONSOLE% php-cgi.exe -b 127.0.0.1:9000 -c php.ini
%HIDECONSOLE% cd ..
%HIDECONSOLE% cd ..
echo.

echo Starting MariaDb...
%HIDECONSOLE% %cd%\bin\mariadb\bin\mysqld.exe --defaults-file=%cd%\bin\mariadb\my.ini
echo.

echo Starting Memcached...
%HIDECONSOLE% %cd%\bin\memcached\memcached.exe -p 11211 -U 0 -t 2 -c 2048 -m 2048
echo.

echo Starting nginx...
%HIDECONSOLE% %cd%\bin\nginx\nginx.exe -p %cd% -c %cd%\bin\nginx\conf\nginx.conf
echo.

echo Opening localhost in Browser...
start http://localhost/

GOTO END

:ERROR
pause>nul

:END