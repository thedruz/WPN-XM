@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Reset Database Password
:: |
:: +-----------------------------------------------------------------------<3

pushd "%~dp0"

echo Stopping MySQL
taskkill /f /IM mysqld.exe 1>nul 2>nul
del data\*.pid 1>nul 2>nul

echo.
echo Please enter a new password (no spaces, only use alphanumeric chars).
set /P password="New Password: "

echo.
echo Press any key to reset the password for the user "root" to "%password%" (without quotes) . . .
pause>nul

echo.
echo Updating User Table
echo UPDATE mysql.user SET Password=PASSWORD('%password%') WHERE User='root'; | bin\mariadb\bin\mysqld.exe --bootstrap --console

echo.
echo Updating wpn-xm.ini
     %~dp0bin\php\php.exe -r "file_put_contents('wpn-xm.ini', preg_replace('/(password)(.+)/','password=%password%', file_get_contents('wpn-xm.ini'), 1));"

echo.
echo DONE !
echo The password for the user "root" has now been reset to "%password%" (without quotes).
echo.

echo Remember to restart the database daemon.
echo Press any key to exit.
pause>nul