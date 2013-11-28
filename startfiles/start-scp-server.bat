@echo off

:: stop embedded PHP Development Server ungracefully
%~dp0bin\tools\killprocess\Process.exe -k php.exe

:: start embedded PHP Development Server
start "localhost:90-WPN-XM Dev Server" /MIN %cd%\bin\php\php.exe -S localhost:90 -t %cd%\www

:: start WPN-XM Server Control Panel
start http://localhost:90/webinterface