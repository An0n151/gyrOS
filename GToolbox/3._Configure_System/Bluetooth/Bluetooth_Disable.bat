:: ### gyrOS ###

:: Disable Bluetooth

@echo off
setlocal EnableDelayedExpansion

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

devcon disable BTH*

reg add "HKLM\SYSTEM\CurrentControlSet\Services\BluetoothUserService" /v "Start" /t REG_DWORD /d "4" /f
sc config "BluetoothUserService" start= disabled
sc config "BTAGService" start= disabled
sc config "BthAvctpSvc" start= disabled
sc config "bthserv" start= disabled
sc config "DevicesFlowUserSvc" start= disabled
sc config "DeviceAssociationBrokerSvc" start= disabled

timeout /t 3 /nobreak
devcon disable =Bluetooth

echo Bluetooth services have been disabled. Please restart your computer.

pause >nul