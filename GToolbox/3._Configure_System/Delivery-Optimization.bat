:: gyrOS ::

:: Delivery Optimizations prompt script

@echo off
setlocal EnableDelayedExpansion


set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

echo 1. Enable Delivery Optimization
echo 2. Disable Delivery Optimization (Default)
echo.
set /p menu=:
if %menu% EQU 1 goto enable
if %menu% EQU 2 goto disable

:enable
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadFromBypassCache" /f

net stop dosvc
net start dosvc

cls

echo Finished enabling Delivery Optimization, please reboot your device for changes to apply.
pause
exit /b

:disable
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadFromBypassCache" /t REG_DWORD /d "1" /f

cls

echo Finished disabling Delivery Optimization, please reboot your device for changes to apply.
pause
exit /b