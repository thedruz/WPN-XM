@echo off
:: Change this to ON when debugging this batch file.

:: +-------------------------------------------------------------------------
:: | WPN-XM - Installation Script for phpUnit via PEAR.
:: | http://wpn-xm.org/
:: | Author: Jens-André Koch
:: +-----------------------------------------------------------------------<3

cls

:: set window title
TITLE WPN-XM Server Stack for Windows - phpUnit Installation Script

cd PEAR

:: upgrade pear

call pear upgrade-all

:: register channels

call pear channel-discover pear.phpunit.de
call pear channel-discover components.ez.no
call pear channel-discover pear.symfony-project.com

:: update all channels

call pear update-channels

:: install packages

call pear clear-cache
call pear install --alldeps --force phpunit/PHPUnit

cd ..