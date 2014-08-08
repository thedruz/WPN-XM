@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Execute Phing with WPN-XM build file
:: |
:: +-----------------------------------------------------------------------<3

SetLocal
cls

:: set window title
TITLE WPN-XM Server Stack for Windows - Build Script!

:: set shortcut to color command
set SETCOLOR=bin\chgcolor\chgcolor.exe

%SETCOLOR% 0C
echo.
echo ^+--------------------------------------------------------------------------+
echo ^|                                                                          ^|
echo ^|  WPN-XM Server Stack - Build Script                   http://wpn-xm.org/ ^|
echo ^|                                                                          ^|
echo ^+--------------------------------------------------------------------------+
echo ^|                                                                          ^|
echo ^|  The WPN-XM build process is automated with Phing.                       ^|
echo ^|                                                                          ^|
echo ^|  Author      Jens-Andre Koch (jakoch@web.de)                             ^|
echo ^|  Copyright   2010 - 2014                                                 ^|
echo ^|  License     MIT                                                         ^|
echo ^|                                                                          ^|
echo ^+-------------------------------------------------------------------------^<3
echo.
%SETCOLOR% 07


:: Execute Phing with WPN-XM build file, run task "all" and produce log
bin\phing\phing.bat -logfile build.log

EndLocal
:END
PAUSE