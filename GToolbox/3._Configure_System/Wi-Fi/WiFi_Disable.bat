:: ### gyrOS ###

:: Disable WiFi

@echo off
setlocal EnableDelayedExpansion

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

set "currentuser=%WinDir%\gyrOS\NSudo\NSudoLG.exe -U:C -P:E -Wait"

sc config vwififlt start= demand
sc config WlanSvc start= disabled
sc config "DevicesFlowUserSvc" start= disabled
sc config "DeviceAssociationBrokerSvc" start= disabled
%currentuser% reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t REG_DWORD /d "4" /f

echo.
echo WiFi services have been disabled. Please restart your computer.
echo.

pause >nul