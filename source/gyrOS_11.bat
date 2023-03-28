:: ### gyrOS Optimization Script ###

:: ### Credits: EchoX, HoneCtrl, ArtanisInc, Rikey, DuckOS, Melody

setlocal EnableDelayedExpansion
title gyrOS Post Installation Script %VERSION%

set "VERSION=23.4.1"
set "SCRIPT_VERSION_DATE=23/03/2023"

:: Configure Variables
set "currentuser=%WinDir%\gyrOS\NSudo\NSudoLG.exe -U:C -P:E -Wait"
set "PowerShell=%WinDir%\System32\WindowsPowerShell\v1.0\PowerShell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command"

::sc config = boot, or = system, or = auto, or = demand, or = disabled, or = delayed-auto

echo _____________________________________________________________________________________________________
echo.
echo  THANK YOU FOR INSTALLING GYROS 11 %VERSION%. PRESS ANY KEY TO START APPLYING GYROS OPTIMIZATIONS.
echo.
echo  DO NOT CLOSE THIS WINDOW UNTIL YOU ARE PROMPTED TO RESTART.
echo _____________________________________________________________________________________________________
echo.
pause
cls

echo _______________
echo.
echo  GETTING READY
echo _______________
echo.

:: Turn on Automatic Time Update ; Credits to DuckOS
%WinDir%\System32\SystemSettingsAdminFlows.exe SetInternetTime 1

:: Turn on Automatic Time Zone Update ; Credits to DuckOS
start "" "%WinDir%\System32\SystemSettingsAdminFlows.exe" SetAutoTimeZoneUpdate 1

:: Force Sync the Time with the Internet Time ; Credits to DuckOS
start "" "%WinDir%\System32\SystemSettingsAdminFlows.exe" ForceTimeSync 1

timeout /t 1 >nul

:: ============================== ::
::       INSTALL SOFTWARE         ::
:: ============================== ::

echo _____________________
echo.
echo  INSTALLING SOFTWARE
echo _____________________
echo.
echo.
echo.
echo.

:VisualCPP
echo ____________________________________________
echo.
echo  INSTALLING VISUAL CPP REDISTRIBUTABLES 1/2
echo ____________________________________________
echo.
"%WinDir%\gyrOS\VisualCppRedist_AIO.exe" /ai


echo ________________________
echo.
echo  INSTALLING DIRECTX 2/2
echo ________________________
echo.
ping 8.8.8.8 -n 1 -w 1000
if %errorlevel% == 0 (
:DirectX
start /wait "" "%WinDir%\gyrOS\DirectX.exe" /q

) else (
echo No internet connection detected. Skipping DirectX installation.
echo.
echo Install DirectX manually using GToolbox.
timeout /t 3 >nul
)

echo ______________________________
echo.
echo  FINISHED INSTALLING SOFTWARE
echo ______________________________
echo.

timeout /t 1 >nul


:: Delete Post Setup Files
del /f /q %WinDir%\HoneV2.pow
del /f /q %WinDir%\gyrOS\VisualCppRedist_AIO.exe
del /f /q %WinDir%\gyrOS\DirectX.exe

:: ============================== ::
::       WINDOWS SETTINGS         ::
:: ============================== ::

echo ______________________
echo.
echo  ANALYZING BIOMETRICS
echo ______________________
echo.

:: Services Configuration
reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wcncsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SNMPTRAP" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PcaSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CDPSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\VaultSvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CryptSvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DusmSvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthAvctpSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DoSvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DevQueryBroker" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SstpSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\swprv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\svsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\VSS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wmiApSrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\RpcSs" /v "Start" /t REG_DWORD /d "4" /f
sc config "RpcSs" start= disabled
%currentuser% reg add "HKLM\SYSTEM\CurrentControlSet\Services\RpcSs" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\FrameServer" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\defragsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NcbService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lltdsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\MSDTC" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DmEnrollmentSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\McpManagementService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DPS" /v "Start" /t REG_DWORD /d "4" /f
sc config "DPS" start= disabled
%currentuser% reg add "HKLM\SYSTEM\CurrentControlSet\Services\DPS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\diagsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdiServiceHost" /v "Start" /t REG_DWORD /d "4" /f
sc config "WdiServiceHost" start= disabled
%currentuser% reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdiServiceHost" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdiSystemHost" /v "Start" /t REG_DWORD /d "4" /f
sc config "WdiSystemHost" start= disabled
%currentuser% reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdiSystemHost" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\diagnosticshub.standardcollector.service" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wcnfs" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lmhosts" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SSDPSRV" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\StorSvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dhcp" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\IKEEXT" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WerSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wercplsupport" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\cbdhsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\OneSyncSvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AJRouter" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\uhssvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TrkWks" /v "Start" /t REG_DWORD /d "4" /f

:: Remove Folders and Files
del "%SystemDrive%\AMFTrace.log" /s /f /q
rd "%ProgramData%\Microsoft\DiagnosticLogCSP" /s /q
rd "%drive%\Users\%username%\3D Objects" /s /q
rd "%drive%\Users\%username%\Favorites" /s /q
rd "%drive%\Users\%username%\Links" /s /q
rd "%drive%\Users\%username%\OneDrive" /s /q
rd "%drive%\Users\%username%\Searches" /s /q
rd "%drive%\Users\%username%\Contacts" /s /q
rd "%drive%\Users\%username%\Saved Games" /s /q
rd "%drive%\Users\%username%\AppData\Roaming\Adobe\Flash Player\NativeCache" /s /q
rd "%drive%\Users\%username%\AppData\Roaming\Adobe\Flash Player" /s /q
rd "%drive%\Users\%username%\AppData\Roaming\Adobe" /s /q
del /s /f /q "%SystemDrive%\Windows\History\*"
del /s /f /q "%SystemDrive%\Windows\Recent\*"
del /s /f /q "%SystemDrive%\Windows\Spool\Printers\*"
del /s /f /q "%SystemDrive%\Windows\Prefetch\*"

