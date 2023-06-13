:: gyrOS

:: Riot Vanguard Fix

:: Credits: DuckOS

@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

set "PowerShell=%WinDir%\System32\WindowsPowerShell\v1.0\PowerShell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command"

:: Enable CFG
for %%i in (valorant valorant-win64-shipping vgtray vgc) do (
    %PowerShell% -NoProfile -Command "Set-ProcessMitigation -Name %%i.exe -Enable CFG"
)
bcdedit /set testsigning Off
bcdedit /set nointegritychecks Off
bcdedit /deletevalue nx
bcdedit /set nx OptIn

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions" /t REG_BINARY /d "222222222222222222222222222222222222222222222222" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "232222222223222222222222222222222222222222222222" /f

reg add "HKLM\SYSTEM\CurrentControlSet\Services\vgc" /v "Start" /t REG_DWORD /d "2" /f
sc config "vgc" start= auto
sc config "vgk" start= system

cls

echo Success, please reboot your device for changes to apply.
echo.
pause
exit /b