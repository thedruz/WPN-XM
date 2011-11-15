@echo off
:: Change this to ON when debugging this batch file.

SetLocal

cls

:: set window title
TITLE Clansuite Serverpack for Windows - Build Script!

:: define shortcuts to commands
set SETCOLOR=bin\software\chgcolor\chgcolor.exe

%SETCOLOR% 0C
echo ^+--------------------------------------------------------------------------+
echo ^|                                                                          ^|
echo ^|  Clansuite Serverpack for Windows - Build Script       Version 14.08.11  ^|
echo ^|                                                                          ^|
echo ^+--------------------------------------------------------------------------+
echo ^|                                                                          ^|
echo ^|  Windows Batch Script for building the Clansuite Serverpack for Windows. ^| 
echo ^|                                                                          ^|
echo ^|  @author    Jens-Andre Koch (jakoch@web.de)   @copyright 2008 - 2011     ^|
echo ^|  @author    Florian Wolf                      @copyright 2009            ^|
echo ^|  @license   GNU/GPL Version 2 and any later version                      ^|
echo ^|                                                                          ^|
echo ^|  @link      http://clansuite.com                                         ^|
echo ^|                                                                          ^|
echo ^+-------------------------------------------------------------------------^<3
echo.
%SETCOLOR% 07

:: +-------------------------------------------------------------------------
:: | Constants 
:: +-------------------------------------------------------------------------

SET ServerpackVersion=0.1
SET ServerpackDir="serverpack-%ServerpackVersion%"

:: +-------------------------------------------------------------------------
:: | Version Numbers
:: +-------------------------------------------------------------------------

SET Nginx-Version=nginx-1.1.0

SET PHP-Version=php-5.3.6-nts-Win32-VC9-x86

SET MySQL-Version=mysql-5.5.15-win32

:: +-------------------------------------------------------------------------
:: | Download URLs
:: +-------------------------------------------------------------------------

SET NginxURL=http://nginx.org/download/%Nginx-Version%.zip

SET PHPURL=http://windows.php.net/downloads/releases/%PHP-Version%.zip

SET MySQLURL=ftp://ftp.gwdg.de/pub/misc/mysql/Downloads/MySQL-5.5/%MySQL-Version%.zip

:: +-------------------------------------------------------------------------
:: | Path Shortcuts
:: +-------------------------------------------------------------------------

SET DownloadDir="%~dp0downloads"
SET UnxUtils=bin\software\UnxUtils

:: +-------------------------------------------------------------------------
:: | Recreate Temporary Path & Download Dir
:: +-------------------------------------------------------------------------

cd %~dp0

if exist "%~dp0tmp" (  
  rmdir /S /Q "%~dp0tmp"
)

if not exist "%~dp0tmp" (
        mkdir "%~dp0tmp"
)

if not exist "%~dp0downloads" (
        mkdir "%~dp0downloads"
)

:InstallNginx
%SETCOLOR% 1f
echo.
echo ^+--------------------------------------------------------------------------+
echo ^|                                                                          ^|
echo ^|   Installing NGINX ( %Nginx-Version% )                                       ^|
echo ^|                                                                          ^|
echo ^+--------------------------------------------------------------------------+
echo.
%SETCOLOR% 07

echo  - downloading ... & echo.

%UnxUtils%\wget.exe %NginxURL% -O %DownloadDir%\nginx.zip

echo  - unzipping ...

%UnxUtils%\unzip.exe %DownloadDir%\nginx.zip -d tmp\

echo  - renaming ... 

rename "%~dp0tmp\%Nginx-Version%" nginx

%SETCOLOR%  0a & echo  - done & %SETCOLOR% 07

:: ------------------------------------------------------------------------------
:: TODO 
:: ------------------------------------------------------------------------------
:: i'm still trying to figure out, how a unzip one-liner works, which simply drops the parent folder when unzipping
::
:: only the parent folder name
:: unzip -l clansuite.zip | gawk "{ print $4 }" | gawk -F "\/" "{ print $1 }"
::
:: all files und subfolders without parent folder name - well, just the slashes are missing... anyone?
:: unzip -l clansuite.zip | gawk "{ print $4 }" | gawk -F"\/" "{ print $2 $3 $4 $5 $6 $7 }"

:InstallMySQL
%SETCOLOR% 1f
echo.
echo ^+--------------------------------------------------------------------------+
echo ^|                                                                          ^|
echo ^|   Installing MySQL Community Server ( %MySQL-Version% )               ^|
echo ^|                                                                          ^|
echo ^+--------------------------------------------------------------------------+
echo.
%SETCOLOR% 07