:: ============================== ::
::             TASKS              ::
:: ============================== ::

echo __________________
echo.
echo  WELCOME TO GYROS
echo __________________
echo.

:: Disable Tasks
for %%i in ("UpdateOrchestrator\Reboot" "UpdateOrchestrator\Refresh Settings" "UpdateOrchestrator\USO_UxBroker_Display"
"UpdateOrchestrator\USO_UxBroker_ReadyToReboot" "WindowsUpdate\sih" "WindowsUpdate\sihboot") do schtasks /Change /TN "Microsoft\Windows\%%~i" /disable

schtasks /Change /Disable /TN "\Microsoft\Windows\Defrag\ScheduledDefrag"
schtasks /Change /Disable /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
schtasks /Change /Disable /TN "\Microsoft\Windows\WindowsUpdate\sihpostreboot"
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan"
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task"
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
schtasks /Change /Disable /TN "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents"
schtasks /Change /Disable /TN "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic"
schtasks /Change /Disable /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\PcaPatchDbTask"
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\StartupAppTask"
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
schtasks /Change /Disable /TN "\Microsoft\Windows\Device Information\Device"
schtasks /Change /Disable /TN "\Microsoft\Windows\Device Information\Device User"
schtasks /Change /Disable /TN "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance"
schtasks /Change /Disable /TN "\Microsoft\Windows\WaaSMedic\PerformRemediation"
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskFootprint\Diagnostics"
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskFootprint\StorageSense"
schtasks /Change /Disable /TN "\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask"
schtasks /Change /Disable /TN "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
schtasks /Change /Disable /TN "\Microsoft\Windows\Registry\RegIdleBackup"
schtasks /Change /Disable /TN "\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange"
schtasks /Change /Disable /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskNetwork" 
schtasks /Change /Disable /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskLogon"
schtasks /Change /Disable /TN "\Microsoft\Windows\StateRepository\MaintenanceTasks"
schtasks /Change /Disable /TN "\Microsoft\Windows\UPnP\UPnPHostConfig"
schtasks /Change /Disable /TN "\Microsoft\Windows\RetailDemo\CleanupOfflineContent"
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\ScanForUpdates"
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\ScanForUpdatesAsUser"
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\SmartRetry"
schtasks /Change /Disable /TN "\Microsoft\Windows\International\Synchronize Language Settings"
schtasks /Change /Disable /TN "\Microsoft\Windows\Printing\EduPrintProv"
schtasks /Change /Disable /TN "\Microsoft\Windows\Ras\MobilityManager"
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Zone\SynchronizeTimeZone"
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\SynchronizeTime"
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime"
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskCleanup\SilentCleanup"
schtasks /Change /Disable /TN "\Microsoft\Windows\Diagnosis\Scheduled"
schtasks /Change /Disable /TN "\Microsoft\Windows\Wininet\CacheTask"
schtasks /Change /Disable /TN "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"
schtasks /Change /Disable /TN "\Microsoft\Windows\NetTrace\GatherNetworkInfo"
schtasks /Change /Disable /TN "\Microsoft\Windows\TPM\Tpm-HASCertRetr"
schtasks /Change /Disable /TN "\Microsoft\Windows\TPM\Tpm-Maintenance"
schtasks /Change /Disable /TN "\Microsoft\Windows\Sysmain\ResPriStaticDbSync"
schtasks /Change /Disable /TN "\Microsoft\Windows\ApplicationData\appuriverifierdaily"
schtasks /Change /Disable /TN "\Microsoft\Windows\ApplicationData\appuriverifierinstall"
schtasks /Change /Disable /TN "\Microsoft\Windows\ApplicationData\DsSvcCleanup"
schtasks /Change /Disable /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319"
schtasks /Change /Disable /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64"
schtasks /Change /Disable /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64 Critical"
schtasks /Change /Disable /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 Critical"
schtasks /Change /Disable /TN "\Microsoft\XblGameSave\XblGameSaveTask"
schtasks /Change /Disable /TN "\Microsoft\XblGameSave\XblGameSaveTaskLogon"
schtasks /Change /Disable /TN "\Microsoft\WindowsManagement\Provisioning\Cellular"

timeout /t 2 >nul


echo _______________________________
echo.
echo  RESTART REQUIRED, PLEASE WAIT
echo _______________________________

timeout /t 3 >nul


echo _______________________________________________________________________________________
echo.
echo                                   ===== IMPORTANT =====
echo.
echo  MAKE SURE TO CLICK "CLOSE" WHEN THE RESTART WINDOW POPS UP. PRESS ANY KEY TO CONTINUE
echo _______________________________________________________________________________________
echo.
pause

echo __________________________________________________________________________________________
echo.
echo                                 ===== RESTARTING IN =====
echo __________________________________________________________________________________________

timeout /t 4 >nul
shutdown /r /t 10 /f