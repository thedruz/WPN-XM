@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Repair MongoDb
:: |
:: +-----------------------------------------------------------------------<3

cls

%~dp0bin\mongodb\bin\mongod.exe --repair --logpath "%~dp0logs\mongodb.log" --dbpath "%~dp0bin\mongodb\data\db"

pause