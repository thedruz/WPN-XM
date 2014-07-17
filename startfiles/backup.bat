@echo off
::
:: WPN-XM Backup
::

:: Define the folders to backup

:: Define onw oe multiple folders in backup-folders file.
:: - put each folder on a new line
:: - folders must end with a backslash (\)
:: - when space in path use quotes, like so "c:\Pa Th\"
set source="@.\bin\backup\backup-folders.txt"

:: Target Folder for Backups
:: The folder must end with backslash (\).
set backup_folder="C:\Backup\"

:: Temporary Working Dir
set working_folder="C:\Windows\Temp\"

set logfile=".\logs\backup.log"

:: Set Compression Level
set "fastest=-mx1 -md=64k -mfb=32 -ms=8m"
set "fast=-mx3 -md=1m -mfb=32 -ms=128m"
set "normal=-mx5 -md=16m -mfb=32 -ms=2g"
set "maximum=-mx7 -md=32m -mfb=64 -ms=4g"
set "ultra=-mx9 -md=64m -mfb=64 -ms=4g"
:: The following settings are available:
:: %fastest% %fast% %normal% %maximum% %ultra%
set compression=%normal%

:: multithreading (number of CPU cores to use)
set cores="-mmt="%NUMBER_OF_PROCESSORS%

echo Backup >> %logfile%
echo started  -- %date% %time% >> %logfile%
echo running... >> %logfile%

.\bin\backup\7z.exe u -t7z %backup_folder%backup_%date%.7z %cores% %compression% -up1q3r2x1y2z1w2 -ssw -o%working_folder% %source%

echo finished -- %date% %time% >> %logfile%
echo ------------------------------------------- >> %logfile%
echo. >> %logfile%
