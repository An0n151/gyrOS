:: gyrOS ::

:: Wi-Fi Optimization Script

@echo off
setlocal EnableDelayedExpansion

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

netsh interface tcp set supplemental Internet congestionprovider=newreno
netsh interface tcp set supplemental InternetCustom congestionprovider=newreno

::reg add "HKLM\SOFTWARE\Microsoft\DataCollection\Default\WifiAutoConnectConfig" /v "AutoConnectEnabled" /t REG_DWORD /d "1" /f
::reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\Default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v "Value" /t REG_DWORD /d "0" /f
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WcmSvc\GroupPolicy" /v "fSoftDisconnectConnections" /t REG_DWORD /d "1" /f
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WcmSvc\GroupPolicy" /v "fMinimizeConnections" /t REG_DWORD /d "1" /f
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\UI" /v "DisableWcnUi" /t REG_DWORD /d "1" /f
::reg add "HKLM\SOFTWARE\Microsoft\WlanSvc\AnqpCache" /v "OsuRegistrationStatus" /t REG_DWORD /d "0" /f
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HotspotAuthentication" /v "Enabled" /t REG_DWORD /d "1" /f
::reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v "AutoConnectAllowedOEM" /t REG_DWORD /d "0" /f
::reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager" /v "WiFiSenseCredShared" /t REG_DWORD /d "0" /f
::reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager" /v "WiFiSenseOpen" /t REG_DWORD /d "0" /f

:: Disable Background Wi-Fi Scanning
::for /f %%i in ('reg query "%%a" /v "RegROAMSensitiveLevel" ^| findstr "HKEY"') do (reg add "%%i" /v "RegROAMSensitiveLevel" /t REG_SZ /d "127" /f)
::for /f %%i in ('reg query "%%a" /v "RoamAggressiveness" ^| findstr "HKEY"') do (reg add "%%i" /v "RoamAggressiveness" /t REG_SZ /d "0" /f)
::for /f %%i in ('reg query "%%a" /v "RoamTrigger" ^| findstr "HKEY"') do (reg add "%%i" /v "RoamTrigger" /t REG_SZ /d "1" /f)
::for /f %%i in ('reg query "%%a" /v "RoamDelta" ^| findstr "HKEY"') do (reg add "%%i" /v "RoamDelta" /t REG_SZ /d "0" /f)
::for /f %%i in ('reg query "%%a" /v "BgScanGlobalBlocking" ^| findstr "HKEY"') do (reg add "%%i" /v "BgScanGlobalBlocking" /t REG_SZ /d "2" /f)

::for /f "tokens=1,2*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}" /s /v "*IfType"^| findstr /i "HKEY 0x47"') do if /i "%%i" neq "*IfType" (set "REGPATH_WIFI=%%i") else (
	::reg add "!REGPATH_WIFI!" /v "ScanWhenAssociated" /t REG_DWORD /d "0" /f
	::reg add "!REGPATH_WIFI!" /v "ScanDisableOnLowTraffic" /t REG_DWORD /d "1" /f
	::reg add "!REGPATH_WIFI!" /v "ScanDisableOnMediumTraffic" /t REG_DWORD /d "1" /f
	::reg add "!REGPATH_WIFI!" /v "ScanDisableOnHighOrMulticast" /t REG_DWORD /d "1" /f
	::reg add "!REGPATH_WIFI!" /v "ScanDisableOnLowLatencyOrQos" /t REG_DWORD /d "1" /f
::)

echo.
echo Wi-Fi optimizations applied.
echo.

pause >nul