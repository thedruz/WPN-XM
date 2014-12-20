@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Stop MongoDb
:: |
:: +-----------------------------------------------------------------------<3

cls

%cd%\bin\mongodb\bin\mongo --eval "db.getSiblingDB('admin').shutdownServer()"

%cd%\bin\mongodb\bin\mongod --config "%cd%\bin\mongodb\mongodb.conf" --logpath "%cd%\logs\mongodb.log" --dbpath "%cd%\bin\mongodb\data\db" --repair

pause