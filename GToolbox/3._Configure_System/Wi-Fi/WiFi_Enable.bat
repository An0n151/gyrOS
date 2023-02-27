:: ### gyrOS ###

:: Enable WiFi

@echo off
setlocal EnableDelayedExpansion

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

sc config vwififlt start= system
sc start vwififlt
sc config WlanSvc start= auto
sc start WlanSvc
sc config "DevicesFlowUserSvc" start= demand
sc config "DeviceAssociationBrokerSvc" start= demand
%currentuser% reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t REG_DWORD /d "3" /f
sc config "wcnfs" start= demand

echo.
echo WiFi services have been enabled.

pause >nul