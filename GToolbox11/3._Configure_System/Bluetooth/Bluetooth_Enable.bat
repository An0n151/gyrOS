:: gyrOS ::

:: Enable Bluetooth

@echo off
setlocal EnableDelayedExpansion

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

sc config "BthA2dp" start= demand
sc config "BthEnum" start= demand
sc config "BthHFEnum" start= demand
sc config "BthLEEnum" start= demand
sc config "BthMini" start= demand
sc config "BthPan" start= demand
sc config "BTHPORT" start= demand
sc config "BTHUSB" start= demand
sc config "HidBth" start= demand
sc config "Microsoft_Bluetooth_AvrcpTransport" start= demand
sc config "RFCOMM" start= demand

sc config "BluetoothUserService" start=demand
sc config "BTAGService" start= demand
sc config "BthAvctpSvc" start= demand
sc config "bthserv" start= demand
sc config "DevicesFlowUserSvc" start= demand
sc config "DevicePickerUserSvc" start= demand

reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BluetoothUserService" /v "Start" /t REG_DWORD /d "3" /f

echo.
echo Bluetooth services have been enabled.
echo.
echo Install your bluetooth driver and restart your system.
echo.

pause >nul