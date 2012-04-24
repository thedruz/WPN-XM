//
//          _\|/_
//          (o o)
// +-----oOO-{_}-OOo------------------------------------------------------+
// |                                                                      |
// |  WPN-XM Server Stack - Inno Setup Script File                        |
// |  --------------------------------------------                        |
// |                                                                      |
// |  WPN-XM is a free and open-source web server solution stack for      |
// |  professional PHP development on the Windows platform.               |
// |                                                                      |
// |  The groundation of this stack consists of NGINX, MariaDb and PHP.   |
// |                                                                      |
// |  The stack contains several additional tools you might install:      |
// |                                                                      |
// |   - Server Control Panel for controlling server daemons,             |
// |   - WPN-XM Webinterface for administration of the stack,             |
// |   - Xdebug, Xhprof, webgrind for php debugging purposes,             |
// |   - phpMyAdmin for MySQL database administration,                    |
// |   - memcached and APC for caching purposes,                          |
// |   - junctions for creating symlinks.                                 |
// |                                                                      |
// |  Author:   Jens-Andre Koch <jakoch@web.de>                           |
// |  Website:  http://wpn-xm.org                                         |
// |  License:  GNU/GPLv2+                                                |
// |                                                                      |
// |  Note for developers                                                 |
// |  -------------------                                                 |
// |  A good resource for developing and understanding                    |
// |  Inno Setup Script files is the official "Inno Setup Help".          |
// |  Website:  http://jrsoftware.org/ishelp/index.php                    |
// |                                                                      |
// |  This version of the WPN-XM install wizard integrates OpenCandy.     |
// |  OpenCandy Integration Manual for InnoSetup:                         |
// |  http://sdk.opencandy.com/inno/index.html                            |
// |                                                                      |
// +---------------------------------------------------------------------<3
//

// toggle for enabling/disabling the debug mode
# define DEBUG "@DEBUG@"

// defines the root folder
# define SOURCE_ROOT AddBackslash(SourcePath);

// defines for the setup section
#define AppName "WPN-XM Server Stack"
// the -APPVERSION- token is replaced during the nant build process
#define AppVersion "@APPVERSION@"
#define AppPublisher "Jens-André Koch"
#define AppURL "http://wpn-xm.org/"
#define AppSupportURL "https://github.com/jakoch/WPN-XM/issues/"

// we need to include the Sherlock Software\InnoTools\Downloader
# include SOURCE_ROOT + "..\bin\InnoToolsDownloader\it_download.iss"

// [OpenCandy] Constants and File Setup
// product name
#define OC_STR_MY_PRODUCT_NAME 'Open Candy Sample'
// key and secret for this product
#define OC_STR_KEY '748ad6d80864338c9c03b664839d8161'
#define OC_STR_SECRET 'dfb3a60d6bfdb55c50e1ef53249f1198'
// Relative path to OCSetupHlp.dll; if not in the same folder as wpn-xm.iss file.
#define OC_OCSETUPHLP_FILE_PATH "..\bin\opencandy\OCSetupHlp.dll"