echo  - downloading ... & echo.

%UnxUtils%\wget.exe %MySQLURL% -O %DownloadDir%\mysql.zip

echo  - unzipping ...

%UnxUtils%\unzip.exe -o %DownloadDir%\mysql.zip -d tmp\

echo  - renaming ... 

rename "%~dp0tmp\%MySQL-Version%" mysql

:: Cleanup MySQL after download

call cleanup-%MySQL-Version%.bat "%~dp0tmp\mysql"

%SETCOLOR%  0a & echo  - done & %SETCOLOR% 07

:InstallPHP
%SETCOLOR% 1f
echo.
echo ^+--------------------------------------------------------------------------+
echo ^|                                                                          ^|
echo ^|   Installing PHP ( %PHP-Version% )                         ^|
echo ^|                                                                          ^|
echo ^+--------------------------------------------------------------------------+
echo.
%SETCOLOR% 07

echo  - downloading ... & echo.

%UnxUtils%\wget.exe %PHPURL% -O %DownloadDir%\php.zip

echo  - unzipping ...

%UnxUtils%\unzip.exe -o %DownloadDir%\php.zip -d tmp\php

%SETCOLOR%  0a & echo  - done & %SETCOLOR% 07

:InstallPHPXDebug
%SETCOLOR% 1f
echo.
echo ^+--------------------------------------------------------------------------+
echo ^|                                                                          ^|
echo ^|   Installing XDebug extension for PHP                                    ^|
echo ^|                                                                          ^|
echo ^+--------------------------------------------------------------------------+
echo.

echo  - downloading ... & echo. 

%UnxUtils%\wget.exe http://xdebug.org/files/php_xdebug-2.1.2-5.3-vc9-nts.dll -O %DownloadDir%\tmp\php\ext\php_xdebug.dll

%SETCOLOR%  0a & echo  - done & %SETCOLOR% 07

:RemoveDownloads
%SETCOLOR% 1f
echo.
echo ^+--------------------------------------------------------------------------+
echo ^|                                                                          ^|
echo ^|   Removing Downloads                                                     ^|
echo ^|                                                                          ^|
echo ^+--------------------------------------------------------------------------+
echo.
%SETCOLOR% 07

rd /s /q "%~dp0tmp\downloads"

rename "%~dp0tmp" "%ServerpackDir%"

:CopyConfigs
%SETCOLOR% 1f
echo.
echo ^+--------------------------------------------------------------------------+
echo ^|                                                                          ^|
echo ^|   Copying Files                                                          ^|
echo ^|                                                                          ^|
echo ^+--------------------------------------------------------------------------+
echo.
%SETCOLOR% 07

:: Copy MySQL Configuration

xcopy /Y /Q "%~dp0configs\my.ini" "%ServerpackDir%\mysql\" > nul

:: Copy Nginx Configuration

xcopy /Y /Q "%~dp0configs\nginx.conf" "%ServerpackDir%\nginx\conf" > nul

:: Copy PHP Configuration

xcopy /Y /Q "%~dp0configs\php.ini" "%ServerpackDir%\php\" > nul

:: Additional documents

xcopy /Y /Q "%~dp0\readme.asciidoc" "%ServerpackDir%\readme.txt" > nul
xcopy /Y /Q "%~dp0\license.txt" "%ServerpackDir%\" > nul

:: Write Serverpack executables

xcopy /Y /Q "%~dp0\startfiles\start.bat" "%~dp0tmp\" > nul
xcopy /Y /Q "%~dp0\startfiles\stop.bat" "%~dp0tmp\" > nul

:: Remove Nginx default html folder

rd /s /q "%~dp0%ServerpackDir%\nginx\html"

%SETCOLOR%  0a & echo  - done & %SETCOLOR% 07

:compile
echo.
echo  ---------------------------------------------------------------------------
echo  #
echo  #   Build Package with InnoSetup
echo  #
echo  ---------------------------------------------------------------------------
echo.

SET INNOCOMPILER="%~dp0\bin\software\InnoSetup5\ISCC.exe"

echo  - compiling ... & echo. 

%INNOCOMPILER% "%~dp0config\clansuite_serverpack.iss" "/dtmpPath=%~dp0tmp\" "/dCVersion=%ServerpackVersion%" "/dbinPath=%~dp0bin" "/dXVersion=%Nginx-Version%" "/o%~dp0bin"

%SETCOLOR%  0a & echo  - done & %SETCOLOR% 07

EndLocal
:END
PAUSE