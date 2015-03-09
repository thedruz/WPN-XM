@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Generate SSL Certificate
:: |
:: +-----------------------------------------------------------------------<3

cls

:: set window title
TITLE WPN-XM Server Stack for Windows - Generate SSL Certificate

pushd %~dp0

if not exist "%~dp0certs" (
    echo .
    echo Creating Certs folder... %~dp0certs
    echo .
    md %~dp0certs
)


openssl.exe req -x509 -nodes -days 365 -newkey rsa:2048 -keyout certs\cert.key -out certs\cert.pem -config openssl.cfg

echo .
echo "Find your new SSL Certificate in %~dp0certs"
echo .

pause