{
    Detect, if Visual C++ Redistributable needs to be installed

    Based on:
    http://stackoverflow.com/questions/11137424/how-to-make-vcredist-x86-reinstall-only-if-not-yet-installed

    ----

    Usage:

    1. Include this ISS with

       // #include "..\some\where\vcredist.iss"

    2. use helper functions as Checks

       - VCRedist_x86_2008_NeedsInstall
       - VCRedist_x86_2012_NeedsInstall
       - VCRedist_x86_2015_NeedsInstall

       - VCRedist_x64_2008_NeedsInstall
       - VCRedist_x64_2012_NeedsInstall
       - VCRedist_x64_2015_NeedsInstall

      // [Run]
      // ; Automatically started...
      // ; VCRedist Conditional Installation Check
      // Filename: "{tmp}\vcredist_x86_2012.exe"; Parameters: "/quiet /norestart"; Check: VCRedist_x86_2012_NeedsInstall; Flags: nowait
}


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

  { Visual C++ 2013 Redistributable 12.0.21005 }
  VC_2013_REDIST_X86_MIN = '{13A4EE12-23EA-3371-91EE-EFB36DDFFF3E}';
  VC_2013_REDIST_X64_MIN = '{A749D8E6-B613-3BE3-8F5F-045C84EBA29B}';

  VC_2013_REDIST_X86_ADD = '{F8CFEB22-A2E7-3971-9EDA-4B11EDEFC185}';
  VC_2013_REDIST_X64_ADD = '{929FBD26-9020-399B-9A7A-751D61F0B942}';

  { Visual C++ 2015 Redistributable 14.0.23026 }
  VC_2015_REDIST_X86_MIN = '{A2563E55-3BEC-3828-8D67-E5E8B9E8B675}';
  VC_2015_REDIST_X64_MIN = '{0D3E9E15-DE7A-300B-96F1-B4AF12B96488}';

  VC_2015_REDIST_X86_ADD = '{BE960C1C-7BAD-3DE6-8B1A-2616FE532845}';
  VC_2015_REDIST_X64_ADD = '{BC958BD2-5DAC-3862-BB1A-C1BE0790438D}';

  { Visual C++ 2015 Redistributable 14.0.24210 }
  VC_2015_REDIST_X86 = '{8FD71E98-EE44-3844-9DAD-9CB0BBBC603C}';
  VC_2015_REDIST_X64 = '{C0B2C673-ECAA-372D-94E5-E89440D087AD}';

function MsiQueryProductState(szProduct: string): INSTALLSTATE;
  external 'MsiQueryProductState{#AW}@msi.dll stdcall';

function VCVersionInstalled(const ProductID: string): Boolean;
begin
  Result := MsiQueryProductState(ProductID) = INSTALLSTATE_DEFAULT;
end;

{
  The Result must be "True", when you need to install VCRedist - or "False", when you don't need to.
}

function VCRedist_x86_2008_NeedsInstall: Boolean;
begin
  Result := not (VCVersionInstalled(VC_2008_REDIST_X86));
  Log('Visual C++ 2008 Redistributables ');
  If Result = True Then Log('were not found and will be installed.') else Log('are already installed.');
end;

function VCRedist_x64_2008_NeedsInstall: Boolean;
begin
  Result := not (VCVersionInstalled(VC_2008_REDIST_X64));
  Log('Visual C++ 2008 Redistributables ');
  If Result = True Then Log('were not found and will be installed.') else Log('are already installed.');
end;

function VCRedist_x86_2012_NeedsInstall: Boolean;
begin
  Result := not (VCVersionInstalled(VC_2012_REDIST_MIN_UPD4_X86));
  Log('Visual C++ 2012 Redistributables ');
  If Result = True Then Log('were not found and will be installed.') else Log('are already installed.');
end;

function VCRedist_x64_2012_NeedsInstall: Boolean;
begin
  Result := not (VCVersionInstalled(VC_2012_REDIST_MIN_UPD4_X64));
  Log('Visual C++ 2012 Redistributables ');
  If Result = True Then Log('were not found and will be installed.') else Log('are already installed.');
end;

function VCRedist_x86_2015_NeedsInstall: Boolean;
begin
  Result := not (VCVersionInstalled(VC_2015_REDIST_X86));
  Log('Visual C++ 2015 Redistributables ');
  If Result = True Then Log('were not found and will be installed.') else Log('are already installed.');
end;

function VCRedist_x64_2015_NeedsInstall: Boolean;
begin
  Result := not (VCVersionInstalled(VC_2015_REDIST_X64));
  Log('Visual C++ 2015 Redistributables ');
  If Result = True Then Log('were not found and will be installed.') else Log('are already installed.');
end;

//function VCRedist2015NeedsInstall: Boolean;
//begin
//  Result := (not RegKeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Wow6432Node\Microsoft\VisualStudio\14.0\VC\VCRedist\x86')) and
//            (not RegKeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\VisualStudio\14.0\VC\VCRedist\x86'));
//
//  // not used, because RegistryKey for detection is unknown
//  //Result := not (VCVersionInstalled(VC_2015_REDIST_X86));
//
//  Log('Visual C++ 2015 Redistributables ');
//  If Result = True Then Log('were not found and will be installed.') else Log('are already installed.');
//end;

