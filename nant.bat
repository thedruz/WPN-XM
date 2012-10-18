@echo off
:: Change this to ON when debugging this batch file.

SetLocal

cls

:: set window title
TITLE WPN-XM Server Stack for Windows - Build Script!

:: +-------------------------------------------------------------------------
:: | Execute Nant with WPN-XM build file
:: +-------------------------------------------------------------------------
bin\nant\bin\nant.exe -buildfile:build.xml %1

EndLocal
:END
PAUSE