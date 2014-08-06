@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Phing shortcut
:: |
:: +-----------------------------------------------------------------------<3

SetLocal
cls

:: set window title
TITLE WPN-XM Server Stack for Windows - Phing shortcut

:: Execute Phing with WPN-XM build file
bin\phing\phing.bat -f %~dp0build.xml %1

EndLocal
:END
PAUSE