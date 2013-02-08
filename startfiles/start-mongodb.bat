@echo off

cls

IF NOT EXIST "%cd%\bin\mongodb\data" (
    echo .
    echo Creating Directory for Mongo's Database (data)
    mkdir "%cd%\bin\mongodb\data"
)


IF NOT EXIST "%cd%\bin\mongodb\data\db" (
    echo .
    echo Creating Directory for Mongo's Database (db)
    mkdir "%cd%\bin\mongodb\data\db"
)

IF NOT EXIST "%cd%\logs\mongodb.log" (
    echo.
    echo Creating empty logfile... "%cd%\logs\mongodb.log"
    echo. 2>"%cd%\logs\mongodb.log"
)

SET HIDECONSOLE=%cd%\bin\tools\RunHiddenConsole.exe

echo.
echo Starting MongoDB
     %cd%\bin\mongodb\bin\mongod.exe --config %cd%\bin\mongodb\mongodb.conf --logpath %cd%\logs\mongodb.log
echo.
pause