[Setup]
AppId={{8E0B8E63-FF85-4B78-9C7F-109F905E1D3B}}
AppName={#AppName}
AppVerName={#AppName} {#AppVersion}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
AppCopyright=© {#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppSupportURL}
AppUpdatesURL={#AppURL}

// default installation folder is "c:\server". but user might change this via dialog.
DefaultDirName={sd}\server
DefaultGroupName="{#AppName}"
OutputBaseFilename="WPNXM-{#AppVersion}-Setup"
Compression=lzma/ultra
InternalCompressLevel=max
SolidCompression=true
CreateAppDir=true
ShowLanguageDialog=no
BackColor=clBlack
; [OpenCandy]
	; OpenCandy requires PrivilegesRequired admin
; [/OpenCandy]
; Request admin privileges for Windows Vista, 7.
PrivilegesRequired=admin
; [OpenCandy]
	; You must display the OpenCandy EULA during installation
	; before the OpenCandy offer screen. We recommend appending
	; the OpenCandy EULA to your own license agreement.
; [/OpenCandy]
LicenseFile="..\bin\opencandy\OpenCandy EULA.txt"

// create a log file, see [code] procedure CurStepChanged
SetupLogging=yes

VersionInfoVersion={#AppVersion}
VersionInfoCompany={#AppPublisher}
VersionInfoDescription={#AppName} {#AppVersion}
VersionInfoTextVersion={#AppVersion}
VersionInfoCopyright=Copyright (C) 2011 - 2012 {#AppPublisher}, All Rights Reserved.

SetupIconFile={#SOURCE_ROOT}..\bin\icons\Setup.ico
WizardImageFile={#SOURCE_ROOT}..\bin\icons\innosetup-wizard-images\banner-left-164x314.bmp
WizardSmallImageFile={#SOURCE_ROOT}..\bin\icons\innosetup-wizard-images\icon-topright-55x55.bmp

[Languages]
Name: en; MessagesFile: compiler:Default.isl
Name: de; MessagesFile: compiler:languages\German.isl

[Types]
Name: "full"; Description: "Full installation"
Name: "serverstack"; Description: "Server Stack with Administration Tools"
Name: "debug"; Description: "Server Stack with Debugtools"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Components]
Name: "serverstack"; Description: "Base of the WPN-XM Server Stack (Nginx & PHP & MariaDb)"; ExtraDiskSpaceRequired: 155000000; Types: full serverstack debug custom; Flags: fixed
Name: "webinterface"; Description: "WPN-XM - Webinterface for Serveradministration"; ExtraDiskSpaceRequired: 500000; Types: full serverstack debug
Name: "consoleinterface"; Description: "WPN-XM - Tray App for Serveradministration"; ExtraDiskSpaceRequired: 500000; Types: full serverstack debug
Name: "xdebug"; Description: "Xdebug - PHP Extension for Debugging"; ExtraDiskSpaceRequired: 300000; Types: full debug
Name: "webgrind"; Description: "Webgrind - Xdebug profiling web frontend"; ExtraDiskSpaceRequired: 500000; Types: full debug
Name: "xhprof"; Description: "XhProfiler - Hierarchical Profiler for PHP"; ExtraDiskSpaceRequired: 800000; Types: full debug
// memcached install means the daemon and the php extension
Name: "memcached"; Description: "Memcached - distributed memory caching"; ExtraDiskSpaceRequired: 400000; Types: full
Name: "zeromq"; Description: "ZeroMQ - PHP Extension for concurrent socket magic"; ExtraDiskSpaceRequired: 300000; Types: full
Name: "phpmyadmin"; Description: "phpMyAdmin - MySQL database administration webinterface"; ExtraDiskSpaceRequired: 3300000; Types: full
Name: "adminer"; Description: "Adminer - Database management in single PHP file"; ExtraDiskSpaceRequired: 200000; Types: full;
Name: "junction"; Description: "junction - Mircosoft tool for creating junctions (symlinks)"; ExtraDiskSpaceRequired: 157000; Types: full
Name: "pear"; Description: "PEAR - PHP Extension and Application Repository"; ExtraDiskSpaceRequired: 10000000; Types: full;

[Files]
// opencandy
Source: "{#OC_OCSETUPHLP_FILE_PATH}"; Flags: dontcopy ignoreversion;
// tools
Source: "..\bin\UnxUtils\unzip.exe"; DestDir: "{tmp}"; Flags: dontcopy
Source: "..\bin\HideConsole\RunHiddenConsole.exe"; DestDir: "{app}\bin\tools\"
Source: "..\bin\killprocess\Process.exe"; DestDir: "{app}\bin\tools\"
Source: "..\bin\cleanup-mysql-5.5.15-win32.bat"; DestDir: "{tmp}"
// incorporate the whole "www" folder into the setup
Source: "..\www\*"; DestDir: "{app}\www";  Flags: recursesubdirs; Excludes: "*\nbproject*"
// incorporate several startfiles
Source: "..\startfiles\administration.url"; DestDir: "{app}"
Source: "..\startfiles\localhost.url"; DestDir: "{app}"
Source: "..\startfiles\start-wpnxm.exe"; DestDir: "{app}"
Source: "..\startfiles\stop-wpnxm.exe"; DestDir: "{app}"
Source: "..\startfiles\status-wpnxm.bat"; DestDir: "{app}"
// config files
Source: "..\configs\php.ini"; DestDir: "{app}\bin\php"
Source: "..\configs\nginx.conf"; DestDir: "{app}\bin\nginx\conf"
Source: "..\configs\vhosts.conf"; DestDir: "{app}\bin\nginx\conf"
Source: "..\configs\my.ini"; DestDir: "{app}\bin\mariadb"

[Icons]
Name: "{group}\Start WPN-XM"; Filename: "{app}\start-wpnxm.exe"
Name: "{group}\Stop WPN-XM"; Filename: "{app}\stop-wpnxm.exe"
Name: "{group}\Status of WPN-XM"; Filename: "{app}\status-wpnxm.bat"
Name: "{group}\Localhost"; Filename: "{app}\localhost.url"
Name: "{group}\Administration"; Filename: "{app}\administration.url"
Name: {group}\{cm:ProgramOnTheWeb,{#AppName}}; Filename: {#AppURL}
Name: {group}\{cm:ReportBug}; Filename: {#AppSupportURL}
Name: "{group}\{cm:RemoveApp}"; Filename: "{uninstallexe}"
//Name: "{userdesktop}\My Program"; Filename: "{app}\start-wpnxm.exe"; Tasks: desktopicon
//Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\WPN-XM"; Filename: "{app}\start-wpnxm.exe"; Tasks: quicklaunchicon

[Tasks]
//Name: "quicklaunchicon"; Description: "Create a &Quick Launch icon"; GroupDescription: "Additional icons:"; Flags: unchecked
//Name: "desktopicon"; Description: "Create a &Desktop icon"; GroupDescription: "Additional icons:"; Flags: unchecked

[Run]
// Automatically started...
Filename: "{tmp}\cleanup-mysql-5.5.15-win32.bat"; Parameters: "{app}\bin\mariadb";
//Filename: "{app}\SETUP.EXE"; Parameters: "/x"
// User selected... these files are shown for launch after everything is done
//Filename: "{app}\README.TXT"; Description: "View the README file"; Flags: postinstall shellexec skipifsilent
//Filename: "{app}\SETUP.EXE"; Description: "Configure Server Stack"; Flags: postinstall nowait skipifsilent unchecked

[INI]
;Filename: {app}\php\php.ini,Section: PHP; Key: extenson; String: php_pdo_mysql.dll; Components: ;

[Messages]
// define wizard title and tray status msg
// both are normally defined in /bin/innosetup/default.isl
SetupAppTitle = Setup WPN-XM {#AppVersion}
SetupWindowTitle = Setup - {#AppName} {#AppVersion}

[CustomMessages]
de.WebsiteLink={#AppURL}
en.WebsiteLink={#AppURL}
de.ReportBug=Fehler melden
en.ReportBug=Report Bug
de.RemoveApp=WPN-XM Server Stack deinstallieren
en.RemoveApp=Uninstall WPN-XM Server Stack

[Dirs]
Name: "{app}\www"

[Code]
// open candy inno setup script
#include SOURCE_ROOT + "..\bin\opencandy\OCSetupHlp.iss"

// Constants and global variables
const
  // reassigning the preprocessor defined constant debug
  DEBUG = {#DEBUG};

  // Define download URLs for the software packages
  // Warning: Watch the protocol (Use http, not https!), if you add download links pointing to github.
  URL_nginx             = 'http://www.nginx.org/download/nginx-1.1.11.zip';
  URL_php               = 'http://windows.php.net/downloads/releases/php-5.4.0-nts-Win32-VC9-x86.zip';
  URL_mariadb           = 'http://mirror2.hs-esslingen.de/mariadb/mariadb-5.5.23/win2008r2-vs2010-i386-packages/mariadb-5.5.23-win32.zip';
  URL_phpext_xdebug     = 'http://xdebug.org/files/php_xdebug-2.2.0RC2-5.4-vc9-nts.dll';
  URL_webgrind          = 'http://webgrind.googlecode.com/files/webgrind-release-1.0.zip';
  // Leave the original url of xhprof in here ! we are fetching from paul reinheimers fork !
  //URL_xhprof          = 'http://nodeload.github.com/facebook/xhprof/zipball/master';
  URL_xhprof            = 'http://nodeload.github.com/preinheimer/xhprof/zipball/master';
  URL_memcached         = 'http://downloads.northscale.com/memcached-1.4.5-x86.zip';
  URL_phpext_memcached  = 'http://downloads.php.net/pierre/php_memcache-2.2.6-5.3-vc9-x86.zip';
  URL_phpext_zeromq     = 'http://snapshot.zero.mq/download/win32/php53-ext/php-zmq-20111011_12-39.zip';
  URL_phpmyadmin        = 'http://netcologne.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/3.4.9/phpMyAdmin-3.4.9-english.zip';
  URL_adminer           = 'http://downloads.sourceforge.net/adminer/adminer-3.3.4.php';
  URL_junction          = 'http://download.sysinternals.com/files/Junction.zip';
  URL_pear              = 'http://pear.php.net/go-pear.phar';

  // Define file names for the downloads
  Filename_nginx            = 'nginx.zip';
  Filename_php              = 'php.zip';
  Filename_mariadb          = 'mariadb.zip';
  Filename_phpext_xdebug    = 'xdebug.dll';
  Filename_webgrind         = 'webgrind.zip';
  Filename_xhprof           = 'xhprof.zip';
  Filename_memcached        = 'memcached.zip';
  Filename_phpext_memcache  = 'phpext_memcache.zip'; // memcache without D
  Filename_phpext_zeromq    = 'zeromq.zip';
  Filename_phpmyadmin       = 'phpmyadmin.zip';
  Filename_adminer          = 'adminer.php';
  Filename_junction         = 'junction.zip';
  Filename_pear             = 'go-pear.phar';

var
  unzipTool: String;    // path+filename of unzip helper for exec
  returnCode: Integer;  // errorcode
  targetPath: String;   // if debug true will download to app/downloads, else temp dir

procedure UrlLabelClick(Sender: TObject);
var
  errorCode : integer;
begin
  ShellExec('','http://wpn-xm.org/','','', SW_SHOWNORMAL, ewNoWait, errorCode);
end;

procedure InitializeWizard();
var
  UrlLabel  : TNewStaticText;
  CancelBtn : TButton;
  OCtszInstallerLanguage : OCTString; // [OpenCandy] variable
begin
  // [OpenCandy] language init
  OCtszInstallerLanguage := ActiveLanguage;
  if(OCtszInstallerLanguage = 'default') then
    OCtszInstallerLanguage := 'en';

  // [OpenCandy] init, check for offers by asynchronous call
  OpenCandyAsyncInit('{#OC_STR_MY_PRODUCT_NAME}', '{#OC_STR_KEY}', '{#OC_STR_SECRET}', OCtszInstallerLanguage, {#OC_INIT_MODE_NORMAL});

  // download target path depends on debug constant
  if DEBUG = false then
  begin
    // Initialize InnoTools Download Helper
    itd_init;
    // Change from a simple overall progress bar to the detailed download view
    itd_setoption('UI_DetailedMode', '1');
    // when download fails, do not allow continuing with the installation
    itd_setoption('UI_AllowContinue', '0');
    // Start the download after the "Ready to install" screen is shown
    itd_downloadafter(wpReady);
    // reset files to download
    itd_clearfiles();
  end;

  // when debug enabled, do a one-time download of all components to a local folder
  if (DEBUG = true) and (FileExists(expandconstant('c:\wpnxm-downloads\nginx.zip')) = false) then
  begin
    // re-create the server stack folder
    if not DirExists(ExpandConstant('c:\wpnxm-downloads')) then ForceDirectories(ExpandConstant('c:\wpnxm-downloads'));
    // Initialize InnoTools Download Helper
    itd_init;
    // Turns on detailed error message popups for debugging the download process
    itd_setoption('Debug_Messages', '1');
    // Change from a simple overall progress bar to the detailed download view
    itd_setoption('UI_DetailedMode', '1');
    // when download fails, do not allow continuing with the installation
    itd_setoption('UI_AllowContinue', '0');
    // Start the download after the "Ready to install" screen is shown
    itd_downloadafter(wpReady);
    // reset files to download
    itd_clearfiles();
  end;

 // display website link in the bottom left corner of the install wizard
 CancelBtn := WizardForm.CancelButton;
 UrlLabel      := TNewStaticText.Create(WizardForm);
 UrlLabel.Top  := CancelBtn.Top + (CancelBtn.Height div 2) - (UrlLabel.Height div 2);
 UrlLabel.Left := WizardForm.ClientWidth - CancelBtn.Left - CancelBtn.Width;
 UrlLabel.Caption    := ExpandConstant('{cm:WebsiteLink}');
 UrlLabel.Font.Style := UrlLabel.Font.Style + [fsUnderline];
 UrlLabel.Cursor     := crHand;
 UrlLabel.Font.Color := clHighlight;
 UrlLabel.OnClick    := @UrlLabelClick;
 UrlLabel.Parent     := WizardForm;

 if DEBUG = true then  UrlLabel.Caption  := 'DEBUG ON    ' + UrlLabel.Caption;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True; // Allow action by default

  // [OpenCandy]
  if not OpenCandyNextButtonClick(CurPageID) then
    Result := false;

  if CurPageID = wpSelectComponents then
  begin

    if DEBUG = false then
    begin
      // using this path, the downloaded components are deleted after installation
      targetPath := expandconstant('{tmp}\');
    end else
    begin
      // using this path, the downloaded components are not deleted after installation
      targetPath := expandconstant('c:\wpnxm-downloads\');
    end;

    // add files to download handler

    if IsComponentSelected('serverstack') then
    begin
      itd_addfile(URL_nginx, expandconstant(targetPath + Filename_nginx));
      itd_addfile(URL_php, expandconstant(targetPath + Filename_php));
      itd_addfile(URL_mariadb, expandconstant(targetPath + Filename_mariadb));
    end;

    if IsComponentSelected('xdebug')    then itd_addfile(URL_phpext_xdebug, expandconstant(targetPath + Filename_phpext_xdebug));
    if IsComponentSelected('webgrind')  then itd_addfile(URL_webgrind,      expandconstant(targetPath + Filename_webgrind));
    if IsComponentSelected('xhprof')    then itd_addfile(URL_xhprof,        expandconstant(targetPath + Filename_xhprof));
    if IsComponentSelected('memcached') then
    begin
        itd_addfile(URL_memcached,          expandconstant(targetPath + Filename_memcached));
        itd_addfile(URL_phpext_memcached,   expandconstant(targetPath + Filename_phpext_memcache));
    end;

    if IsComponentSelected('zeromq')     then itd_addfile(URL_phpext_zeromq, expandconstant(targetPath + Filename_phpext_zeromq));
    if IsComponentSelected('phpmyadmin') then itd_addfile(URL_phpmyadmin,   expandconstant(targetPath + Filename_phpmyadmin));
    if IsComponentSelected('adminer') then itd_addfile(URL_adminer,   expandconstant(targetPath + Filename_adminer));
    if IsComponentSelected('junction') then itd_addfile(URL_junction,   expandconstant(targetPath + Filename_junction));
    if IsComponentSelected('pear')       then itd_addfile(URL_pear,          expandconstant(targetPath + Filename_pear));

  end;
end;

procedure DoUnzip(source: String; targetdir: String);
begin
    // source contains tmp constant, so resolve it to path name
    source := ExpandConstant(source);

    unzipTool := ExpandConstant('{tmp}\unzip.exe');

    if not FileExists(unzipTool)
    then MsgBox('UnzipTool not found: ' + unzipTool, mbError, MB_OK)
    else if not FileExists(source)
    then MsgBox('File was not found while trying to unzip: ' + source, mbError, MB_OK)
    else begin
         if Exec(unzipTool, '-o -qq "' + source + '" -d "' + targetdir + '"',
                 '', SW_HIDE, ewWaitUntilTerminated, ReturnCode) = false
         then begin
             MsgBox('Unzip failed:' + source, mbError, MB_OK)
         end;
    end;
end;

procedure UnzipFiles();
var
  selectedComponents: String;
begin
  selectedComponents := WizardSelectedComponents(false);

  // lets fetch the unzip command from the compressed setup
  ExtractTemporaryFile('unzip.exe');

  if not DirExists(ExpandConstant('{app}\bin')) then ForceDirectories(ExpandConstant('{app}\bin'));
  if not DirExists(ExpandConstant('{app}\www')) then ForceDirectories(ExpandConstant('{app}\www'));

  // always unzip the serverstack base

  DoUnzip(targetPath + Filename_nginx, ExpandConstant('{app}\bin')); // no subfolder, because nginx brings own dir

  DoUnzip(targetPath + Filename_php, ExpandConstant('{app}\bin\php'));

  DoUnzip(targetPath + Filename_mariadb, ExpandConstant('{app}\bin')); // no subfolder, brings own dir

  // unzip selected components

  // xdebug is not a zipped, its just a dll file, so copy it to the target path
  if Pos('xdebug', selectedComponents) > 0 then FileCopy(ExpandConstant(targetPath + Filename_phpext_xdebug), ExpandConstant('{app}\bin\php\ext\php_xdebug.dll'), false);

  if Pos('webgrind', selectedComponents) > 0 then DoUnzip(targetPath + Filename_webgrind, ExpandConstant('{app}\www')); // no subfolder, brings own dir

  if Pos('xhprof', selectedComponents) > 0 then DoUnzip(targetPath + Filename_xhprof, ExpandConstant('{app}\www')); // no subfolder, brings own dir

  if Pos('memcached', selectedComponents) > 0 then
  begin
    DoUnzip(targetPath + Filename_memcached, ExpandConstant('{app}\bin')); // no subfolder, brings own dir
    DoUnzip(targetPath + Filename_phpext_memcache, ExpandConstant('{app}\bin\php\ext'));
  end;

  if Pos('zeromq', selectedComponents) > 0 then DoUnzip(targetPath + Filename_phpext_zeromq, ExpandConstant('{app}\www')); // no subfolder, brings own dir

  if Pos('phpmyadmin', selectedComponents) > 0 then DoUnzip(targetPath + Filename_phpmyadmin, ExpandConstant('{app}\www')); // no subfolder, brings own dir

  // adminer is not a zipped, its just a php file, so copy it to the target path
  if Pos('adminer', selectedComponents) > 0 then FileCopy(ExpandConstant(targetPath + Filename_adminer), ExpandConstant('{app}\www\adminer\adminer.php'), false);
  
  if Pos('junction', selectedComponents) > 0 then DoUnzip(targetPath + Filename_junction, ExpandConstant('{app}\bin\tools'));

  // pear is not a zipped, its just a php phar package, so copy it to the php path
  if Pos('pear', selectedComponents) > 0 then FileCopy(ExpandConstant(targetPath + Filename_pear), ExpandConstant('{app}\bin\php\go-pear.php'), false);
end;

procedure ApplyModifications();
var
  php_ini_file : String;
  selectedComponents: String;
begin
  selectedComponents := WizardSelectedComponents(false);

  // config files

  php_ini_file := ExpandConstant('{app}\bin\php\php.ini');

  // modifications to the config files

  // nginx - rename directory
  Exec('cmd.exe', '/c "move ' + ExpandConstant('{app}\bin\nginx-*') + ' ' + ExpandConstant('{app}\bin\nginx') + '"',
  '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);

  // mariadb - rename directory
  Exec('cmd.exe', '/c "move ' + ExpandConstant('{app}\bin\mariadb-*') + '  ' + ExpandConstant('{app}\bin\mariadb') + '"',
   '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);

  // php
  SetIniString('PHP', 'error_log',            ExpandConstant('{app}\logs') + '\php_error.log', php_ini_file );
  SetIniString('PHP', 'doc_root',             ExpandConstant('{app}\www'), php_ini_file );
  SetIniString('PHP', 'include_path',         ExpandConstant('{app}\bin\php\pear'), php_ini_file );
  SetIniString('PHP', 'upload_tmp_dir',       ExpandConstant('{app}\temp'), php_ini_file );
  SetIniString('PHP', 'upload_max_filesize',  '8M', php_ini_file );
  SetIniString('PHP', 'session.save_path',    ExpandConstant('{app}\temp'), php_ini_file );

  // xdebug
  if Pos('xdebug', selectedComponents) > 0 then
  begin
      // add loading of xdebug.dll to php.ini
      if not IniKeyExists('Zend', 'zend_extension', php_ini_file) then
      begin
          SetIniString('Zend', 'zend_extension', ExpandConstant('{app}\bin\php\ext\php_xdebug.dll'), php_ini_file );
      end;

      // activate remote debugging
      SetIniString('Xdebug', 'xdebug.remote_enable',  'on', php_ini_file );
      SetIniString('Xdebug', 'xdebug.remote_handler', 'dbgp', php_ini_file );
      SetIniString('Xdebug', 'xdebug.remote_host',    'localhost', php_ini_file );
      SetIniString('Xdebug', 'xdebug.remote_port',    '9000', php_ini_file );
  end;

  if Pos('xhprof', selectedComponents) > 0 then
  begin
    // deactivated, because we are fetching from preinheimer's fork, see below
    // xhprof - rename "facebook-xhprof-gitref" directory
    //Exec('cmd.exe', '/c "move ' + ExpandConstant('{app}\www\facebook-xhprof*') + '  ' + ExpandConstant('{app}\www\xhprof') + '"',
    //'', SW_SHOW, ewWaitUntilTerminated, ReturnCode);

    // xhprof - rename "preinheimer-xhprof-gitref" directory
    Exec('cmd.exe', '/c "move ' + ExpandConstant('{app}\www\preinheimer-xhprof*') + '  ' + ExpandConstant('{app}\www\xhprof') + '"',
    '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);
  end;

  if Pos('memcached', selectedComponents) > 0 then
  begin
      // rename the existing directory
      Exec('cmd.exe', '/c "move ' + ExpandConstant('{app}\bin\memcached-x86') + ' ' + ExpandConstant('{app}\bin\memcached') + '"',
      '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);

      // php.ini entry for loading the the extension
      SetIniString('PHP', 'extension', 'php_memcache.dll', php_ini_file );
  end;

  if Pos('zeromq', selectedComponents) > 0 then
  begin
      // rename the existing directory
      //Exec('cmd.exe', '/c "move ' + ExpandConstant('{app}\bin\memcached-x86') + ' ' + ExpandConstant('{app}\bin\memcached') + '"',
      //'', SW_SHOW, ewWaitUntilTerminated, ReturnCode);

      // php.ini entry for loading the the extension
      SetIniString('PHP', 'extension', 'php_zmq.dll', php_ini_file );
  end;
  if Pos('phpmyadmin', selectedComponents) > 0 then
  begin
     // phpmyadmin - rename "phpMyAdmin-3.4.6-english" directory
    Exec('cmd.exe', '/c "move ' + ExpandConstant('{app}\www\phpMyAdmin-*') + '  ' + ExpandConstant('{app}\www\phpmyadmin') + '"',
    '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);
  end;

end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  logfilepathname : String;
  logfilename : String;
  newfilepathname : String;
begin
 // [OpenCandy]
 OpenCandyCurStepChanged(CurStep);

 if CurStep=ssInstall then
   begin
    UnzipFiles();
    ApplyModifications();
   end;

 if CurStep = ssDone then
   begin
     // copy logfile from tmp dir to the application dir, when the setup wizward is finished
     logfilepathname := ExpandConstant('{log}');
     logfilename := ExtractFileName(logfilepathname);
     newfilepathname := ExpandConstant('{app}\') +logfilename;
     filecopy(logfilepathname, newfilepathname, false);
   end;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  // [OpenCandy]
  OpenCandyCurPageChanged(CurPageID);
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := false; // Don't skip pages by default
  // [OpenCandy]
  if OpenCandyShouldSkipPage(PageID) then
    Result := true;
end;

function BackButtonClick(CurPageID: Integer): Boolean;
begin
  Result := true; // Allow action by default
  // [OpenCandy]
  OpenCandyBackButtonClick(CurPageID);
end;

procedure DeinitializeSetup();
begin
  // [OpenCandy]
  OpenCandyDeinitializeSetup();
end;