:: gyrOS ::

:: Disable DEP

@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

set "PowerShell=%WinDir%\System32\WindowsPowerShell\v1.0\PowerShell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command"

::Disable DEP
%PowerShell% "Set-ProcessMitigation -System -Disable DEP, EmulateAtlThunks"
bcdedit /set nx AlwaysOff

echo.
echo Data Execution Prevention has been disabled.
echo.

pause >nul