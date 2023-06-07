:: gyrOS ::

:: Firewall Services

@echo off
setlocal EnableDelayedExpansion


set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

echo 1. Enable Firewall
echo 2. Disable Firewall (Default)
echo.
set /p menu=:
if %menu% EQU 1 goto enable
if %menu% EQU 2 goto disable

:enable
netsh advfirewall set allprofiles state on

cls

echo Finished enabling the firewall, please reboot your device for changes to apply.
pause
exit /b

:disable
netsh advfirewall set allprofiles state off

cls

echo Finished disabling the firewall, please reboot your device for changes to apply.
pause
exit /b