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
echo ^|  WPN-XM Server Stack - Build Script                   http://wpn-xm.org/ ^|
echo ^|                                                                          ^|
echo ^+--------------------------------------------------------------------------+
echo ^|                                                                          ^|
echo ^|  The WPN-XM build process is automated with NANT.                        ^|
echo ^|                                                                          ^|
echo ^|  Author      Jens-Andre Koch (jakoch@web.de)                             ^|
echo ^|  Copyright   2010 - 2014                                                 ^|
echo ^|  License     MIT                                                         ^|
echo ^|                                                                          ^|
echo ^+-------------------------------------------------------------------------^<3
echo.
%SETCOLOR% 07

:: +-------------------------------------------------------------------------
:: | Execute Nant with WPN-XM build file
:: +-------------------------------------------------------------------------
bin\nant\bin\nant.exe -buildfile:build.xml all -logfile:build.log

EndLocal
:END
PAUSE