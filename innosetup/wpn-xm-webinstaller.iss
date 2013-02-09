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
// |   - WPN-XM Server Control Panel and WPN-XM Webinterface              |
// |     for controlling server daemons and administration of the stack,  |
// |   - Xdebug, Xhprof, webgrind for php debugging purposes,             |
// |   - phpMyAdmin and Adminer for MySQL database administration,        |
// |   - memcached and APC for caching purposes,                          |
// |   - PEAR and Composer for PHP package management,                    |
// |   - junctions for creating symlinks.                                 |
// |                                                                      |
// |  Author:   Jens-Andre Koch <jakoch@web.de>                           |
// |  Website:  http://wpn-xm.org/                                        |
// |  License:  GNU/GPLv2+                                                |
// |                                                                      |
// |  Note for developers                                                 |
// |  -------------------                                                 |
// |  A good resource for developing and understanding                    |
// |  Inno Setup Script files is the official "Inno Setup Help".          |
// |  Website:  http://jrsoftware.org/ishelp/index.php                    |
// |                                                                      |
// +---------------------------------------------------------------------<3
//

// toggle for enabling/disabling the debug mode
# define DEBUG "false"

// defines the root folder
#define SOURCE_ROOT AddBackslash(SourcePath);

// defines for the setup section
#define AppName "WPN-XM Server Stack"
// the -APPVERSION- token is replaced during the nant build process
#define AppVersion "@APPVERSION@"
#define AppPublisher "Jens-André Koch"
#define AppURL "http://wpn-xm.org/"
#define AppSupportURL "https://github.com/WPN-XM/WPN-XM/issues/new/"

