@echo off
:: Change this to ON when debugging this batch file.

SetLocal

cls

:: set window title
TITLE WPN-XM Server Stack for Windows - Build Script!

:: define shortcuts to commands
set SETCOLOR=bin\chgcolor\chgcolor.exe

%SETCOLOR% 0C
echo.
echo ^+--------------------------------------------------------------------------+
echo ^|                                                                          ^|
echo ^|  WPN-XM Server Stack for Windows - Build Script       Version 16.01.2012 ^|
echo ^|                                                                          ^|
echo ^+--------------------------------------------------------------------------+
echo ^|                                                                          ^|
echo ^|  The WPN-XM build process is automated with NANT.                        ^|
echo ^|                                                                          ^|
echo ^|  Author      Jens-Andre Koch (jakoch@web.de)                             ^|
echo ^|  License     GNU/GPL Version 2 and any later version                     ^|
echo ^|  Copyright   2008 - 2012                                                 ^|
echo ^|                                                                          ^|
echo ^|  Website     http://wpn-xm.org                                           ^|
echo ^|                                                                          ^|
echo ^+-------------------------------------------------------------------------^<3
echo.
%SETCOLOR% 07

%SETCOLOR% 0A

:: +-------------------------------------------------------------------------
:: | Execute Nant with WPN-XM buildfile 
:: +-------------------------------------------------------------------------
bin\nant\bin\nant.exe -buildfile:build.xml all 

%SETCOLOR% 07

EndLocal
:END
PAUSE