@echo off
cls

:: set window title
TITLE WPN-XM Server Stack for Windows - Generate SSL Certificate

pushd %~dp0
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout cert.key -out cert.pem -config ./openssl.cnf