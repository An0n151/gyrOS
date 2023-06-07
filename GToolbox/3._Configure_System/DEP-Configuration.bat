:: gyrOS ::

:: DEP Services prompt script

@echo off
setlocal EnableDelayedExpansion


set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

echo 1. Enable Data Execution Prevention (Default on the Faceit build)
echo 2. Disable Data Execution Prevention (Default on all other builds)
echo.
set /p menu=:
if %menu% EQU 1 goto enable
if %menu% EQU 2 goto disable

:enable
set "PowerShell=%WinDir%\System32\WindowsPowerShell\v1.0\PowerShell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command"

:: Enable DEP
%PowerShell% "Set-ProcessMitigation -System -Enable DEP, EmulateAtlThunks"
bcdedit /set nx Optin
:: Enable CFG for Valorant
for %%i in (valorant valorant-win64-shipping vgtray vgc) do (
    PowerShell -NoProfile -Command "Set-ProcessMitigation -Name %%i.exe -Enable CFG"
)

cls

echo Finished enabling DEP, please reboot your device for changes to apply.
pause
exit /b

:disable
set "PowerShell=%WinDir%\System32\WindowsPowerShell\v1.0\PowerShell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command"

::Disable DEP
%PowerShell% "Set-ProcessMitigation -System -Disable DEP, EmulateAtlThunks"
bcdedit /set nx AlwaysOff

cls

echo Finished disabling DEP, please reboot your device for changes to apply.
pause
exit /b