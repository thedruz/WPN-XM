@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Installation Script for PEAR
:: |
:: +-----------------------------------------------------------------------<3

cls

:: set window title
TITLE WPN-XM Server Stack for Windows - PEAR Installation Script

:: display the help text, so that the user knows what to enter
echo.
echo  WPN-XM Server Stack for Windows - PEAR Installation Script
echo  ----------------------------------------------------------
echo.
echo  Please use this answer set, to go quickly through the installation of PEAR.
echo.
echo   (1) Are you installing a system-wide PEAR or a local copy? Type "local" and press Enter.
echo.
echo   (2) Please confirm local copy by typing 'yes': Type "yes" and press Enter.
echo.
echo   (3) Press 1.
echo.
echo   (4) Use the folder selection dialog and select your "WPN-XM installation folder/bin/php/PEAR".
echo.
echo   (5) You will see the same dialog, but with adjusted paths. Press Enter.
echo.
echo   (6) Would you like to alter php.ini? Type "yes" and press Enter.
echo.
echo   (7) Configuration file paths are shown. Press Enter. Congrats!
echo.

:: go pear
php.exe -d output_buffering=0 PEAR\go-pear.phar

pause