;
;          _\|/_
;          (o o)
; +-----oOO-{_}-OOo------------------------------------------------------+
; |                                                                      |
; |  WPN-XM Server Stack - Inno Setup Script File                        |
; |  --------------------------------------------                        |
; |                                                                      |
; |  WPN-XM is a free and open-source web server solution stack          |
; |  for professional PHP development on the Windows platform.           |
; |                                                                      |
; |  Author:   Jens-Andre Koch <jakoch@web.de>                           |
; |  Website:  http://wpn-xm.org/                                        |
; |  License:  MIT                                                       |
; |                                                                      |
; |  For the full copyright and license information, please view         |
; |  the LICENSE file that was distributed with this source code.        |
; |                                                                      |
; |  Note for developers                                                 |
; |  -------------------                                                 |
; |  A good resource for developing and understanding                    |
; |  Inno Setup Script files is the official "Inno Setup Help".          |
; |  Website:  http://jrsoftware.org/ishelp/index.php                    |
; |                                                                      |
; +---------------------------------------------------------------------<3

; Uncomment the line below to be able to compile the script locally from the IDE.
;#define COMPILE_FROM_IDE

; debug mode toggle
#define DEBUG "false"

; defines the root folder
#define SOURCE_ROOT AddBackslash(SourcePath);

; defines for the setup section
#define APP_NAME "WPN-XM Server Stack"
#define COPYRIGHT_YEAR GetDateTimeString('yyyy', '', '');

#ifdef COMPILE_FROM_IDE
#define APP_VERSION "LocalSnapshot"
#else
; the -APPVERSION- token is replaced during the build process
#define APP_VERSION "@APPVERSION@"
#endif

#define APP_PUBLISHER "Jens-Andre Koch"
#define APP_URL "http://wpn-xm.org/"
#define APP_SUPPORT_URL "https://github.com/WPN-XM/WPN-XM/issues/new/"

