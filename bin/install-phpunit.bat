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

:: upgrade pear

pear upgrade pear

:: register channels

pear channel-discover pear.phpunit.de
pear channel-discover components.ez.no
pear channel-discover pear.symfony-project.com

:: update all channels

pear update-channels

:: install packages

pear clear-cache
pear install --alldeps --force phpunit/PHPUnit