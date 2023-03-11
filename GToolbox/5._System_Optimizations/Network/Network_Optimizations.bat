:: gyrOS Network Optimization Script ::

@echo off
setlocal EnableDelayedExpansion

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

set "PowerShell=%WinDir%\System32\WindowsPowerShell\v1.0\PowerShell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command"

:: NIC
for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class" /v "*WakeOnMagicPacket" /s ^| findstr  "HKEY"') do (
for /f %%i in ('reg query "%%a" /v "WolShutdownLinkSpeed" ^| findstr "HKEY"') do (reg add "%%i" /v "WolShutdownLinkSpeed" /t REG_SZ /d "2" /f)
for /f %%i in ('reg query "%%a" /v "*SpeedDuplex" ^| findstr "HKEY"') do (reg add "%%i" /v "*SpeedDuplex" /t REG_SZ /d "6" /f)
for /f %%i in ('reg query "%%a" /v "*TransmitBuffers" ^| findstr "HKEY"') do (reg add "%%i" /v "*TransmitBuffers" /t REG_SZ /d "128" /f)
for /f %%i in ('reg query "%%a" /v "*ReceiveBuffers" ^| findstr "HKEY"') do (reg add "%%i" /v "*ReceiveBuffers" /t REG_SZ /d "512" /f)
for /f %%i in ('reg query "%%a" /v "*PMARPOffload" ^| findstr "HKEY"') do (reg add "%%i" /v "*PMARPOffload" /t REG_SZ /d "1" /f)
for /f %%i in ('reg query "%%a" /v "*PMNSOffload" ^| findstr "HKEY"') do (reg add "%%i" /v "*PMNSOffload" /t REG_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "*InterruptModeration" ^| findstr "HKEY"') do (reg add "%%i" /v "*InterruptModeration" /t REG_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "*ModernStandbyWoLMagicPacket" ^| findstr "HKEY"') do (reg add "%%i" /v "*ModernStandbyWoLMagicPacket" /t REG_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "WakeOnLinkChange" ^| findstr "HKEY"') do (reg add "%%i" /v "WakeOnLinkChange" /t REG_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "*IPChecksumOffloadIPv4" ^| findstr "HKEY"') do (reg add "%%i" /v "*IPChecksumOffloadIPv4" /t REG_SZ /d "3" /f)
for /f %%i in ('reg query "%%a" /v "*RSS" ^| findstr "HKEY"') do (reg add "%%i" /v "*RSS" /t REG_SZ /d "1" /f)
for /f %%i in ('reg query "%%a" /v "*NumRssQueues" ^| findstr "HKEY"') do (reg add "%%i" /v "*NumRssQueues" /t REG_SZ /d "4" /f)
for /f %%i in ('reg query "%%a" /v "S5WakeOnLan" ^| findstr "HKEY"') do (reg add "%%i" /v "S5WakeOnLan" /t REG_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "*AlternateSemaphoreDelay" ^| findstr "HKEY"') do (reg add "%%i" /v "*AlternateSemaphoreDelay" /t REG_SZ /d "0" /f)
)

:NetworkType
cls

set /p M="Which Network type would you like to apply optimizations for?   1. for Ethernet or 2. for Wi-Fi: " 
if %M%==1 goto Ethernet
if %M%==2 goto WiFi
goto NetworkType

:Ethernet
cls

netsh interface tcp set supplemental Internet congestionprovider=ctcp
netsh interface tcp set supplemental InternetCustom congestionprovider=ctcp
netsh int tcp set security mpp=disabled
netsh int tcp set security profiles=disabled
netsh int tcp set security mpp=disabled profiles=disabled

PowerShell Enable-NetAdapterQos -Name "*";^
PowerShell Disable-NetAdapterPowerManagement -Name "*";^
PowerShell Disable-NetAdapterIPsecOffload -Name "*";^
PowerShell Set-NetTCPSetting -SettingName "*" -MemoryPressureProtection Disabled -InitialCongestionWindow 10 -ErrorAction SilentlyContinue

reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DelayedAckFrequency" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DelayedAckTicks" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "CongestionAlgorithm" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "IRPStackSize" /t REG_DWORD /d "32" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableAutoDoh" /t REG_DWORD /d "2" /f
::reg add "HKLM\SYSTEM\CurrDisableNagleentControlSet\Services\AFD\Parameters" /v "DoNotHoldNicBuffers" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DisableRawSecurity" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "NonBlockingSendSpecialBuffering" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "IgnorePushBitOnReceives" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DynamicSendBufferDisable" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableIPSourceRouting" /t REG_DWORD /d "2" /f

goto SkipWiFiOptimizations

:WiFi
cls
echo _______________________________
echo.
echo  OPTIMIZING SYSTEM PERFORMANCE
echo _______________________________
echo.

netsh interface tcp set supplemental Internet congestionprovider=newreno
netsh interface tcp set supplemental InternetCustom congestionprovider=newreno

reg add "HKLM\SOFTWARE\Microsoft\DataCollection\Default\WifiAutoConnectConfig" /v "AutoConnectEnabled" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\Default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v "Value" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WcmSvc\GroupPolicy" /v "fSoftDisconnectConnections" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WcmSvc\GroupPolicy" /v "fMinimizeConnections" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\UI" /v "DisableWcnUi" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\WlanSvc\AnqpCache" /v "OsuRegistrationStatus" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HotspotAuthentication" /v "Enabled" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v "AutoConnectAllowedOEM" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager" /v "WiFiSenseCredShared" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager" /v "WiFiSenseOpen" /t REG_DWORD /d "0" /f

:: Disable Background Wi-Fi Scanning
for /f %%i in ('reg query "%%a" /v "RegROAMSensitiveLevel" ^| findstr "HKEY"') do (reg add "%%i" /v "RegROAMSensitiveLevel" /t REG_SZ /d "127" /f)
for /f %%i in ('reg query "%%a" /v "RoamAggressiveness" ^| findstr "HKEY"') do (reg add "%%i" /v "RoamAggressiveness" /t REG_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "RoamTrigger" ^| findstr "HKEY"') do (reg add "%%i" /v "RoamTrigger" /t REG_SZ /d "1" /f)
for /f %%i in ('reg query "%%a" /v "RoamDelta" ^| findstr "HKEY"') do (reg add "%%i" /v "RoamDelta" /t REG_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "BgScanGlobalBlocking" ^| findstr "HKEY"') do (reg add "%%i" /v "BgScanGlobalBlocking" /t REG_SZ /d "2" /f)

for /f "tokens=1,2*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}" /s /v "*IfType"^| findstr /i "HKEY 0x47"') do if /i "%%i" neq "*IfType" (set "REGPATH_WIFI=%%i") else (
	reg add "!REGPATH_WIFI!" /v "ScanWhenAssociated" /t REG_DWORD /d "0" /f
	reg add "!REGPATH_WIFI!" /v "ScanDisableOnLowTraffic" /t REG_DWORD /d "1" /f
	reg add "!REGPATH_WIFI!" /v "ScanDisableOnMediumTraffic" /t REG_DWORD /d "1" /f
	reg add "!REGPATH_WIFI!" /v "ScanDisableOnHighOrMulticast" /t REG_DWORD /d "1" /f
	reg add "!REGPATH_WIFI!" /v "ScanDisableOnLowLatencyOrQos" /t REG_DWORD /d "1" /f
)

goto SkipWiFiOptimizations

:SkipWiFiOptimizations
echo.
echo Applied Network Optimizations. Restart your computer.
echo.

pause >nul