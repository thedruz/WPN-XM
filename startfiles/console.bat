@echo off

:: +-------------------------------------------------------------------------
:: |
:: | WPN-XM Server Stack - Start Console Emulator (ConEmu)
:: |
:: +-----------------------------------------------------------------------<3

:: determine architecture, in order to exec the right version of ConEmu
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set ARCHITECTURE=
) else (
    set ARCHITECTURE=64
)

SET CONEMU=%~dp0bin\ConEmu\ConEmu%ARCHITECTURE%.exe

SET HIDECONSOLE=%~dp0bin\tools\RunHiddenConsole.exe

:: test, if component "git" was installed
:: when "git" is installed, we can start ConEmu with a split screen.
:: On the top    - windows command prompt
:: On the bottom - git bash

IF EXIST "%~dp0\bin\git\git-bash.bat" (
	:: an old version of msysgit
	%HIDECONSOLE% %CONEMU% -cmdlist ^
	cmd.exe -cur_console:fn:t:"Cmd":C:"%~dp0bin\conemu\terminal.ico" ^|^|^| ^
	%~dp0bin\git\git-bash.bat -cur_console:sV:t:"GitBash":C:"%~dp0bin\git\etc\git.ico"
) ELSE IF EXIST "%~dp0\bin\git\git-cmd.exe" (
    :: Git for Windows v2.5.0+
	%HIDECONSOLE% %CONEMU% -cmdlist ^
	cmd.exe -cur_console:fn:t:"Cmd":C:"%~dp0bin\conemu\terminal.ico" ^|^|^| ^
	%~dp0bin\git\git-cmd.exe -cur_console:sV:t:"GitBash":C:"%~dp0bin\git\usr\share\git\git.ico"
) ELSE (
    :: git not installed
	%HIDECONSOLE% %CONEMU%
)
