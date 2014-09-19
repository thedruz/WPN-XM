@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Stop MongoDb
:: |
:: +-----------------------------------------------------------------------<3

cls

%cd%\bin\mongodb\bin\mongo --eval "db.getSiblingDB('admin').shutdownServer()"

pause