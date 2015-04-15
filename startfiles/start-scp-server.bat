@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Start embedded PHP server for Webinterface
:: |
:: +-----------------------------------------------------------------------<3

:: stop embedded PHP Development Server ungracefully
%~dp0bin\tools\killprocess\Process.exe -k php.exe

:: start embedded PHP Development Server
start "localhost:90-WPN-XM Dev Server" /MIN %~dp0bin\php\php.exe -S localhost:90 -t %~dp0www

:: start WPN-XM Webinterface
start http://localhost:90/tools/webinterface