#define INSTALLER_TYPE "LiteRC"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{8E0B8E63-FF85-4B78-9C7F-109F905E1D3B}}
AppName={#APP_NAME}
AppVerName={#APP_NAME} {#APP_VERSION}
AppVersion={#APP_VERSION}
AppPublisher={#APP_PUBLISHER}
AppCopyright=© {#APP_PUBLISHER}
AppPublisherURL={#APP_URL}
AppSupportURL={#APP_SUPPORT_URL}
AppUpdatesURL={#APP_URL}
; default installation folder is "c:\server". users might change this via dialog.
DefaultDirName={sd}\server
DefaultGroupName={#APP_NAME}
OutputBaseFilename=WPNXM-{#APP_VERSION}-{#INSTALLER_TYPE}-Setup-php70-w64
Compression=lzma2/ultra
LZMAUseSeparateProcess=yes
LZMANumBlockThreads=2
InternalCompressLevel=max
SolidCompression=true
CreateAppDir=true
CloseApplications=no
; disable wizard pages: Languages, Ready, Select Start Menu Folder
ShowLanguageDialog=no
DisableReadyPage=yes
DisableProgramGroupPage=yes
ShowComponentSizes=no
BackColor=clBlack
PrivilegesRequired=none
; create a log file, see [code] procedure CurStepChanged
SetupLogging=yes
#ifndef COMPILE_FROM_IDE
VersionInfoVersion={#APP_VERSION}
#endif
VersionInfoCompany={#APP_PUBLISHER}
VersionInfoDescription={#APP_NAME} {#APP_VERSION}
VersionInfoTextVersion={#APP_VERSION}
VersionInfoCopyright=Copyright (C) 2011 - {#COPYRIGHT_YEAR} {#APP_PUBLISHER}, All Rights Reserved.
SetupIconFile={#SOURCE_ROOT}..\bin\icons\Setup.ico
WizardImageFile={#SOURCE_ROOT}..\bin\icons\innosetup-wizard-images\banner-left-164x314-lite.bmp
WizardSmallImageFile={#SOURCE_ROOT}..\bin\icons\innosetup-wizard-images\icon-topright-55x55-stamp.bmp
; Tell Windows Explorer to reload the environment, because we modify the environment variable PATH
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
Name: custom; Description: Custom installation; Flags: iscustom

[Components]
; The base component "serverstack" consists of PHP + MariaDB + Nginx. These three components are always installed.
Name: serverstack; Description: Base of the WPN-XM Server Stack (Nginx & PHP & MariaDb); ExtraDiskSpaceRequired: 192430000; Types: full custom; Flags: fixed
Name: adminer; Description: Adminer - Database management in single PHP file; ExtraDiskSpaceRequired: 355000; Types: full
Name: composer; Description: Composer - Dependency Manager for PHP; ExtraDiskSpaceRequired: 486000; Types: full
Name: pickle; Description: Pickle - PHP Extension Installer; ExtraDiskSpaceRequired: 486000; Types: full
Name: servercontrolpanel; Description: WPN-XM - Tray App for Serveradministration; ExtraDiskSpaceRequired: 500000; Types: full
Name: webinterface; Description: WPN-XM - Webinterface for Serveradministration; ExtraDiskSpaceRequired: 500000; Types: full
Name: xdebug; Description: Xdebug - Debugger and Profiler Tool for PHP; ExtraDiskSpaceRequired: 300000; Types: full
Name: openssl; Description: OpenSSL - transport protocol security layer (SSL/TLS); ExtraDiskSpaceRequired: 1000000; Types: full

[Files]
; incorporate all files of the download folder for this installation wizard
Source: ..\downloads\literc-{#APP_VERSION}-php7.0-w64\*; Flags: nocompression dontcopy;
; tools:
Source: ..\bin\backup\7za.exe; DestDir: {tmp}; Flags: dontcopy
Source: ..\bin\backup\*; DestDir: {app}\bin\backup\
Source: ..\bin\HideConsole\RunHiddenConsole.exe; DestDir: {app}\bin\tools\
Source: ..\bin\killprocess\Process.exe; DestDir: {app}\bin\tools\
Source: ..\bin\hosts\hosts.exe; DestDir: {app}\bin\tools\
; psvince is installed to the app folder, because it's needed during uninstallation, to check if daemons are still running.
Source: ..\bin\psvince\psvince.dll; DestDir: {app}\bin\tools\
; incorporate the whole "www" folder into the setup, except the webinterface folder
Source: ..\www\*; DestDir: {app}\www; Flags: recursesubdirs; Excludes: \tools\webinterface,.git*;
; webinterface folder is only copied, if component "webinterface" is selected.
Source: ..\www\tools\webinterface\*; DestDir: {app}\www\tools\webinterface; Excludes:.git*,.travis*; Flags: recursesubdirs; Components: webinterface
; if webinterface is not installed by user, then delete the redirecting index.html file. this activates a simple dir listing.
Source: ..\www\index.html; DestDir: {app}\www; Flags: deleteafterinstall; Components: not webinterface
; ship documentation, changelog and license information
Source: ..\docs\*; DestDir: {app}\docs;
; incorporate several startfiles and shortcut commands
Source: ..\startfiles\backup.bat; DestDir: {app}
Source: ..\startfiles\composer.bat; DestDir: {app}\bin\php; Components: composer
Source: ..\startfiles\pickle.bat; DestDir: {app}\bin\php; Components: pickle
Source: ..\startfiles\generate-certificate.bat; DestDir: {app}\bin\openssl; Components: openssl
Source: ..\startfiles\go-pear.bat; DestDir: {app}\bin\php
Source: ..\startfiles\install-phpunit.bat; DestDir: {app}\bin\php\
Source: ..\startfiles\update-phars.bat; DestDir: {app}\bin\php\
Source: ..\startfiles\reset-db-pw.bat; DestDir: {app}
Source: ..\startfiles\restart.bat; DestDir: {app}
Source: ..\startfiles\start-scp-server.bat; DestDir: {app}
Source: ..\startfiles\start.bat; DestDir: {app}
Source: ..\startfiles\status.bat; DestDir: {app}
Source: ..\startfiles\stop.bat; DestDir: {app}
Source: ..\startfiles\webinterface.url; DestDir: {app}; Components: webinterface
; backup config files, when upgrading
Source: {app}\bin\php\php.ini; DestDir: {app}\bin\php; DestName: "php.ini.old"; Flags: external skipifsourcedoesntexist
Source: {app}\bin\nginx\conf\nginx.conf; DestDir: {app}\bin\nginx\conf; DestName: "nginx.conf.old"; Flags: external skipifsourcedoesntexist
Source: {app}\bin\mariadb\my.ini; DestDir: {app}\bin\mariadb; DestName: "my.ini.old"; Flags: external skipifsourcedoesntexist
Source: {app}\bin\backup\backup.txt; DestDir: {app}\bin\backup; DestName: "backup.txt.old"; Flags: external skipifsourcedoesntexist
; config files
Source: ..\configs\wpn-xm.ini; DestDir: {app}; Components: servercontrolpanel
Source: ..\configs\php\php70.ini-dev; DestDir: {app}\bin\php; DestName: "php.ini"
Source: ..\configs\nginx\nginx.conf; DestDir: {app}\bin\nginx\conf
Source: ..\configs\nginx\conf\domains-disabled\*; DestDir: {app}\bin\nginx\conf\domains-disabled
Source: ..\configs\mariadb\my.ini; DestDir: {app}\bin\mariadb
Source: ..\configs\ssl\openssl.cfg; DestDir: {app}\bin\openssl; Components: openssl
Source: ..\configs\ssl\ca-bundle.crt; DestDir: {app}\bin\openssl; Components: openssl
; Visual C++ Redistributable 2015 is needed by PHP VC14 x64 builds
; The file is always included, but installed only if needed, see conditional install check in the run section.
Source: ..\bin\vcredist\vcredist_x64_2015.exe; DestDir: {tmp}; Flags: deleteafterinstall

[Icons]
Name: {group}\Server Control Panel; Filename: {app}\wpn-xm.exe; Tasks: add_startmenu
Name: {group}\Start WPN-XM; Filename: {app}\start.bat; Tasks: add_startmenu
Name: {group}\Stop WPN-XM; Filename: {app}\stop.bat; Tasks: add_startmenu
Name: {group}\Status of WPN-XM; Filename: {app}\status.bat; Tasks: add_startmenu
Name: {group}\Localhost; Filename: {app}\localhost.url; Tasks: add_startmenu
Name: {group}\Administration; Filename: {app}\administration.url; Tasks: add_startmenu
Name: {group}\{cm:ProgramOnTheWeb,{#APP_NAME}}; Filename: {#APP_URL}; Tasks: add_startmenu
Name: {group}\{cm:ReportBug}; Filename: {#APP_SUPPORT_URL}; Tasks: add_startmenu
Name: {group}\{cm:RemoveApp}; Filename: {uninstallexe}; Tasks: add_startmenu
Name: {userdesktop}\WPN-XM ServerControlPanel; Filename: {app}\wpn-xm.exe; Tasks: add_desktopicon
Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\WPN-XM; Filename: {app}\wpn-xm.exe; Tasks: add_quicklaunchicon
Name: {userdesktop}\WPN-XM Start; Filename: {app}\start.bat; Tasks: add_startstop_desktopicons
Name: {userdesktop}\WPN-XM Stop; Filename: {app}\stop.bat; Tasks: add_startstop_desktopicons

[Tasks]
Name: portablemode; Description: "Portable Mode"; Flags: unchecked
Name: add_startmenu; Description: Create Startmenu entries
Name: add_quicklaunchicon; Description: Create a &Quick Launch icon for the Server Control Panel; GroupDescription: Additional Icons:; Components: servercontrolpanel
Name: add_desktopicon; Description: Create a &Desktop icon for the Server Control Panel; GroupDescription: Additional Icons:; Components: servercontrolpanel
Name: add_startstop_desktopicons; Description: Create &Desktop icons for starting and stopping; GroupDescription: Additional Icons:; Flags: unchecked

[Run]
; Automatically started...
; VCRedist Conditional Installation Check
Filename: "{tmp}\vcredist_x64_2015.exe"; Parameters: "/quiet /norestart"; Check: VCRedist2015NeedsInstall; Flags: nowait
; User selected Postinstallation runs...
Filename: {app}\wpn-xm.exe; Description: Start Server Control Panel; Flags: postinstall nowait skipifsilent unchecked; Components: servercontrolpanel

[Registry]
; a registry change needs the following directive: [SETUP] ChangesEnvironment=yes
; The registry is not modified, when in portable mode.
Root: HKCU; Subkey: "Environment"; ValueType:string; ValueName:"PATH"; ValueData:"{olddata};{app}\bin\php"; Flags: preservestringtype; Check: NeedsAddPath(ExpandConstant('{app}\bin\php')); Tasks: not portablemode;
Root: HKCU; Subkey: "Environment"; ValueType:string; ValueName:"PATH"; ValueData:"{olddata};{app}\bin\mariadb\bin"; Flags: preservestringtype; Check: NeedsAddPath(ExpandConstant('{app}\bin\mariadb\bin')); Tasks: not portablemode;

[Messages]
; define wizard title and tray status msg; overwritten, because defined in /bin/innosetup/default.isl
SetupAppTitle =Setup WPN-XM {#APP_VERSION}
SetupWindowTitle =Setup - {#APP_NAME} {#APP_VERSION}

[CustomMessages]
de.WebsiteButton=wpn-xm.org
en.WebsiteButton=wpn-xm.org
de.HelpButton=Hilfe
en.HelpButton=Help
de.ReportBug=Fehler melden
en.ReportBug=Report Bug
de.RemoveApp=WPN-XM Server Stack deinstallieren
en.RemoveApp=Uninstall WPN-XM Server Stack

[Dirs]
Name: {app}\bin\backup
Name: {app}\bin\nginx\conf\domains-enabled
Name: {app}\bin\nginx\conf\domains-disabled
Name: {app}\logs
Name: {app}\temp
Name: {app}\www
Name: {app}\www\tools\webinterface; Components: webinterface;

[Code]
var
  // the controls move on resize
  WebsiteButton : TButton;
  HelpButton    : TButton;
  DebugLabel    : TNewStaticText;

const
  // reassign preprocessor constant debug
  DEBUG = {#DEBUG};

  {
    Define download file names
  }

  Filename_adminer           = 'adminer.php';
  Filename_composer          = 'composer.phar';
  Filename_mariadb           = 'mariadb.zip';
  Filename_nginx             = 'nginx.zip';
  Filename_openssl           = 'openssl.zip';
  Filename_php               = 'php.zip';
  Filename_phpext_xdebug     = 'phpext_xdebug.zip';
  Filename_pickle            = 'pickle.phar';
  Filename_wpnxmscp          = 'wpnxmscp.zip';

var
  unzipTool   : String;   // path + filename of unzip helper for exec
  returnCode  : Integer;  // errorcode
  targetPath  : String;   // if debug true will download to app/downloads, else temp dir
  appDir      : String;   // installation folder of the application
  hideConsole : String;   // shortcut to {tmp}\runHiddenConsole.exe
  InstallPage                   : TWizardPage;
  intTotalComponents            : Integer;
  intInstalledComponentsCounter : Integer;

// Detect, if Visual C++ Redistributable needs to be installed
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
  VC_2008_REDIST_X64 = '{350AA351-21FA-3270-8B7A-835434E766AD}';
  VC_2008_REDIST_IA64 = '{2B547B43-DB50-3139-9EBE-37D419E0F5FA}';
  VC_2008_SP1_REDIST_X86 = '{9A25302D-30C0-39D9-BD6F-21E6EC160475}';
  VC_2008_SP1_REDIST_X64 = '{8220EEFE-38CD-377E-8595-13398D740ACE}';
  VC_2008_SP1_REDIST_IA64 = '{5827ECE1-AEB0-328E-B813-6FC68622C1F9}';
  VC_2008_SP1_ATL_SEC_UPD_REDIST_X86 = '{1F1C2DFC-2D24-3E06-BCB8-725134ADF989}';
  VC_2008_SP1_ATL_SEC_UPD_REDIST_X64 = '{4B6C7001-C7D6-3710-913E-5BC23FCE91E6}';
  VC_2008_SP1_ATL_SEC_UPD_REDIST_IA64 = '{977AD349-C2A8-39DD-9273-285C08987C7B}';
  VC_2008_SP1_MFC_SEC_UPD_REDIST_X86 = '{9BE518E6-ECC6-35A9-88E4-87755C07200F}';
  VC_2008_SP1_MFC_SEC_UPD_REDIST_X64 = '{5FCE6D76-F5DC-37AB-B2B8-22AB8CEDB1D4}';
  VC_2008_SP1_MFC_SEC_UPD_REDIST_IA64 = '{515643D1-4E9E-342F-A75A-D1F16448DC04}';

  VC_2010_REDIST_X86 = '{196BB40D-1578-3D01-B289-BEFC77A11A1E}';
  VC_2010_REDIST_X64 = '{DA5E371C-6333-3D8A-93A4-6FD5B20BCC6E}';
  VC_2010_REDIST_IA64 = '{C1A35166-4301-38E9-BA67-02823AD72A1B}';
  VC_2010_SP1_REDIST_X86 = '{F0C3E5D1-1ADE-321E-8167-68EF0DE699A5}';
  VC_2010_SP1_REDIST_X64 = '{1D8E6291-B0D5-35EC-8441-6616F567A0F7}';
  VC_2010_SP1_REDIST_IA64 = '{88C73C1C-2DE5-3B01-AFB8-B46EF4AB41CD}';

  // Microsoft Visual C++ 2012 x86 Minimum Runtime - 11.0.61030.0 (Update 4)
  VC_2012_REDIST_MIN_UPD4_X86 = '{BD95A8CD-1D9F-35AD-981A-3E7925026EBB}';
  VC_2012_REDIST_MIN_UPD4_X64 = '{CF2BEA3C-26EA-32F8-AA9B-331F7E34BA97}';
  // Microsoft Visual C++ 2012 x86 Additional Runtime - 11.0.61030.0 (Update 4)
  VC_2012_REDIST_ADD_UPD4_X86 = '{B175520C-86A2-35A7-8619-86DC379688B9}';
  VC_2012_REDIST_ADD_UPD4_X64 = '{37B8F9C7-03FB-3253-8781-2517C99D7C00}';

function MsiQueryProductState(szProduct: string): INSTALLSTATE;
  external 'MsiQueryProductState{#AW}@msi.dll stdcall';

function VCVersionInstalled(const ProductID: string): Boolean;
begin
  Result := MsiQueryProductState(ProductID) = INSTALLSTATE_DEFAULT;
end;

{
  The Result must be "True", when you need to install VCRedist - or "False", when you don't need to.
}
function VCRedist2008NeedsInstall: Boolean;
begin
  Result := not (VCVersionInstalled(VC_2008_REDIST_X64));
  Log('Visual C++ 2008 Redistributables ');
  If Result = True Then Log('were not found and will be installed.') else Log('are already installed.');
end;

function VCRedist2012NeedsInstall: Boolean;
begin
  Result := not (VCVersionInstalled(VC_2012_REDIST_MIN_UPD4_X64));
  Log('Visual C++ 2012 Redistributables ');
  If Result = True Then Log('were not found and will be installed.') else Log('are already installed.');
end;

function VCRedist2015NeedsInstall: Boolean;
begin
  Result := (not RegKeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Wow6432Node\Microsoft\VisualStudio\14.0\VC\VCRedist\x64')) and
            (not RegKeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\VisualStudio\14.0\VC\VCRedist\x64'));

  // not used, because RegistryKey for detection is unknown
  //Result := not (VCVersionInstalled(VC_2015_REDIST_X64));

  Log('Visual C++ 2015 Redistributables ');
  If Result = True Then Log('were not found and will be installed.') else Log('are already installed.');
end;

{
  This check avoids duplicate paths on env var path.
  Used in the Registry Section for testing, if path was already set.
}
function NeedsAddPath(PathToAdd: string): boolean;
var
  OrigPath: string;
begin
  if not RegQueryStringValue(HKCU, 'Environment\', 'Path', OrigPath) then
  begin
    Result := True;
    exit;
  end;
  // look for the path with leading and trailing semicolon
  // Pos() returns 0 if not found
  Result := Pos(';' + UpperCase(PathToAdd) + ';', ';' + UpperCase(OrigPath) + ';') = 0;
  if Result = True then
     Result := Pos(';' + UpperCase(PathToAdd) + '\;', ';' + UpperCase(OrigPath) + ';') = 0;
end;

// Runs an external command via RunHiddenConsole
function ExecHidden(Command: String): Integer;
var
  ResultCode: Integer;
begin
  if Exec(hideConsole, ExpandConstant(Command), '', SW_SHOW, ewWaitUntilTerminated, ResultCode) then
  begin
    Result := ResultCode;
  end
  else
  begin
    Result := ResultCode;
  end;
end;

function ReplaceStringInFile(const SearchString: String; const ReplaceString: String; const FileName: String): boolean;
var
  MyFile : TStrings;
  MyText : string;
begin
  MyFile := TStringList.Create;

  try
    result := true;

    try
      MyFile.LoadFromFile(FileName);
      MyText := MyFile.Text;

      if StringChangeEx(MyText, SearchString, ReplaceString, True) > 0 then // save only, if text was changed
      begin;
        MyFile.Text := MyText;
        MyFile.SaveToFile(FileName);
      end;
    except
      result := false;
    end;
  finally
    MyFile.Free;
  end;
end;

procedure OpenBrowser(Url: string);
var
  ErrorCode: Integer;
begin
  ShellExec('open', Url, '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

procedure HelpButtonClick(Sender: TObject);
begin
  // example URL: http://wpn-xm.org/help.php?section=installation-wizard&type=webinstaller&page=1&version=0.6.0&language=de
  OpenBrowser('{#APP_URL}help.php'
    + '?section=installation-wizard'
    + '&type=' + Lowercase(ExpandConstant('{#INSTALLER_TYPE}'))
    + '&page=' + IntToStr(WizardForm.CurPageID)
    + '&version=' + ExpandConstant('{#APP_VERSION}')
    + '&language=' + ExpandConstant('{language}'));
end;

procedure WebsiteButtonClick(Sender: TObject);
begin
  OpenBrowser('{#APP_URL}');
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
  // Custom InstallPage is shown after the wpReady page
  InstallPage := CreateCustomPage(wpReady, 'Installation', 'Description');

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
  // The inital state of Min and Position is "-1". Position is set to "0", after Max has been
  // calculated, based on the number of selected components (see GetTotalNumberOfComponents()).
  TotalProgressBar.Min := -1
  TotalProgressBar.Position := -1
  TotalProgressBar.Parent := InstallPage.Surface;

  TotalProgressLabel := TLabel.Create(InstallPage);
  TotalProgressLabel.Name := 'TotalProgressLabel'; // needed for FindComponent()
  TotalProgressLabel.Top := TotalProgressStaticText.Top;
  TotalProgressLabel.Left := TotalProgressBar.Width;
  TotalProgressLabel.Caption := '--/--';
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

  // Display the Version Number as overlay on the WizardImageFile (banner-left)
  // Label for the WelcomePage
  VersionLabel            := TLabel.Create(WizardForm);
  VersionLabel.Top        := 43;
  VersionLabel.Left       := 129;
  VersionLabel.Caption    := ExpandConstant('{#APP_VERSION}');
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
  VersionLabel2.Caption    := ExpandConstant('{#APP_VERSION}');
  VersionLabel2.Font.Name  := 'Tahoma';
  VersionLabel2.Font.Size  := 7;
  VersionLabel2.Font.Style := [fsBold];
  VersionLabel2.Font.Color := $343434;
  VersionLabel2.Parent     := WizardForm.FinishedPage;

  // Display website link in the bottom left corner of the install wizard
  CancelBtn                := WizardForm.CancelButton;
  WebsiteButton            := TButton.Create(WizardForm);
  WebsiteButton.Top        := CancelBtn.Top;
  WebsiteButton.Left       := WizardForm.ClientWidth - CancelBtn.Left - CancelBtn.Width;
  WebsiteButton.Height     := CancelBtn.Height;
  WebsiteButton.Caption    := ExpandConstant('{cm:WebsiteButton}');
  WebsiteButton.Cursor     := crHand;
  WebsiteButton.Font.Color := clHighlight;
  WebsiteButton.OnClick    := @WebsiteButtonClick;
  WebsiteButton.Parent     := WizardForm;

  HelpButton               := TButton.Create(WizardForm);
  HelpButton.Top           := CancelBtn.Top;
  HelpButton.Left          := WebsiteButton.Left + WebsiteButton.Width;
  HelpButton.Height        := CancelBtn.Height;
  HelpButton.Caption       := ExpandConstant('{cm:HelpButton}');
  HelpButton.Cursor        := crHelp;
  HelpButton.Font.Color    := clHighlight;
  HelpButton.OnClick       := @HelpButtonClick;
  HelpButton.Parent        := WizardForm;

  // Show that Debug Mode is active
  if DEBUG = true then
  begin
    DebugLabel            := TNewStaticText.Create(WizardForm);
    DebugLabel.Top        := WebsiteButton.Top + 4;
    DebugLabel.Left       := WebsiteButton.Left + WebsiteButton.Width + 85;
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
    // The "targetPath" for downloads or extractions is the temporary path.
    // When the installation is finished (or at least when temp folder gets cleared) the stuff gets deleted.
    targetPath := ExpandConstant('{tmp}\');
  end; // of wpSelectComponents
  Result := True;
end;

procedure DoUnzip(source: String; targetdir: String);
begin
    // source contains tmp constant, so resolve it to path name
    source := ExpandConstant(source);

    unzipTool := ExpandConstant('{tmp}\7za.exe');

    if not FileExists(unzipTool)
    then MsgBox('UnzipTool not found: ' + unzipTool, mbError, MB_OK)
    else if not FileExists(source)
    then MsgBox('File was not found while trying to unzip: ' + source, mbError, MB_OK)
    else begin
         if Exec(unzipTool, ' x "' + source + '" -o"' + targetdir + '" -y',
                 '', SW_HIDE, ewWaitUntilTerminated, ReturnCode) = false
         then begin
             MsgBox('Unzip failed:' + source, mbError, MB_OK)
         end;
    end;
end;

Procedure GetNumberOfSelectedComponents(selectedComponents : String);
var
  i : Integer;
begin
  // determine the total number of components by counting the selected components.
  for i := 0 to WizardForm.ComponentsList.Items.Count - 1 do
    if WizardForm.ComponentsList.Checked[i] = true then
       intTotalComponents := intTotalComponents + 1;

  if (DEBUG = true) then Log('# The following [' + IntToStr(intTotalComponents) + '] components are selected: ' + selectedComponents);

  // the "serverstack" contains 3 components and is always installed. we have to add 2 to the counter.
  intTotalComponents := intTotalComponents + 2;

  // the following components contain 2 components. if selected, we have to add 1 to the counter.
  if Pos('assettools', selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1;
  if Pos('git',        selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1;
  if Pos('node',       selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1;
  if Pos('memcached',  selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1;
  if Pos('varnish',    selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1;
  if Pos('imagick',    selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1;
  if Pos('mongodb',    selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1;
  if Pos('uprofiler',  selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1;

  // the component "PHP Extensions" contains 11 extensions. if selected, we have to add 10 to the counter.
  if Pos('phpextensions', selectedComponents) > 0 then intTotalComponents := intTotalComponents + 10;

  if (DEBUG = true) then Log('# Recalculated total number of components: [' + IntToStr(intTotalComponents) + ']');
end;

procedure UpdateTotalProgressBar();
{
  This procedure is called, when installing a component is finished.
  It updates the TotalProgessBar and the Label in the InstallationScreen with the new percentage.
}
var
    TotalProgressBar   : TNewProgressBar;
    TotalProgressLabel : TLabel;
begin
    TotalProgressBar := TNewProgressBar(InstallPage.FindComponent('TotalProgressBar'));

    {
      Initalize the ProgessBar
    }

    if(TotalProgressBar.Position = -1) then
    begin
        TotalProgressBar.Min := 0;
        TotalProgressBar.Position := 0;
        TotalProgressBar.Max := (intTotalComponents * 100);
        if (DEBUG = true) then Log('# ProgressBar.Max set to: [' + IntToStr(TotalProgressBar.Max) + '].');
    end;

    {
      Increase counter and update the ProgressBar accordingly
    }

    // increase counter
    intInstalledComponentsCounter := intInstalledComponentsCounter + 1;

    // Update Label
    TotalProgressLabel := TLabel(InstallPage.FindComponent('TotalProgressLabel'));
    TotalProgressLabel.Caption := IntToStr(intInstalledComponentsCounter) + '/' +IntToStr(intTotalComponents);

    // Update ProgressBar
    TotalProgressBar.Position := (intInstalledComponentsCounter * 100);

    if (DEBUG = true) then
    begin
      Log('# Processed Components '+IntToStr(intInstalledComponentsCounter) +'/'+IntToStr(intTotalComponents)+'.');
    end;
end;

{
  This procedure is called, when installing a new component starts.
  It updates the CurrentComponentLabel with the name of the component.
}
procedure UpdateCurrentComponentName(component: String);
var
    CurrentComponentLabel : TLabel;
begin
    CurrentComponentLabel := TLabel(InstallPage.FindComponent('CurrentComponentLabel'));
    CurrentComponentLabel.Caption := component;
    if (DEBUG = true) then Log('# Extracting Component: ' + component);
end;

procedure UnzipFiles();
var
  selectedComponents     : String;
begin
  selectedComponents := WizardSelectedComponents(false);

  GetNumberOfSelectedComponents(selectedComponents);

  // fetch the unzip command from the compressed setup
  ExtractTemporaryFile('7za.exe');
  ExtractTemporaryFile('RunHiddenConsole.exe');

  // define hideConsole shortcut
  hideConsole := ExpandConstant('{tmp}\RunHiddenConsole.exe');

  if not DirExists(ExpandConstant('{app}\bin')) then ForceDirectories(ExpandConstant('{app}\bin'));
  if not DirExists(ExpandConstant('{app}\www')) then ForceDirectories(ExpandConstant('{app}\www'));
  if not DirExists(ExpandConstant('{app}\www\tools')) then ForceDirectories(ExpandConstant('{app}\www\tools'));

  // Update Progress Bars

  // always unzip the serverstack base (3 components)

  UpdateCurrentComponentName('Nginx');
    ExtractTemporaryFile(Filename_nginx);
    DoUnzip(targetPath + Filename_nginx, ExpandConstant('{app}\bin')); // no subfolder, because nginx brings own dir
  UpdateTotalProgressBar();

  UpdateCurrentComponentName('PHP');
    ExtractTemporaryFile(Filename_php);
    DoUnzip(targetPath + Filename_php, ExpandConstant('{app}\bin\php'));
  UpdateTotalProgressBar();

  UpdateCurrentComponentName('MariaDB');
    ExtractTemporaryFile(Filename_mariadb);
    DoUnzip(targetPath + Filename_mariadb, ExpandConstant('{app}\bin')); // no subfolder, brings own dir
  UpdateTotalProgressBar();

  // unzip selected components

  if Pos('servercontrolpanel', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('WPN-XM Server Control Panel');
      ExtractTemporaryFile(Filename_wpnxmscp);
      DoUnzip(ExpandConstant(targetPath + Filename_wpnxmscp), ExpandConstant('{app}')); // no subfolder, top level
    UpdateTotalProgressBar();
  end;

  if Pos('openssl', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('OpenSSL');
      ExtractTemporaryFile(Filename_openssl);
      DoUnzip(ExpandConstant(targetPath + Filename_openssl), ExpandConstant('{app}\bin\openssl'));
    UpdateTotalProgressBar();
  end;

  if Pos('xdebug', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Xdebug');
      ExtractTemporaryFile(Filename_phpext_xdebug);
      DoUnzip(targetPath + Filename_phpext_xdebug, targetPath + 'phpext_xdebug');
      FileCopy(ExpandConstant(targetPath + 'phpext_xdebug\php_xdebug.dll'), ExpandConstant('{app}\bin\php\ext\php_xdebug.dll'), false);
    UpdateTotalProgressBar();
  end;

  // pickle is not zipped, its just a php phar package, so copy it to the php path
  if Pos('pickle', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('pickle');
      ExtractTemporaryFile(Filename_pickle);
      FileCopy(ExpandConstant(targetPath + Filename_pickle), ExpandConstant('{app}\bin\php\' + Filename_pickle), false);
    UpdateTotalProgressBar();
  end;

  // adminer is not zipped, its just a php file, so copy it to the target path
  if Pos('adminer', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Adminer');
      ExtractTemporaryFile(Filename_adminer);
      CreateDir(ExpandConstant('{app}\www\tools\adminer\'));
      FileCopy(ExpandConstant(targetPath + Filename_adminer), ExpandConstant('{app}\www\tools\adminer\' + Filename_adminer), false);
    UpdateTotalProgressBar();
  end;

  // composer is not zipped, its just a php phar package, so copy it to the php path
  if Pos('composer', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Composer');
      ExtractTemporaryFile(Filename_composer);
      FileCopy(ExpandConstant(targetPath + Filename_composer), ExpandConstant('{app}\bin\php\' + Filename_composer), false);
    UpdateTotalProgressBar();
  end;

end;

procedure MoveFiles();
var
  selectedComponents: String;
begin
  selectedComponents := WizardSelectedComponents(false);

  // set application path as global variable
  appDir := ExpandConstant('{app}');

  // nginx - rename directory
  ExecHidden('cmd.exe /c "move /Y ' + appDir + '\bin\nginx-* ' + appDir + '\bin\nginx"');

  // MariaDB - rename directory
  ExecHidden('cmd.exe /c "move /Y ' + appDir + '\bin\mariadb-* ' + appDir + '\bin\mariadb"');

end;

{
   DoPreInstall will be called after the user clicks Next on the wpReady page,
   but before Inno installs any of the [Files] and other standard script items.
   Its triggered by CurStep == ssInstall in procedure CurStepChanged().
   Workflow: wpReady to Install -> Click Next (Triggers ssInstall) -> wpInstalling
}
procedure DoPreInstall();
begin
  UnzipFiles();
  MoveFiles();
end;

procedure Configure();
var
  selectedComponents: String;
  appDirWithSlashes : String;
  php_ini_file : String;
  mariadb_ini_file : String;
begin
  selectedComponents := WizardSelectedComponents(false);

  // set application path as global variable
  appDir := ExpandConstant('{app}');

  // StringChange(S,FromStr,ToStr) works on the string S, changing all occurances in S of FromStr to ToStr.
  appDirWithSlashes := appDir;
  StringChange (appDirWithSlashes, '\', '/');

  {
    =============== Inital Setup for Components (post-install commands) ===============
  }

  // MariaDb - install with user ROOT and without password (this is the position to add a default password)
  ExecHidden(appDir + '\bin\mariadb\bin\mysql_install_db.exe --datadir="' + appDir + '\bin\mariadb\data" --default-user=root --password=');

  // MariaDB - initialize mysql tables, e.g. performance_tables
  ExecHidden(appDir + '\bin\mariadb\bin\mysql_upgrade.exe');

  {
    =============== Modify Configuration Files ===============
  }

  // config files
  php_ini_file := appDir + '\bin\php\php.ini';
  mariadb_ini_file := appDir + '\bin\mariadb\my.ini';

  // http://dev.mysql.com/doc/refman/5.5/en/server-options.html#option_mysqld_log-error
  // waring: mysqld will not start if backslashes (\) are used. fwd slashes (/) needed!
  SetIniString('mysqld', 'log-error',        appDirWithSlashes + '/logs/mariadb_error.log',  mariadb_ini_file);

  // PHP
  SetIniString('PHP', 'error_log',           appDir + '\logs\php_error.log',       php_ini_file);
  SetIniString('PHP', 'include_path',        '.;' + appDir + '\bin\php\pear',      php_ini_file);
  SetIniString('PHP', 'upload_tmp_dir',      appDir + '\temp',                     php_ini_file);
  SetIniString('PHP', 'upload_max_filesize', '8M',                                  php_ini_file);
  SetIniString('PHP', 'session.save_path',   appDir + '\temp',                     php_ini_file);

  // Xdebug
  if Pos('xdebug', selectedComponents) > 0 then
  begin
      if not IniKeyExists('Zend', 'zend_extension', php_ini_file) then
      begin
          SetIniString('Zend', 'zend_extension', appDir + '\bin\php\ext\php_xdebug.dll', php_ini_file);
      end;

      // activate remote debugging
      SetIniString('Xdebug', 'xdebug.remote_enable',  'on',        php_ini_file);
      SetIniString('Xdebug', 'xdebug.remote_handler', 'dbgp',      php_ini_file);
      SetIniString('Xdebug', 'xdebug.remote_host',    'localhost', php_ini_file);
      SetIniString('Xdebug', 'xdebug.remote_port',    '9000',      php_ini_file);
  end;

  if Pos('openssl', selectedComponents) > 0 then
  begin
    ReplaceStringInFile(';curl.cainfo =', 'curl.cainfo =' + appDir + '\bin\openssl\ca-bundle.crt', php_ini_file);
    ReplaceStringInFile(';openssl.cafile =', 'openssl.cafile =' + appDir + '\bin\openssl\ca-bundle.crt', php_ini_file);
  end;

end;

{
  DoPostInstall will be called after Inno has completed installing all of
  the [Files], [Registry] entries, and so forth, and also after all the
  non-postinstall [Run] entries, but before the wpInfoAfter or wpFinished pages.
  Its triggerd by CurStep == ssPostInstall. See procedure CurStepChanged().
  wpInstalling Install finshed -> ssPostInstall
}
procedure DoPostInstall();
begin
  Configure()
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssInstall then DoPreInstall();
  if CurStep = ssPostInstall then DoPostInstall();

  // when the wizard finishes, copy the installation logfile from tmp dir to application dir.
  // this allows easier debugging of installation problems. the user can upload or reference parts of the log.
  if CurStep = ssDone then
      filecopy(ExpandConstant('{log}'), ExpandConstant('{app}\logs\') + ExtractFileName(ExpandConstant('{log}')), false);
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  // show custom wpInstalling page with two progress bars.
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
function IsModuleLoaded(modulename: AnsiString) : Boolean;
external 'IsModuleLoaded@{app}\bin\tools\psvince.dll stdcall uninstallonly';

function ProcessesRunningWhenUninstall(): Boolean;
var
  index : Integer;
  processes: Array [1..6] of String;
begin
  // fill processes array with process executables to look for
  processes[1] := 'nginx.exe';
  processes[2] := 'memcached.exe';
  processes[3] := 'php-cgi.exe';
  processes[4] := 'mysqld.exe';
  processes[5] := 'mongod.exe';
  processes[6] := 'postgres.exe';

  // method return value defaults to false, meaning that no processes is running
  Result := false;

  // iterate processes
  for index := 1 to 6 do
  begin
    // and check if process is running (using external call to psvince.dll)
    if ( IsModuleLoaded( processes[index] ) = true ) then
    begin
     MsgBox( processes[index] + ' is running, please close it and run again uninstall.', mbError, MB_OK );
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
      if Exec('cmd.exe', '/c ' + ExpandConstant('{app}\stop.bat'), '', SW_HIDE,
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

function RemovePathFromEnvironmentPath(PathToRemove: string): boolean;
var
  Path: String;
begin
  // fetch env var PATH
  RegQueryStringValue(HKCU, 'Environment\', 'PATH', Path);

  // check, if the PathToRemove is inside PATH
  if Pos(LowerCase(PathToRemove) + ';', Lowercase(Path)) <> 0 then
  begin
     // replace the PathToRemove string segment with empty and write the new path
     StringChange(Path, PathToRemove + ';', '');
     RegWriteStringValue(HKCU, 'Environment\', 'PATH', Path);
     Result := true;
  end
  else
  begin
     Result := false;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin

  // open uninstall survey in browser on (non-silent) uninstallation
  if (IsUninstaller and not UninstallSilent) then begin
    if (CurUninstallStep = usDone) then begin
          OpenBrowser('http://wpn-xm.org/uninstall-survey.php?version=' + ExpandConstant('{#APP_VERSION}'));
    end;
  end;

  // warn the user, that his working folder is going to be deleted and projects might get lost
  if (CurUninstallStep = usUninstall) then begin
    if MsgBox('***WARNING***'#13#10#13#10 +
        'The WPN-XM installation folder is [ '+ ExpandConstant('{app}') +' ].'#13#10 +
        'You are about to delete this folder and all its subfolders,'#13#10 +
        'including [ '+ ExpandConstant('{app}') +'\www ], which may contain your projects.'#13#10#13#10 +
        'This is your last chance to do a backup of your files.'#13#10#13#10 +
        'Do you want to proceed?'#13#10, mbConfirmation, MB_YESNO) = IDYES
    then begin
      // User clicked: YES

      // fix "read-only" status of all files and folders, else some things might remain after uninstallation
      ExecHidden('cmd.exe /c "attrib -R ' + appDir + '\*.* /s /d"');

      // Deletes the application directory and everything inside it.
      // This function will remove directories that are reparse points,
      // but it will not recursively delete files/directories inside them.
      DelTree(ExpandConstant('{app}'), True, True, True);

    end else begin
      // User clicked: No
      Abort;
    end;
  end;

  // finally, remove the PHP bin folder
  if (CurUninstallStep = usPostUninstall) then begin
     RemovePathFromEnvironmentPath(ExpandConstant('{app}\php\bin'));
  end;
end;