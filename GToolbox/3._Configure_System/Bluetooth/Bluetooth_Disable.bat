:: ### gyrOS ###

:: Disable Bluetooth

@echo off
setlocal EnableDelayedExpansion

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

sc config "BthA2dp" start= disabled
sc config "BthEnum" start= disabled
sc config "BthHFEnum" start= disabled
sc config "BthLEEnum" start= disabled
sc config "BthMini" start= disabled
sc config "BthPan" start= disabled
sc config "BTHPORT" start= disabled
sc config "BTHUSB" start= disabled
sc config "HidBth" start= disabled
sc config "Microsoft_Bluetooth_AvrcpTransport" start= disabled
sc config "RFCOMM" start= disabled

sc config "BluetoothUserService" start= disabled
sc config "BTAGService" start= disabled
sc config "BthAvctpSvc" start= disabled
sc config "bthserv" start= disabled
sc config "DevicesFlowUserSvc" start= disabled
sc config "DevicePickerUserSvc" start= disabled

reg add "HKLM\SYSTEM\CurrentControlSet\Services\BluetoothUserService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t REG_DWORD /d "4" /f

echo.
echo Bluetooth services have been disabled.
echo.

pause >nul