// we need to include the Sherlock Software\InnoTools\Downloader
# include SOURCE_ROOT + "..\bin\InnoToolsDownloader\it_download.iss"

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
DefaultGroupName={#AppName}
OutputBaseFilename=WPNXM-{#AppVersion}-Setup
Compression=lzma2/ultra
LZMAUseSeparateProcess=yes
InternalCompressLevel=max
SolidCompression=true
CreateAppDir=true
ShowLanguageDialog=no
BackColor=clBlack
// formerly admin
PrivilegesRequired=none
// create a log file, see [code] procedure CurStepChanged
SetupLogging=yes
VersionInfoVersion={#AppVersion}
VersionInfoCompany={#AppPublisher}
VersionInfoDescription={#AppName} {#AppVersion}
VersionInfoTextVersion={#AppVersion}
VersionInfoCopyright=Copyright (C) 2011 - 2012 {#AppPublisher}, All Rights Reserved.
SetupIconFile={#SOURCE_ROOT}..\bin\icons\Setup.ico
WizardImageFile={#SOURCE_ROOT}..\bin\icons\innosetup-wizard-images\banner-left-164x314.bmp
WizardSmallImageFile={#SOURCE_ROOT}..\bin\icons\innosetup-wizard-images\icon-topright-55x55-stamp.bmp
; Tell Windows Explorer to reload the environment (because we are adding the PHP path to env var PATH)
ChangesEnvironment=yes
; Portable Mode
; a) do no create registry keys for uninstallation
CreateUninstallRegKey=not IsTaskSelected('portablemode')
; b) do not include uninstaller
Uninstallable=not IsTaskSelected('portablemode')

[Languages]
Name: en; MessagesFile: compiler:Default.isl
Name: de; MessagesFile: compiler:languages\German.isl

[Types]
Name: full; Description: Full installation
Name: serverstack; Description: Server Stack with Administration Tools
Name: debug; Description: Server Stack with Debugtools
Name: custom; Description: Custom installation; Flags: iscustom

[Components]
// Base Package "serverstack" consists of PHP + MariaDB + Nginx
Name: serverstack; Description: Base of the WPN-XM Server Stack (Nginx & PHP & MariaDb); ExtraDiskSpaceRequired: 197000000; Types: full serverstack debug custom; Flags: fixed
Name: adminer; Description: Adminer - Database management in single PHP file; ExtraDiskSpaceRequired: 355000; Types: full
Name: apc; Description: APC - PHP Extension for Caching (Alternative PHP Cache); ExtraDiskSpaceRequired: 100000; Types: full debug
Name: composer; Description: Composer - Dependency Manager for PHP; ExtraDiskSpaceRequired: 486000; Types: full
Name: junction; Description: junction - Mircosoft tool for creating junctions (symlinks); ExtraDiskSpaceRequired: 157000; Types: full
// memcached install means the daemon and the php extension
Name: memcached; Description: Memcached - distributed memory caching; ExtraDiskSpaceRequired: 400000; Types: full
Name: memadmin; Description: memadmin - memcached administration tool; ExtraDiskSpaceRequired: 125000;
Name: mongodb; Description: MongoDb - scalable, high-performance, open source NoSQL database; ExtraDiskSpaceRequired: 10000000; Types: full debug
Name: openssl; Description: OpenSSL - transport protocol security layer (SSL/TLS); ExtraDiskSpaceRequired: 1000000; Types: full
Name: pear; Description: PEAR - PHP Extension and Application Repository; ExtraDiskSpaceRequired: 3510000; Types: full
Name: phpmemcachedadmin; Description: phpMemcachedAdmin - memcached administration tool; ExtraDiskSpaceRequired: 50000; Types: full
Name: phpmyadmin; Description: phpMyAdmin - MySQL database administration webinterface; ExtraDiskSpaceRequired: 3300000; Types: full
Name: rockmongo; Description: RockMongo - MongoDB administration tool; ExtraDiskSpaceRequired: 1000000; Types: full debug
Name: sendmail; Description: Fake Sendmail - sendmail emulator; ExtraDiskSpaceRequired: 1000000; Types: full debug
Name: servercontrolpanel; Description: WPN-XM - Tray App for Serveradministration; ExtraDiskSpaceRequired: 500000; Types: full serverstack debug
Name: webgrind; Description: Webgrind - Xdebug profiling web frontend; ExtraDiskSpaceRequired: 500000; Types: full debug
Name: webinterface; Description: WPN-XM - Webinterface for Serveradministration; ExtraDiskSpaceRequired: 500000; Types: full serverstack debug
Name: xdebug; Description: Xdebug - PHP Extension for Debugging; ExtraDiskSpaceRequired: 300000; Types: full debug
Name: xhprof; Description: XhProfiler - Hierarchical Profiler for PHP; ExtraDiskSpaceRequired: 1000000; Types: full debug

[Files]
// tools:
Source: ..\bin\UnxUtils\unzip.exe; DestDir: {tmp}; Flags: dontcopy
Source: ..\bin\upx\upx.exe; DestDir: {tmp}; Flags: dontcopy
Source: ..\bin\HideConsole\RunHiddenConsole.exe; DestDir: {app}\bin\tools\
Source: ..\bin\killprocess\Process.exe; DestDir: {app}\bin\tools\
Source: ..\bin\hosts\hosts.exe; DestDir: {app}\bin\tools\
Source: ..\bin\generate-certificate.bat; DestDir: {app}\bin\openssl; Components: openssl
// psvince is install to app folder. it is needed during uninstallation, to to check if daemons are still running.
Source: ..\bin\psvince\psvince.dll; DestDir: {app}\bin\tools\
Source: ..\bin\stripdown-mariadb.bat; DestDir: {tmp}
Source: ..\bin\stripdown-mongodb.bat; DestDir: {tmp}; Components: mongodb
Source: ..\bin\install-phpunit.bat; DestDir:{app}\bin\php\
// incorporate the whole "www" folder into the setup, except webinterface folder
Source: ..\www\*; DestDir: {app}\www; Flags: recursesubdirs; Excludes: *\nbproject*,\webinterface;
// webinterface folder is only copied, if component is selected
Source: ..\www\webinterface\*; DestDir: {app}\www\webinterface; Flags: recursesubdirs; Excludes: *\nbproject*; Components: webinterface
// incorporate several startfiles
Source: ..\startfiles\administration.url; DestDir: {app}
Source: ..\startfiles\localhost.url; DestDir: {app}
Source: ..\startfiles\start-wpnxm.exe; DestDir: {app}
Source: ..\startfiles\stop-wpnxm.exe; DestDir: {app}
Source: ..\startfiles\restart-wpnxm.exe; DestDir: {app}
Source: ..\startfiles\status-wpnxm.bat; DestDir: {app}
Source: ..\startfiles\reset-db-pw.bat; DestDir: {app}
Source: ..\startfiles\go-pear.bat; DestDir: {app}\bin\php
// config files
Source: ..\configs\wpnxm.ini; DestDir: {app}
Source: ..\configs\php.ini; DestDir: {app}\bin\php
Source: ..\configs\nginx.conf; DestDir: {app}\bin\nginx\conf
Source: ..\configs\vhosts.conf; DestDir: {app}\bin\nginx\conf
Source: ..\configs\my.ini; DestDir: {app}\bin\mariadb
Source: ..\configs\config.inc.php; DestDir: {app}\www\phpmyadmin; Components: phpmyadmin
Source: ..\configs\xhprof.php; DestDir: {app}\www\xhprof\xhprof_lib; DestName: "config.php"; Components: xhprof

[Icons]
Name: {group}\Server Control Panel; Filename: {app}\wpnxm-scp.exe; Tasks: add_startmenu_entries
Name: {group}\Start WPN-XM; Filename: {app}\start-wpnxm.exe; Tasks: add_startmenu_entries
Name: {group}\Stop WPN-XM; Filename: {app}\stop-wpnxm.exe; Tasks: add_startmenu_entries
Name: {group}\Status of WPN-XM; Filename: {app}\status-wpnxm.bat; Tasks: add_startmenu_entries
Name: {group}\Localhost; Filename: {app}\localhost.url; Tasks: add_startmenu_entries
Name: {group}\Administration; Filename: {app}\administration.url; Tasks: add_startmenu_entries
Name: {group}\{cm:ProgramOnTheWeb,{#AppName}}; Filename: {#AppURL}; Tasks: add_startmenu_entries
Name: {group}\{cm:ReportBug}; Filename: {#AppSupportURL}; Tasks: add_startmenu_entries
Name: {group}\{cm:RemoveApp}; Filename: {uninstallexe}; Tasks: add_startmenu_entries
Name: {userdesktop}\WPN-XM Server-Control-Panel; Filename: {app}\wpnxm-scp.exe; Tasks: add_scp_desktopicon
Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\WPN-XM; Filename: {app}\wpnxm-scp.exe; Tasks: add_scp_quicklaunchicon
Name: {userdesktop}\WPN-XM Start; Filename: {app}\start-wpnxm.exe; Tasks: add_basic_start_stop_desktopicons
Name: {userdesktop}\WPN-XM Stop; Filename: {app}\stop-wpnxm.exe; Tasks: add_basic_start_stop_desktopicons

[Tasks]
Name: portablemode; Description: "Portable Mode"; Flags: unchecked
Name: add_startmenu_entries; Description: Create Startmenu entries
Name: add_scp_quicklaunchicon; Description: Create a &Quick Launch icon for the Server Control Panel; GroupDescription: Additional Icons:;
Name: add_scp_desktopicon; Description: Create a &Desktop icon for the Server Control Panel; GroupDescription: Additional Icons:;
Name: add_basic_start_stop_desktopicons; Description: Create &Desktop icons for starting and stopping; GroupDescription: Additional Icons:; Flags: unchecked

[Run]
// Automatically started...
Filename: {tmp}\stripdown-mariadb.bat; Parameters: "{app}\bin\mariadb";
Filename: {tmp}\stripdown-mongodb.bat; Parameters: "{app}\bin\mongodb"; Components: mongodb;
//Filename: {app}\SETUP.EXE; Parameters: /x
// User selected... these files are shown for launch after everything is done
//Filename: {app}\README.TXT; Description: View the README file; Flags: postinstall shellexec skipifsilent
//Filename: {app}\SETUP.EXE; Description: Configure Server Stack; Flags: postinstall nowait skipifsilent unchecked

[Registry]
; a registry change needs the following directive: [SETUP] ChangesEnvironment=yes
; add PHP path to environment variable PATH
; @todo the registry change is not performed, when we are in portable mode
Root: HKCU; Subkey: "Environment"; ValueType:string; ValueName:"PATH"; ValueData:"{olddata};{app}\php\bin"; Flags: preservestringtype

[Messages]
// define wizard title and tray status msg
// both are normally defined in /bin/innosetup/default.isl
SetupAppTitle =Setup WPN-XM {#AppVersion}
SetupWindowTitle =Setup - {#AppName} {#AppVersion}

[CustomMessages]
de.WebsiteLink={#AppURL}
en.WebsiteLink={#AppURL}
de.ReportBug=Fehler melden
en.ReportBug=Report Bug
de.RemoveApp=WPN-XM Server Stack deinstallieren
en.RemoveApp=Uninstall WPN-XM Server Stack

[Dirs]
Name: {app}\www
Name: {app}\www\webinterface; Components: webinterface;
Name: {app}\bin\nginx\conf\vhosts
Name: {app}\logs
Name: {app}\temp

[Code]
// Constants and global variables
const
  // reassigning the preprocessor defined constant debug
  DEBUG = {#DEBUG};

  // Define download URLs for the software packages
  // ----------------------------------------------
  // The majority of download URLs point to our redirection script.
  // The WPN-XM redirection script uses an internal software registry for looking
  // up the latest version and redirecting the installer to the download url.
  //
  // Warning: Watch the protocol (Use http, not https!), if you add download links pointing to github.
  //
  URL_adminer           = 'http://wpn-xm.org/get.php?s=adminer';
  URL_composer          = 'http://wpn-xm.org/get.php?s=composer';
  URL_junction          = 'http://wpn-xm.org/get.php?s=junction';
  URL_mariadb           = 'http://wpn-xm.org/get.php?s=mariadb';
  URL_memadmin          = 'http://wpn-xm.org/get.php?s=memadmin';
  URL_memcached         = 'http://wpn-xm.org/get.php?s=memcached';
  URL_mongodb           = 'http://wpn-xm.org/get.php?s=mongodb&v=2.0.8';
  URL_nginx             = 'http://wpn-xm.org/get.php?s=nginx';
  URL_openssl           = 'http://wpn-xm.org/get.php?s=openssl';
  URL_pear              = 'http://wpn-xm.org/get.php?s=pear';
  URL_php               = 'http://wpn-xm.org/get.php?s=php';
  URL_phpext_apc        = 'http://wpn-xm.org/get.php?s=phpext_apc';
  URL_phpext_memcache   = 'http://wpn-xm.org/get.php?s=phpext_memcache';
  URL_phpext_mongo      = 'http://wpn-xm.org/get.php?s=phpext_mongo';
  URL_phpext_xdebug     = 'http://wpn-xm.org/get.php?s=phpext_xdebug';
  URL_phpext_xhprof     = 'http://wpn-xm.org/get.php?s=phpext_xhprof';
  URL_phpmyadmin        = 'http://wpn-xm.org/get.php?s=phpmyadmin';
  URL_rockmongo         = 'http://wpn-xm.org/get.php?s=rockmongo';
  URL_sendmail          = 'http://wpn-xm.org/get.php?s=sendmail';
  URL_vcredist          = 'http://wpn-xm.org/get.php?s=vcredist';
  URL_webgrind          = 'http://wpn-xm.org/get.php?s=webgrind';
  URL_wpnxmscp          = 'http://wpn-xm.org/get.php?s=wpnxmscp';
  URL_xhprof            = 'http://wpn-xm.org/get.php?s=xhprof';
  URL_phpmemcachedadmin = 'http://wpn-xm.org/get.php?s=phpmemcachedadmin';

  // Define file names for the downloads
  Filename_adminer           = 'adminer.php';
  Filename_composer          = 'composer.phar';
  Filename_junction          = 'junction.zip';
  Filename_mariadb           = 'mariadb.zip';
  Filename_memadmin          = 'memadmin.zip';
  Filename_memcached         = 'memcached.zip';
  Filename_mongodb           = 'mongodb.zip';
  Filename_nginx             = 'nginx.zip';
  Filename_openssl           = 'openssl.exe';
  Filename_pear              = 'go-pear.phar';
  Filename_php               = 'php.zip';
  Filename_phpext_apc        = 'phpext_apc.zip';
  Filename_phpext_memcache   = 'phpext_memcache.zip'; // memcache without D
  Filename_phpext_xdebug     = 'phpext_xdebug.dll';
  Filename_phpext_xhprof     = 'phpext_xhprof.zip';
  Filename_phpmyadmin        = 'phpmyadmin.zip';
  Filename_rockmongo         = 'rockmongo.zip';
  Filename_sendmail          = 'sendmail.zip';
  Filename_vcredist          = 'vcredist_x86.exe';
  Filename_webgrind          = 'webgrind.zip';
  Filename_wpnxmscp          = 'wpnxmscp.zip';
  Filename_xhprof            = 'xhprof.zip';
  Filename_phpmemcachedadmin = 'phpmemcachedadmin.zip';
  Filename_phpext_mongo      = 'phpext_mongo.zip';

var
  unzipTool   : String;   // path+filename of unzip helper for exec
  returnCode  : Integer;  // errorcode
  targetPath  : String;   // if debug true will download to app/downloads, else temp dir
  appPath     : String;   // application path (= the installaton folder)
  InstallPage               : TWizardPage;
  percentagePerComponent    : Integer;

// Make vcredist x86 install if needed
// http://stackoverflow.com/questions/11137424/how-to-make-vcredist-x86-reinstall-only-if-not-yet-installed
#IFDEF UNICODE
  #DEFINE AW "W"
#ELSE
  #DEFINE AW "A"
#ENDIF
type
  INSTALLSTATE = Longint;
const
  INSTALLSTATE_INVALIDARG = -2;  // An invalid parameter was passed to the function.
  INSTALLSTATE_UNKNOWN = -1;     // The product is neither advertised or installed.
  INSTALLSTATE_ADVERTISED = 1;   // The product is advertised but not installed.
  INSTALLSTATE_ABSENT = 2;       // The product is installed for a different user.
  INSTALLSTATE_DEFAULT = 5;      // The product is installed for the current user.

  // software package = registry key to look for
  VC_2008_REDIST_X86 = '{FF66E9F6-83E7-3A3E-AF14-8DE9A809A6A4}';

function MsiQueryProductState(szProduct: string): INSTALLSTATE;
  external 'MsiQueryProductState{#AW}@msi.dll stdcall';

function VCVersionInstalled(const ProductID: string): Boolean;
begin
  Result := MsiQueryProductState(ProductID) = INSTALLSTATE_DEFAULT;
end;

{
  // The Result must be "True" when you need to install your VCRedist
  // or "False" when you don't need to.
}
function VCRedistributableNeedsInstall: Boolean;
begin
  Result := not (VCVersionInstalled(VC_2008_REDIST_X86));
end;

procedure UrlLabelClick(Sender: TObject);
var
  errorCode : integer;
begin
  ShellExec('','http://wpn-xm.org/','','', SW_SHOWNORMAL, ewNoWait, errorCode);
end;

{
  Custom wpInstalling Page with two progress bars.

  The first progress bar shows the total progress.
    (1 of 10 zips to unzip = 10 %)
  The second progress bar shows the current operation progress.
    (unzipping component 2: 25% of 100%)

  The Page is put into the install page loop via
  CurPageChanged(CurPageID) -> CurPageID=wpInstalling then CustomWpInstallingPage;
}
procedure CustomWpInstallingPage;
var
  { Total Progress Bar }
  TotalProgressBar                : TNewProgressBar;
  TotalProgressLabel              : TLabel;
  TotalProgressStaticText         : TNewStaticText;

  { Current Component Progress Bar }
  CurrentComponentProgressBar     : TNewProgressBar;
  CurrentComponentLabel           : TLabel;
  CurrentComponentStaticText      : TNewStaticText;

begin
  // CustomPage is shown after the wpReady page
  InstallPage := CreateCustomPage(wpReady,'Installation', 'Description');

  { Total Progress Bar }

  TotalProgressStaticText := TNewStaticText.Create(InstallPage);
  TotalProgressStaticText.Top := 16;
  TotalProgressStaticText.Caption := 'Total Progress';
  TotalProgressStaticText.AutoSize := True;
  TotalProgressStaticText.Parent := InstallPage.Surface;

  TotalProgressBar := TNewProgressBar.Create(InstallPage);
  TotalProgressBar.Name := 'TotalProgressBar'; // needed for FindComponent()
  TotalProgressBar.Left := 24;
  TotalProgressBar.Top := 40;
  TotalProgressBar.Width := 366;
  TotalProgressBar.Height := 24;
  TotalProgressBar.Min := 0
  TotalProgressBar.Max := 100
  TotalProgressBar.Parent := InstallPage.Surface;

  TotalProgressLabel := TLabel.Create(InstallPage);
  TotalProgressLabel.Name := 'TotalProgressLabel'; // needed for FindComponent()
  TotalProgressLabel.Top := TotalProgressStaticText.Top;
  TotalProgressLabel.Left := TotalProgressBar.Width;
  TotalProgressLabel.Caption := '0 %';
  TotalProgressLabel.Alignment := taRightJustify;
  TotalProgressLabel.Font.Style := [fsBold];
  TotalProgressLabel.Parent := InstallPage.Surface;

  { Current Component Progress Bar }

  CurrentComponentStaticText := TNewStaticText.Create(InstallPage);
  CurrentComponentStaticText.Top := 80;
  CurrentComponentStaticText.Caption := 'Extracting Component';
  CurrentComponentStaticText.AutoSize := True;
  CurrentComponentStaticText.Parent := InstallPage.Surface;

  CurrentComponentProgressBar := TNewProgressBar.Create(InstallPage);
  CurrentComponentProgressBar.Name := 'CurrentComponentProgressBar'; // needed for FindComponent()
  CurrentComponentProgressBar.Left := 24;
  CurrentComponentProgressBar.Top := 104;
  CurrentComponentProgressBar.Width := 366;
  CurrentComponentProgressBar.Height := 24;
  CurrentComponentProgressBar.Min := 0
  CurrentComponentProgressBar.Max := 100
  // Marquee displays some activity on the progressbar (pseudo progress)
  CurrentComponentProgressBar.Style := npbstMarquee;
  CurrentComponentProgressBar.Parent := InstallPage.Surface;

  CurrentComponentLabel := TLabel.Create(InstallPage);
  CurrentComponentLabel.Name := 'CurrentComponentLabel'; // needed for FindComponent()
  CurrentComponentLabel.Top := CurrentComponentStaticText.Top;
  CurrentComponentLabel.Width := 20;
  CurrentComponentLabel.Left := CurrentComponentProgressBar.Width;
  CurrentComponentLabel.Alignment := taRightJustify;
  CurrentComponentLabel.Caption := '';
  CurrentComponentLabel.Font.Style := [fsBold];
  CurrentComponentLabel.Parent := InstallPage.Surface;

  { Render Page }

  InstallPage.Surface.Show;       // show the new page
  InstallPage.Surface.Update;     // activate showing updates on this page
end;

procedure InitializeWizard();
var
  UrlLabel      : TNewStaticText;
  DebugLabel    : TNewStaticText;
  VersionLabel  : TLabel;
  VersionLabel2 : TLabel;
  CancelBtn     : TButton;
begin
  //change background colors of wizard pages and panels
  WizardForm.Mainpanel.Color:=$ECECEC;
  WizardForm.TasksList.Color:=$ECECEC;
  WizardForm.ReadyMemo.Color:=$ECECEC;
  WizardForm.WelcomePage.Color:=$ECECEC;
  WizardForm.FinishedPage.Color:=$ECECEC;
  WizardForm.WizardSmallBitmapImage.BackColor:=$ECECEC;

  //  Setup InnoTools Download Helper

  // Initialize InnoTools Download Helper
  ITD_Init;
  // Turns on detailed error message popups for debugging the download process
  if (DEBUG = true) then ITD_SetOption('Debug_Messages', '1');
  // Change from a simple overall progress bar to the detailed download view
  ITD_SetOption('UI_DetailedMode', '1');
  // when download fails, do not allow continuing with the installation
  ITD_SetOption('UI_AllowContinue', '0');
  // Start the download after the "Ready to install" screen is shown
  ITD_DownloadAfter(wpReady);
  // reset files to download
  ITD_ClearFiles();

  // Display the Version Number as overlay on the WizardImageFile (banner-left)
  // Label for the WelcomePage
  VersionLabel            := TLabel.Create(WizardForm);
  VersionLabel.Top        := 43;
  VersionLabel.Left       := 129;
  VersionLabel.Caption    := ExpandConstant('{#AppVersion}');
  VersionLabel.Font.Name  := 'Tahoma';
  VersionLabel.Font.Size  := 7;
  VersionLabel.Font.Style := [fsBold];
  VersionLabel.Font.Color := $343434;
  VersionLabel.Parent     := WizardForm.WelcomePage;
  // Label for the Finished Page
  // ( @todo because i don't know how to attach one object to both wizard pages )
  VersionLabel2            := TLabel.Create(WizardForm);
  VersionLabel2.Top        := 43;
  VersionLabel2.Left       := 129;
  VersionLabel2.Caption    := ExpandConstant('{#AppVersion}');
  VersionLabel2.Font.Name  := 'Tahoma';
  VersionLabel2.Font.Size  := 7;
  VersionLabel2.Font.Style := [fsBold];
  VersionLabel2.Font.Color := $343434;
  VersionLabel2.Parent     := WizardForm.FinishedPage;

  // Display website link in the bottom left corner of the install wizard
  CancelBtn           := WizardForm.CancelButton;
  UrlLabel            := TNewStaticText.Create(WizardForm);
  UrlLabel.Top        := CancelBtn.Top + (CancelBtn.Height div 2) - (UrlLabel.Height div 2);
  UrlLabel.Left       := WizardForm.ClientWidth - CancelBtn.Left - CancelBtn.Width;
  UrlLabel.Caption    := ExpandConstant('{cm:WebsiteLink}');
  UrlLabel.Font.Style := UrlLabel.Font.Style + [fsUnderline];
  UrlLabel.Cursor     := crHand;
  UrlLabel.Font.Color := clHighlight;
  UrlLabel.OnClick    := @UrlLabelClick;
  UrlLabel.Parent     := WizardForm;

  // Show that Debug Mode is active
  if DEBUG = true then
  begin
    DebugLabel            := TNewStaticText.Create(WizardForm);
    DebugLabel.Top        := UrlLabel.Top;
    DebugLabel.Left       := UrlLabel.Left + UrlLabel.Width + 12;
    DebugLabel.Caption    := ExpandConstant('DEBUG ON');
    DebugLabel.Font.Style := [fsBold];
    DebugLabel.Parent     := WizardForm;
  end;
end;

function NextButtonClick(CurPage: Integer): Boolean;
(*
	Called when the user clicks the Next button.
    If you return True, the wizard will move to the next page.
	If you return False, it will remain on the current page (specified by CurPageID).
*)
begin
  if CurPage = wpSelectComponents then
  begin

    // Define "targetPath" for the downloads. It depends on the debug mode.

    if DEBUG = false then
    begin
      // In non debug mode the temp path is used for downloading.
      // The downloaded components are deleted after installation.
      targetPath := ExpandConstant('{tmp}\');
    end else
    begin
      // In debug mode the "c:\wpnxm-downloads" path is used.
      // The downloaded components are not deleted after installation.
      // If you reinstall, the components are taken from there (no download).
      targetPath := ExpandConstant('c:\wpnxm-downloads\');

      // create folder, if it doesn't exist
      if not DirExists(ExpandConstant(targetPath)) then ForceDirectories(ExpandConstant(targetPath));
    end;

    {
      Leave this!   - It's for determining the download file sizes manually
      There is a strange bug, when trying to get the filesize from googlecode.
      So webgrind has a size of 0. Thats why "unknown" is shown as total progress.

      ITD_GetFileSize(URL_xhprof, size);
      MsgBox(intToStr(size), mbError, MB_OK);
    }

    // Add Files to Download Handler

    if IsComponentSelected('serverstack') then
    begin
      ITD_AddFile(URL_nginx,   ExpandConstant(targetPath + Filename_nginx));
      ITD_AddFile(URL_php,     ExpandConstant(targetPath + Filename_php));
      ITD_AddFile(URL_mariadb, ExpandConstant(targetPath + Filename_mariadb));
    end;

    if IsComponentSelected('webinterface') and VCRedistributableNeedsInstall then
    begin
      // the webinterface depends on vc2008-redistributable .dll stuff
      ITD_AddFile(URL_vcredist, ExpandConstant(targetPath + Filename_vcredist));
    end;

    if IsComponentSelected('servercontrolpanel') then
    begin
      ITD_AddFile(URL_wpnxmscp, ExpandConstant(targetPath + Filename_wpnxmscp));
    end;

    if IsComponentSelected('xdebug')    then ITD_AddFile(URL_phpext_xdebug, ExpandConstant(targetPath + Filename_phpext_xdebug));
    if IsComponentSelected('apc')       then ITD_AddFile(URL_phpext_apc,    ExpandConstant(targetPath + Filename_phpext_apc));
    if IsComponentSelected('webgrind')  then ITD_AddFileSize(URL_webgrind,  ExpandConstant(targetPath + Filename_webgrind), 648000);

    if IsComponentSelected('xhprof') then
    begin
        ITD_AddFile(URL_xhprof,           ExpandConstant(targetPath + Filename_xhprof));
        ITD_AddFile(URL_phpext_xhprof,    ExpandConstant(targetPath + Filename_phpext_xhprof));
    end;

    if IsComponentSelected('memcached') then
    begin
        ITD_AddFile(URL_memcached,        ExpandConstant(targetPath + Filename_memcached));
        ITD_AddFile(URL_phpext_memcache,  ExpandConstant(targetPath + Filename_phpext_memcache));
    end;

    if IsComponentSelected('phpmemcachedadmin') then ITD_AddFile(URL_phpmemcachedadmin,      ExpandConstant(targetPath + Filename_phpmemcachedadmin));

    if IsComponentSelected('memadmin')   then ITD_AddFile(URL_memadmin,      ExpandConstant(targetPath + Filename_memadmin));
    if IsComponentSelected('phpmyadmin') then ITD_AddFile(URL_phpmyadmin,    ExpandConstant(targetPath + Filename_phpmyadmin));
    if IsComponentSelected('adminer')    then ITD_AddFile(URL_adminer,       ExpandConstant(targetPath + Filename_adminer));
    if IsComponentSelected('junction')   then ITD_AddFile(URL_junction,      ExpandConstant(targetPath + Filename_junction));
    if IsComponentSelected('pear')       then ITD_AddFile(URL_pear,          ExpandConstant(targetPath + Filename_pear));
    if IsComponentSelected('composer')   then ITD_AddFile(URL_composer,      ExpandConstant(targetPath + Filename_composer));
    if IsComponentSelected('sendmail')   then ITD_AddFile(URL_sendmail,      ExpandConstant(targetPath + Filename_sendmail));
    if IsComponentSelected('openssl')    then ITD_AddFile(URL_openssl,       ExpandConstant(targetPath + Filename_openssl));

    if IsComponentSelected('mongodb')    then
    begin
        ITD_AddFile(URL_mongodb,       ExpandConstant(targetPath + Filename_mongodb));
        ITD_AddFile(URL_phpext_mongo,  ExpandConstant(targetPath + Filename_phpext_mongo));
    end;

    if IsComponentSelected('rockmongo')  then ITD_AddFile(URL_rockmongo,     ExpandConstant(targetPath + Filename_rockmongo));

    // if DEBUG On and already downloaded, skip downloading files, by resetting files
    if (DEBUG = true) then MsgBox('Debug On. Skipping all downloads, because file exists: ' + ExpandConstant(targetPath + 'nginx.zip'), mbInformation, MB_OK);

    if (DEBUG = true) and (FileExists(ExpandConstant(targetPath + 'nginx.zip'))) then ITD_ClearFiles();

  end; // of wpSelectComponents

  Result := True;
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

procedure UpdateTotalProgressBar();
{
  This procedure is called, when installing a component is finished.
  It updates the TotalProgessBar and the Label in the InstallationScreen with the new percentage.
}
var
    newTotalPercentage : integer;
    TotalProgressBar   : TNewProgressBar;
    TotalProgressLabel : TLabel;
begin
    // Fetch ProgressBar
    TotalProgressBar := TNewProgressBar(InstallPage.FindComponent('TotalProgressBar'));
    // calculate new total percentage
    newTotalPercentage := TotalProgressBar.Position + percentagePerComponent;
    // set to progress bar
    TotalProgressBar.Position := newTotalPercentage;

    // Fetch Label
    TotalProgressLabel := TLabel(InstallPage.FindComponent('TotalProgressLabel'));
    // set to label
    TotalProgressLabel.Caption := intToStr(newTotalPercentage) + ' %';
end;

{
  This procedure is called, when installing a new component starts.
  It updates the CurrentComponentLabel with the name of the component.
}
procedure UpdateCurrentComponentName(component: String);
var
    CurrentComponentLabel : TLabel;
begin
    // fetch label
    CurrentComponentLabel := TLabel(InstallPage.FindComponent('CurrentComponentLabel'));
    // set to label
    CurrentComponentLabel.Caption := component;
end;

procedure UnzipFiles();
var
  selectedComponents     : String;
  intTotalComponents     : Integer;
  i                      : Integer;
begin
  selectedComponents := WizardSelectedComponents(false);

  // count components (get only the selected ones from the total number of components to unzip)
  for i := 0 to WizardForm.ComponentsList.Items.Count - 1 do
    if WizardForm.ComponentsList.Checked[i]=true then
    intTotalComponents:=intTotalComponents+1;

  if (DEBUG = true) then MsgBox('The following components are selected:' + selectedComponents + '. Counter: ' + IntToStr(intTotalComponents), mbInformation, MB_OK);

  // serverstack base are 3 components in 1 so we have to add 2 to the counter
  intTotalComponents:=intTotalComponents+2;

  {
    Calculate the percentage per component: (100% / components) = ppc

    When processing a component is finished, this value is added to the progress bar.
    When all values are added (UpdateTotalProgressBar()), we will reach 100 % in total on the progress bar. (ppc * components) = 100%
  }
  percentagePerComponent := (100 div intTotalComponents);

  if (DEBUG = true) then MsgBox('Each processed component will add ' + intToStr(percentagePerComponent) + ' % to the progress bar.', mbInformation, MB_OK);

  // fetch the unzip command from the compressed setup
  ExtractTemporaryFile('unzip.exe');

  if not DirExists(ExpandConstant('{app}\bin')) then ForceDirectories(ExpandConstant('{app}\bin'));
  if not DirExists(ExpandConstant('{app}\www')) then ForceDirectories(ExpandConstant('{app}\www'));

  // Update Progress Bars

  // always unzip the serverstack base (3 components)

  UpdateCurrentComponentName('Nginx');
    DoUnzip(targetPath + Filename_nginx, ExpandConstant('{app}\bin')); // no subfolder, because nginx brings own dir
  UpdateTotalProgressBar();

  UpdateCurrentComponentName('PHP');
    DoUnzip(targetPath + Filename_php, ExpandConstant('{app}\bin\php'));
  UpdateTotalProgressBar();

  UpdateCurrentComponentName('MariaDB');
    DoUnzip(targetPath + Filename_mariadb, ExpandConstant('{app}\bin')); // no subfolder, brings own dir
  UpdateTotalProgressBar();

  // unzip selected components

  if Pos('servercontrolpanel', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('WPN-XM Server Control Panel');
      DoUnzip(ExpandConstant(targetPath + Filename_wpnxmscp), ExpandConstant('{app}')); // no subfolder, top level
    UpdateTotalProgressBar();
  end;

  if Pos('openssl', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('OpenSSL');
      ExtractTemporaryFile(Filename_openssl);
        Exec('cmd.exe', '/c ' + targetPath + Filename_openssl + ' /DIR="' + ExpandConstant('{app}\bin\openssl') +'" /silent /verysilent /sp- /suppressmsgboxes',
        '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);
    UpdateTotalProgressBar();
  end;

  if Pos('xdebug', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Xdebug');
      // xdebug is not a zipped, its just a dll file, so copy it to the target path
      FileCopy(ExpandConstant(targetPath + Filename_phpext_xdebug), ExpandConstant('{app}\bin\php\ext\php_xdebug.dll'), false);
    UpdateTotalProgressBar();
  end;

  if Pos('apc', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('PHP Extension - APC');
      DoUnzip(targetPath + Filename_phpext_apc, targetPath + '\apc');
      FileCopy(ExpandConstant(targetPath + 'apc\php_apc.dll'), ExpandConstant('{app}\bin\php\ext\php_apc.dll'), false);
    UpdateTotalProgressBar();
  end;

  if Pos('xhprof', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('XHProf');
      DoUnzip(targetPath + Filename_xhprof, ExpandConstant('{app}\www')); // no subfolder, brings own dir

    UpdateCurrentComponentName('PHP Extension - XHProf');
      DoUnzip(targetPath + Filename_phpext_xhprof, ExpandConstant('{app}\bin\php\ext'));

    UpdateTotalProgressBar;
  end;

  if Pos('memcached', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Memcached');
      DoUnzip(targetPath + Filename_memcached, ExpandConstant('{app}\bin')); // no subfolder, brings own dir

    UpdateCurrentComponentName('PHP Extension - Memcached');
      DoUnzip(targetPath + Filename_phpext_memcache, ExpandConstant('{app}\bin\php\ext'));
    UpdateTotalProgressBar();
  end;

  if Pos('memadmin', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Memadmin');
      DoUnzip(targetPath + Filename_memadmin, ExpandConstant('{app}\www')); // no subfolder, brings own dir
    UpdateTotalProgressBar();
  end;

  if Pos('phpmemcachedadmin', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('phpMemcachedAdmin');
      DoUnzip(targetPath + Filename_phpmemcachedadmin, ExpandConstant('{app}\www\memcachedadmin'));
    UpdateTotalProgressBar();
  end;

  if Pos('phpmyadmin', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('phpMyAdmin');
      DoUnzip(targetPath + Filename_phpmyadmin, ExpandConstant('{app}\www')); // no subfolder, brings own dir
    UpdateTotalProgressBar;
  end;

  // adminer is not a zipped, its just a php file, so copy it to the target path
  if Pos('adminer', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Adminer');
      CreateDir(ExpandConstant('{app}\www\adminer\'));
      FileCopy(ExpandConstant(targetPath + Filename_adminer), ExpandConstant('{app}\www\adminer\' + Filename_adminer), false);
    UpdateTotalProgressBar();
  end;

  if Pos('junction', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Junction');
      DoUnzip(targetPath + Filename_junction, ExpandConstant('{app}\bin\tools'));
    UpdateTotalProgressBar();
  end;

  // pear is not a zipped, its just a php phar package, so copy it to php\pear subfolder
  if Pos('pear', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('PEAR');
      CreateDir(ExpandConstant('{app}\bin\php\PEAR\'));
      FileCopy(ExpandConstant(targetPath + Filename_pear), ExpandConstant('{app}\bin\php\PEAR\' + Filename_pear), false);
    UpdateTotalProgressBar();
  end;

  // composer is not a zipped, its just a php phar package, so copy it to the php path
  if Pos('composer', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('composer');
      FileCopy(ExpandConstant(targetPath + Filename_composer), ExpandConstant('{app}\bin\php\' + Filename_composer), false);
    UpdateTotalProgressBar();
  end;

  if Pos('sendmail', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Sendmail');
      CreateDir(ExpandConstant('{app}\bin\sendmail\'));
      DoUnzip(targetPath + Filename_sendmail, ExpandConstant('{app}\bin\sendmail'));
    UpdateTotalProgressBar();
  end;

  if Pos('webgrind', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Webgrind');
      DoUnzip(targetPath + Filename_webgrind, ExpandConstant('{app}\www')); // no subfolder, brings own dir
    UpdateTotalProgressBar();
  end;

  if Pos('rockmongo', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('RockMongo');
      DoUnzip(targetPath + Filename_rockmongo, ExpandConstant('{app}\www')); // no subfolder, brings own dir
    UpdateTotalProgressBar();
  end;

  if Pos('mongodb', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('MongoDB');
      DoUnzip(targetPath + Filename_mongodb, ExpandConstant('{app}\bin')); // no subfolder, brings own dir

    UpdateCurrentComponentName('PHP Extension - Mongo');
      DoUnzip(targetPath + Filename_phpext_mongo, targetPath + '\phpext_mongo');
      Exec('cmd.exe', '/c "copy ' + targetPath + 'phpext_mongo\php_mongo-*-5.4-vc9-nts.dll ' + ExpandConstant('{app}\bin\php\ext\php_mongo.dll') + '"', '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);
    UpdateTotalProgressBar();
  end;

end;

procedure MoveFiles();
var
  selectedComponents: String;
begin
  selectedComponents := WizardSelectedComponents(false);

  // set application path as global variable
  appPath := ExpandConstant('{app}');

  // nginx - rename directory
  Exec('cmd.exe', '/c "move ' + appPath + '\bin\nginx-* ' + appPath + '\bin\nginx"',
  '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);

  // MariaDB - rename directory
  Exec('cmd.exe', '/c "move ' + appPath + '\bin\mariadb-*  ' + appPath + '\bin\mariadb"',
   '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);

  // MariaDB - install with user ROOT and password TOOP
  Exec('cmd.exe', '/c ' + appPath + '\bin\mariadb\mysql_install_db.exe --default-user=root --password=toop --datadir="' + appPath + '\bin\mariadb\data"',
   '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);

  if (Pos('webinterface', selectedComponents) > 0) and (VCRedistributableNeedsInstall() = TRUE)then
  begin
    //Exec('cmd.exe', '/c {tmp}\vcredist_x86.exe /q:a /c:""VCREDI~3.EXE /q:a /c:""""msiexec /i vcredist.msi /qn"""" """; WorkingDir: {app}\bin; StatusMsg: Installing CRT...
  end;

  if Pos('rockmongo', selectedComponents) > 0 then
  begin
      // rockmongo.zip brings also a "__MACOSX" folder with ".DS_Store" file. let's get rid of that crap
      RockmongoCrapDir := AddBackslash(ExpandConstant('{app}\www\__MACOSX'));
      if DirExists(RockmongoCrapDir) then
      begin
        DelTree(RockmongoCrapDir, True, True, True);
      end;
  end;

  if Pos('xhprof', selectedComponents) > 0 then
  begin
    // xhprof - rename "xhprof-master" directory
    Exec('cmd.exe', '/c "move ' + appPath + '\www\xhprof-* ' + appPath + '\www\xhprof"',
    '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);

    // rename "xhprof_0.10.3_php54_vc9_nts.dll" to "xhprof.dll"
        Exec('cmd.exe', '/c "move ' + appPath + '\bin\php\ext\xhprof_* ' + appPath + '\bin\php\ext\xhprof.dll"',
    '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);
  end;

  if Pos('memcached', selectedComponents) > 0 then
  begin
      // rename the existing directory
      Exec('cmd.exe', '/c "move ' + appPath + '\bin\memcached-x86 ' + appPath + '\bin\memcached"',
      '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);
      // memadmin - rename folder name "memadmin-1.0.11" to "memadmin"
      Exec('cmd.exe', '/c "move ' + appPath + '\www\memadmin-* ' + appPath + '\www\memadmin"',
      '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);
  end;

  if Pos('phpmyadmin', selectedComponents) > 0 then
  begin
     // phpmyadmin - rename "phpMyAdmin-3.4.6-english" directory
    Exec('cmd.exe', '/c "move ' + appPath + '\www\phpMyAdmin-*  ' + appPath + '\www\phpmyadmin"',
    '', SW_SHOW, ewWaitUntilTerminated, ReturnCode);
  end;

end;

procedure DoPreInstall();
{
   DoPreInstall will be called after the user clicks Next on the wpReady page,
   but before Inno installs any of the [Files] and other standard script items.

   Its triggered by CurStep == ssInstall in procedure CurStepChanged().

   Workflow: wpReady to Install -> Click Next (Triggers ssInstall) -> wpInstalling
}
begin
  UnzipFiles();
  MoveFiles();
end;

procedure Configure();
var
  selectedComponents: String;
  appPathWithSlashes : String;
  php_ini_file : String;
  mariadb_ini_file : String;
begin
  selectedComponents := WizardSelectedComponents(false);

  // set application path as global variable
  appPath := ExpandConstant('{app}');

  { Explanation: StringChange(S,FromStr,ToStr): Change all occurances in S of FromStr to ToStr.
    StringChange works on the string!! StringChange does not return S!
  }
  appPathWithSlashes := appPath;
  StringChange (appPathWithSlashes, '\', '/');

  // config files

  php_ini_file := appPath + '\bin\php\php.ini';
  mariadb_ini_file := appPath + '\bin\mariadb\my.ini';

  // modifications to the config files

  // MariaDb

  // http://dev.mysql.com/doc/refman/5.5/en/server-options.html#option_mysqld_log-error
  // waring: mysqld will not start if backslashes (\) are used. fwd slashes (/) needed!
  SetIniString('mysqld', 'log-error',        appPathWithSlashes + '/logs/mariadb_error.log',  mariadb_ini_file );

  // PHP
  SetIniString('PHP', 'error_log',           appPath + '\logs\php_error.log',       php_ini_file );
  SetIniString('PHP', 'include_path',        '.;' + appPath + '\bin\php\pear',      php_ini_file );
  SetIniString('PHP', 'upload_tmp_dir',      appPath + '\temp',                     php_ini_file );
  SetIniString('PHP', 'upload_max_filesize', '8M',                                  php_ini_file );
  SetIniString('PHP', 'session.save_path',   appPath + '\temp',                     php_ini_file );

  // Xdebug
  if Pos('xdebug', selectedComponents) > 0 then
  begin
      // add loading of xdebug.dll to php.ini
      if not IniKeyExists('Zend', 'zend_extension', php_ini_file) then
      begin
          SetIniString('Zend', 'zend_extension', appPath + '\bin\php\ext\php_xdebug.dll', php_ini_file );
      end;

      // activate remote debugging
      SetIniString('Xdebug', 'xdebug.remote_enable',  'on',        php_ini_file );
      SetIniString('Xdebug', 'xdebug.remote_handler', 'dbgp',      php_ini_file );
      SetIniString('Xdebug', 'xdebug.remote_host',    'localhost', php_ini_file );
      SetIniString('Xdebug', 'xdebug.remote_port',    '9000',      php_ini_file );
  end;

  if Pos('memcached', selectedComponents) > 0 then
  begin
      // php.ini entry for loading the the extension
      //SetIniString('PHP', 'extension', 'php_memcache.dll', php_ini_file ); // disabled in v0.3.0: MODULE API=20090625 != PHP API 20100525
  end;

  if Pos('apc', selectedComponents) > 0 then
  begin
      // php.ini entry for loading the the extension
      //SetIniString('PHP', 'extension', 'php_apc.dll', php_ini_file ); // APC buggy: disabled for 0.3.0 release
  end;

  if Pos('mongodb', selectedComponents) > 0 then
  begin
      // php.ini entry for loading the the extension
      SetIniString('PHP', 'extension', 'php_mongo.dll', php_ini_file );
  end;
end;

{
  DoPostInstall will be called after Inno has completed installing all of
  the [Files], [Registry] entries, and so forth, and also after all the
  non-postinstall [Run] entries, but before the wpInfoAfter or wpFinished pages.

  Its triggerd by CurStep == ssPostInstall. see procedure CurStepChanged().

  wpInstalling Install finshed -> ssPostInstall
}
procedure DoPostInstall();
begin
  Configure()
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  logfilepathname : String;
  logfilename : String;
  newfilepathname : String;
begin
  if CurStep = ssInstall then
  begin
    DoPreInstall();
  end;

  if CurStep = ssPostInstall then
  begin
    DoPostInstall();
  end;

 // when the setup wizward is finished
 if CurStep = ssDone then
   begin
     // copy logfile from tmp dir to the application dir
     logfilepathname := ExpandConstant('{log}');
     logfilename := ExtractFileName(logfilepathname);
     newfilepathname := ExpandConstant('{app}\logs\') + logfilename;
     filecopy(logfilepathname, newfilepathname, false);
   end;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID=wpInstalling then CustomWpInstallingPage();
end;

{
  Uninstaller

  a) Display Dialogbox
     Warning the user about the deletion of the WPN-XM folder.
     This is ensures no user projects get lost (/www/projects).

  b) Check for running daemon processes before uninstallation.
     Provide Button to shut them down.
     Shutdown is needed, in order to delete them.
}

// boolean function for calling IsModuleLoaded on psvince.dll
function IsModuleLoaded(modulename: String ):  Boolean;
external 'IsModuleLoaded@{app}\bin\tools\psvince.dll stdcall uninstallonly';

function ProcessesRunningWhenUninstall(): Boolean;
var
  index : Integer;
  processes: Array [1..4] of String;
begin
  // fill processes array with process executables to look for
  processes[1] := 'nginx.exe';
  processes[2] := 'memcached.exe';
  processes[3] := 'php-cgi.exe';
  processes[4] := 'mysqld.exe';

  // method return value defaults to false, meaning that no processes is running
  Result := false;

  // iterate processes
  for index := 1 to 4 do
  begin
    // and check if process is running (using external call to psvince.dll)
    if ( IsModuleLoaded( processes[index] ) = true ) then
    begin
     // MsgBox( processes[index] + ' is running, please close it and run again uninstall.', mbError, MB_OK );
     Result := true;
    end;

  end;
end;

function InitializeUninstall(): Boolean;
var
  ResultCode: Integer;
  ButtonPressed: Integer;
begin
  ButtonPressed := IDRETRY;

  // Check if daemons are running or if the user has pressed the cancel button.
  // We need to perform a check for running daemon processes,
  // because files of running processes can not be deleted while running.
  while ProcessesRunningWhenUninstall and ( ButtonPressed <> IDCANCEL ) do
  begin
    ButtonPressed := MsgBox('Some server processes are still running.'#13#10 +
                            'Click Retry to shut them down and continue uninstallation, or click Cancel to quit the uninstaller.',
                            mbError, MB_RETRYCANCEL );

    if( ButtonPressed = IDRETRY ) then
    begin
      // "Yes/Retry" clicked, now shutdown the processes
      if Exec('cmd.exe', '/c ' + ExpandConstant('{app}\stop-wpnxm.exe'), '', SW_HIDE,
         ewWaitUntilTerminated, ResultCode) then
      begin
        Result := ResultCode > 0;
      end;
    end;

    // "Cancel" clicked, quits the un-installer
    if( ButtonPressed = IDCANCEL ) then
    begin
      Result := false;
      Exit;
    end;
  end;

  // unload the dll, otherwise the psvince.dll is not deleted, because in use
  UnloadDLL(ExpandConstant('{app}\bin\tools\psvince.dll'));

  Result := true;
end;

{
  Watch it! Recursion!
}
procedure DeleteWPNXM(ADirName: string);
var
  FindRec: TFindRec;
begin
  if FindFirst( ADirName + '\*.*', FindRec) then begin
    try
      repeat
        // delete folder
        if FindRec.Attributes and FILE_ATTRIBUTE_DIRECTORY <> 0 then begin
          if (FindRec.Name <> '.') and (FindRec.Name <> '..') then begin
            DeleteWPNXM(ADirName + '\' + FindRec.Name);
            RemoveDir(ADirName + '\' + FindRec.Name);
          end;
        end;
        // delete file
        DeleteFile(ADirName + '\' + FindRec.Name);
      until not FindNext(FindRec);
    finally
      FindClose(FindRec);
    end;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then begin
    if MsgBox('***WARNING***'#13#10#13#10 +
        'The WPN-XM installation folder is [ '+ ExpandConstant('{app}') +' ].'#13#10 +
        'You are about to delete this folder and all its subfolders,'#13#10 +
        'including [ '+ ExpandConstant('{app}') +'\www ], which may contain your projects.'#13#10#13#10 +
        'This is your last chance to do a backup of your files.'#13#10#13#10 +
        'Do you want to proceed?'#13#10, mbConfirmation, MB_YESNO) = IDYES
    then begin
      //MsgBox('User clicked YES!', mbInformation, MB_OK);
      DeleteWPNXM(ExpandConstant('{app}'));
    end else begin
      //MsgBox('User clicked No!', mbInformation, MB_OK);
      Abort;
    end;
  end;
end;