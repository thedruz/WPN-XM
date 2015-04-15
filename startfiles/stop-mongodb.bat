@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Stop MongoDb
:: |
:: +-----------------------------------------------------------------------<3

cls

%~dp0bin\mongodb\bin\mongo --eval "db.getSiblingDB('admin').shutdownServer()"

%~dp0bin\mongodb\bin\mongod --config "%~dp0bin\mongodb\mongodb.conf" --logpath "%~dp0logs\mongodb.log" --dbpath "%~dp0bin\mongodb\data\db" --repair

pause