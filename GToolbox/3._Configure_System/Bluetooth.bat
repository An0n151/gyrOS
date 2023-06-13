:: gyrOS ::

:: Bluetooth

@echo off
setlocal EnableDelayedExpansion


set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

echo 1. Enable Bluetooth Services
echo 2. Disable Bluetooth Services (Default)
echo.
set /p menu=: 
if %menu% EQU 1 goto enable
if %menu% EQU 2 goto disable

:enable
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
sc config "BluetoothUserService" start= auto
sc config "BTAGService" start= demand
sc config "BthAvctpSvc" start= auto
sc config "bthserv" start= demand
sc config "DevicesFlowUserSvc" start= demand
sc config "DevicePickerUserSvc" start= demand

%WinDir%\gyrOS\DevManView.exe /enable "*Bluetooth*" /use_wildcard

reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BluetoothUserService" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthAvctpSvc" /v "Start" /t REG_DWORD /d "2" /f

cls

echo Finished enabling Bluetooth, please reboot your device and install drivers for changes to apply.
echo.
pause
exit /b

:disable
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

%WinDir%\gyrOS\DevManView.exe /disable "*Bluetooth*" /use_wildcard

reg add "HKLM\SYSTEM\CurrentControlSet\Services\BluetoothUserService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthAvctpSvc" /v "Start" /t REG_DWORD /d "4" /f

cls

echo Finished disabling Bluetooth, please reboot your device for changes to apply.
echo.
pause
exit /b