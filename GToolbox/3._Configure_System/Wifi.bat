:: gyrOS ::

:: Wifi Services prompt script

@echo off
setlocal EnableDelayedExpansion


set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

echo 1. Enable Wifi Services
echo 2. Disable Wifi Services (Default)
echo.
set /p menu=:
if %menu% EQU 1 goto enable
if %menu% EQU 2 goto disable

:enable
sc config "vwififlt" start= system
sc config "WlanSvc" start= auto
sc config "DevicesFlowUserSvc" start= demand
sc config "DevicePickerUserSvc" start= demand
sc config "wcnfs" start= demand
sc config "WFDSConMgrSvc" start= auto

reg add "HKLM\SYSTEM\CurrentControlSet\Services\WFDSConMgrSvc" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t REG_DWORD /d "3" /f

sc start vwififlt
sc start WlanSvc
sc start DevicesFlowUserSvc
sc start DevicePickerUserSvc
sc start wcnfs
sc start WFDSConMgrSvc

cls

echo Finished enabling Wifi services, please reboot your device for changes to apply.
pause
exit /b

:disable
sc config "vwififlt" start= demand
sc config "WlanSvc" start= disabled
sc config "DevicesFlowUserSvc" start= disabled
sc config "DevicePickerUserSvc" start= disabled
sc config "wcnfs" start= disabled
sc config "WFDSConMgrSvc" start= disabled

reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t REG_DWORD /d "4" /f

cls

echo Finished disabling Wifi services, please reboot your device for changes to apply.
pause
exit /b