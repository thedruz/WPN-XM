@echo off

cls

:: "db = connect("localhost:27017/admin"); db.shutdownServer(); quit();""

%cd%\bin\mongodb\bin\mongo --eval "db.getSiblingDB('admin').shutdownServer()"

pause