[Code]
const
  TH32CS_SNAPPROCESS = $2;
  INVALID_HANDLE_VALUE = -1;
  MAX_PATH = 260;

type
  PROCESSENTRY32 = record
  dwSize: Integer;
  cntUsage: Integer;
  th32ProcessID: Integer;
  th32DefaultHeapID: Cardinal; // bei 32-Bit Anwendungen
  th32ModuleID: Integer;
  cntThreads: Integer;
  th32ParentProcessID: Integer;
  pcPriClassBase: Integer;
  dwFlags: Integer;
  szexeFile: array [0..MAX_PATH-1] of Char;
end;


function CreateToolhelpSnapshot(dwFlags, dwProcessID: Integer): Integer;
external 'CreateToolhelp32Snapshot@kernel32.dll stdcall setuponly';

function ProcessFirst(hSnapshot: Integer; var uProcess: PROCESSENTRY32): Integer;
#ifdef UNICODE
external 'Process32FirstW@kernel32.dll stdcall setuponly';
#else
external 'Process32First@kernel32.dll stdcall setuponly';
#endif

function ProcessNext(hSnapshot: Integer; var uProcess: PROCESSENTRY32): Integer;
#ifdef UNICODE
external 'Process32NextW@kernel32.dll stdcall setuponly';
#else
external 'Process32Next@kernel32.dll stdcall setuponly';
#endif

function CloseHandle(hPass: Integer): Integer;
external 'CloseHandle@kernel32.dll stdcall setuponly';


function CharArrayToString(CharArray: Array of Char; SizeOfArray: Integer): String;
var
 i: Integer;
begin
  SizeOfArray := SizeOfArray / SizeOf(CharArray[0]);
  i := 0;
  if CharArray[i] = #0 then
    Result := ''
  else begin
    repeat
      Result := Result + CharArray[i] ;
      i := i + 1;
    until (CharArray[i] = #0) or (i = SizeOfArray);
  end;
end;

function IsProcessRunning(sFilename: String; FullFileName: Boolean): Boolean;
var
  lSnapshot, nResult: Integer;
  uProcess: PROCESSENTRY32;
begin
  if FullFileName = True then
    sFilename := ExtractFileName(sFileName);
  lSnapshot := CreateToolhelpSnapshot(TH32CS_SNAPPROCESS, 0);
  if lSnapshot <> INVALID_HANDLE_VALUE then
  begin
    uProcess.dwSize := SizeOf(uProcess);
    nResult := ProcessFirst(lSnapshot, uProcess);
    while nResult <> 0 do
    begin
      if CompareText(CharArrayToString(uProcess.szexeFile, SizeOf(uProcess.szexeFile)), sFilename) = 0 then
      begin
        Result := True;
        break;
      end;
      nResult := ProcessNext(lSnapshot, uProcess);
    end;
    CloseHandle(lSnapshot);
  end;
end;
