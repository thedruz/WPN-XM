@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Repair MongoDb
:: |
:: +-----------------------------------------------------------------------<3

cls

%cd%\bin\mongodb\bin\mongod.exe --repair --logpath "%cd%\logs\mongodb.log" --dbpath "%cd%\bin\mongodb\data\db"

pause