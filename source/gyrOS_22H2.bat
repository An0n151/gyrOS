:: ### gyrOS Optimization Script ###
:: ### I do not claim to have coded this myself ###
:: ### If you see your code in here and want to be credited, message me on Discord ###

:: ### Credits: EchoX, HoneCtrl, ArtanisInc, Rikey, DuckOS

@echo off
setlocal EnableDelayedExpansion
title gyrOS AIO Post Installation Script

:: Configure Variables
set "currentuser=%WinDir%\gyrOS\NSudo\NSudoLG.exe -U:C -P:E -Wait"
set "PowerShell=%WinDir%\System32\WindowsPowerShell\v1.0\PowerShell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command"
:: Set Computer Type ; Credits to ArtanisInc
for /f "delims=:{}" %%i in ('wmic path Win32_systemenclosure get ChassisTypes^| findstr [0-9]') do set "CHASSIS=%%i"
for %%i in (8 9 10 11 12 14 18 21 13 31 32 30) do if "!CHASSIS!"=="%%i" set "PC_TYPE=LAPTOP/TABLET"
:: Set GPU ; Credits to ArtanisInc
wmic path Win32_VideoController get Name | findstr "NVIDIA" > nul 2> nul && set "GPU=NVIDIA"
wmic path Win32_VideoController get Name | findstr "AMD ATI" > nul 2> nul && set "GPU=AMD"
wmic path Win32_VideoController get Name | findstr "Intel" > nul 2> nul && set "GPU=INTEL"
:: Set User ; Credits to ArtanisInc
for /f %%i in ('wmic path Win32_UserAccount where name^="%username%" get sid ^| findstr "S-"') do set "USER_ID=%%i"

echo _____________________________________________________________________________________________
echo.
echo  THANK YOU FOR INSTALLING GYROS 22H2 X. PRESS ANY KEY TO START APPLYING GYROS OPTIMIZATIONS.
echo.
echo  DO NOT CLOSE THIS WINDOW.
echo _____________________________________________________________________________________________
echo.
pause
cls

echo __________________
echo.
echo  GETTING READY...
echo __________________
echo.

:: Turn on Automatic Time Update ; Credits to DuckOS
%WinDir%\System32\SystemSettingsAdminFlows.exe SetInternetTime 1 > nul 2> nul

:: Turn on Automatic Time Zone Update ; Credits to DuckOS
start "" "%WinDir%\System32\SystemSettingsAdminFlows.exe" SetAutoTimeZoneUpdate 1 > nul 2> nul

:: Force Sync the Time with the Internet Time ; Credits to DuckOS
start "" "%WinDir%\System32\SystemSettingsAdminFlows.exe" ForceTimeSync 1 > nul 2> nul

:: Configure Power Plan
powercfg -import "%WinDir%\HoneV2.pow" 77777777-7777-7777-7777-777777777777 > nul 2> nul
powercfg -SETACTIVE "77777777-7777-7777-7777-777777777777" > nul 2> nul
powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c > nul 2> nul
powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a > nul 2> nul

:: Telemetry
curl -l -s https://winhelp2002.mvps.org/hosts.txt -o %SystemRoot%\System32\drivers\etc\hosts.temp
if exist %SystemRoot%\System32\drivers\etc\hosts.temp (
    cd %SystemRoot%\System32\drivers\etc
    del /f /q hosts
    ren hosts.temp hosts
)

:: OOSU10
%WinDir%\gyrOS\OOSU10.exe %WinDir%\gyrOS\OOSU10.cfg /quiet /nosrp

timeout /t 1
cls

:: ============================== ::
::       INSTALL SOFTWARE         ::
:: ============================== ::

echo ________________________
echo.
echo  INSTALLING SOFTWARE...
echo ________________________
echo.
echo.
echo.
echo.

:VisualCPP
echo _______________________________________________
echo.
echo  INSTALLING VISUAL CPP REDISTRIBUTABLES... 1/2
echo _______________________________________________
echo.
"%WinDir%\gyrOS\VisualCppRedist_AIO.exe" /ai
cls

echo ___________________________
echo.
echo  INSTALLING DIRECTX... 2/2
echo ___________________________
echo.
ping 8.8.8.8 -n 1 -w 1000 > nul 2> nul
if %errorlevel% == 0 (
:DirectX
start /wait "" "%WinDir%\gyrOS\DirectX.exe" /q
cls
) else (
echo No internet connection detected. Skipping DirectX installation.
echo.
echo Install it manually using GToolbox. Continuing...
timeout /t 3
)

:Chocolatey
::@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
::choco feature enable -n allowGlobalConfirmation

echo ______________________________
echo.
echo  FINISHED INSTALLING SOFTWARE
echo ______________________________
echo.

timeout /t 1
cls

:: Delete Post Setup Files
del /f /q %WinDir%\HoneV2.pow > nul 2> nul
del /f /q %WinDir%\gyrOS\OOSU10.exe > nul 2> nul
del /f /q %WinDir%\gyrOS\OOSU10.cfg > nul 2> nul
del /f /q %WinDir%\gyrOS\VisualCppRedist_AIO.exe > nul 2> nul
del /f /q %WinDir%\gyrOS\DirectX.exe > nul 2> nul

:: Delete Shortcuts
::del /f /q "%drive%\Users\Public\Desktop\Honeyview.lnk" > nul 2> nul

:: ============================== ::
::       WINDOWS SETTINGS         ::
:: ============================== ::

echo __________________________________
echo.
echo  SYSTEM PURIFICATION - PHASE 1...
echo __________________________________
echo.

:: Services Configuration / = boot, or = system, or = auto, or = demand, or = disabled, or = delayed-auto
sc config "W32Time" start= disabled > nul 2> nul
sc config "wcncsvc" start= disabled > nul 2> nul
sc config "SNMPTRAP" start= disabled > nul 2> nul
sc config "PcaSvc" start= disabled > nul 2> nul
sc config "WMPNetworkSvc" start= disabled > nul 2> nul
sc config "CDPUserSvc" start= demand > nul 2> nul
sc config "CDPSvc" start= disabled > nul 2> nul
sc config "VaultSvc" start= demand > nul 2> nul
sc config "wuauserv" start= demand > nul 2> nul
sc config "CryptSvc" start= demand > nul 2> nul
sc config "DusmSvc" start= demand > nul 2> nul
::sc config "AppMgmt" start= disabled > nul 2> nul
sc config "BthAvctpSvc" start= disabled > nul 2> nul
sc config "DoSvc" start= demand > nul 2> nul
sc config "dmwappushservice" start= disabled > nul 2> nul
sc config "DevQueryBroker" start= disabled > nul 2> nul
sc config "SstpSvc" start= disabled > nul 2> nul
sc config "WinHttpAutoProxySvc" start= disabled > nul 2> nul
sc config "swprv" start= disabled > nul 2> nul
sc config "svsvc" start= disabled > nul 2> nul
sc config "VSS" start= disabled > nul 2> nul
sc config "wmiApSrv" start= disabled > nul 2> nul
sc config "LanmanWorkstation" start= disabled > nul 2> nul
sc config "Netlogon" start= disabled > nul 2> nul
sc config "RpcSs" start= disabled > nul 2> nul
sc config "FrameServer" start= disabled > nul 2> nul
sc config "defragsvc" start= disabled > nul 2> nul
sc config "NcbService" start= disabled > nul 2> nul
sc config "lltdsvc" start= disabled > nul 2> nul
sc config "MSDTC" start= disabled > nul 2> nul
sc config "DeviceAssociationService" start= disabled > nul 2> nul
sc config "DmEnrollmentSvc" start= disabled > nul 2> nul
sc config "McpManagementService" start= disabled > nul 2> nul
sc config "DPS" start= disabled > nul 2> nul
sc config "diagsvc" start= disabled > nul 2> nul
sc config "WdiServiceHost" start= disabled > nul 2> nul
sc config "WdiSystemHost" start= disabled > nul 2> nul
sc config "diagnosticshub.standardcollector.service" start= disabled > nul 2> nul
sc config "wcnfs" start= disabled > nul 2> nul
sc config "lmhosts" start= disabled > nul 2> nul
sc config "SSDPSRV" start= disabled > nul 2> nul
::sc config "AppIDSvc" start= disabled > nul 2> nul
::sc config "iphlpsvc" start= disabled > nul 2> nul / Breaks Microsoft Store and UWP Applications
::sc config "wlidsvc" start= disabled > nul 2> nul / Breaks Microsoft Store Application Installs

:: Remove Folders and Files 
del "%SystemDrive%\AMFTrace.log" /s /f /q > nul 2> nul
rd "%ProgramData%\Microsoft\DiagnosticLogCSP" /s /q > nul 2> nul
rd "%drive%\Users\%username%\3D Objects" /s /q > nul 2> nul
rd "%drive%\Users\%username%\Favorites" /s /q > nul 2> nul
rd "%drive%\Users\%username%\Links" /s /q > nul 2> nul
rd "%drive%\Users\%username%\OneDrive" /s /q > nul 2> nul
rd "%drive%\Users\%username%\Searches" /s /q > nul 2> nul
rd "%drive%\Users\%username%\Contacts" /s /q > nul 2> nul
rd "%drive%\Users\%username%\Saved Games" /s /q > nul 2> nul
rd "%drive%\Users\%username%\AppData\Roaming\Adobe\Flash Player\NativeCache" /s /q > nul 2> nul
rd "%drive%\Users\%username%\AppData\Roaming\Adobe\Flash Player" /s /q > nul 2> nul
rd "%drive%\Users\%username%\AppData\Roaming\Adobe" /s /q > nul 2> nul
rd "%drive%\Users\%username%\AppData\Local\OO Software\OO ShutUp10" /s /q > nul 2> nul
rd "%drive%\Users\%username%\AppData\Local\OO Software" /s /q > nul 2> nul

:: Clean Registry Entries ; Credits to CatGamerOP and ArtanisInc
for %%a in ({990A2BD7-E738-46C7-B26F-1CF8FB9F1391} {4116F60B-25B3-4662-B732-99A6111EDC0B} {D94EE5D8-D189-4994-83D2-F68D7D41B0E6} {E0CBF06C-CD8B-4647-BB8A-263B43F0F974} {C06FF265-AE09-48F0-812C-16753D7CBA83} {D48179BE-EC20-11D1-B6B8-00C04FA372A7} {997B5D8D-C442-4F2E-BAF3-9C8E671E9E21} {6BDD1FC1-810F-11D0-BEC7-08002BE2092F} {4D36E97B-E325-11CE-BFC1-08002BE10318} {A0A588A4-C46F-4B37-B7EA-C82FE89870C6} {7EBEFBC0-3200-11D2-B4C2-00A0C9697D07} {4D36E965-E325-11CE-BFC1-08002BE10318} {53D29EF7-377C-4D14-864B-EB3A85769359} {4658EE7E-F050-11D1-B6BD-00C04FA372A7} {6BDD1FC5-810F-11D0-BEC7-08002BE2092F} {DB4F6DDD-9C0E-45E4-9597-78DBBAD0F412} {4D36E978-E325-11CE-BFC1-08002BE10318} {4D36E977-E325-11CE-BFC1-08002BE10318} {6D807884-7D21-11CF-801C-08002BE10318} {CE5939AE-EBDE-11D0-B181-0000F8753EC4} {4D36E969-E325-11CE-BFC1-08002BE10318} {4D36E970-E325-11CE-BFC1-08002BE10318} {4D36E979-E325-11CE-BFC1-08002BE10318} {4D36E96D-E325-11CE-BFC1-08002BE10318}) do (
    %currentuser% reg delete "HKLM\System\CurrentControlSet\Control\Class\%%a" /f
) > nul 2> nul
:: Clean Windows Defender Registry Entries
for %%i in ("HKLM\SOFTWARE\Microsoft\Windows Defender" "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" "HKCU\SOFTWARE\Microsoft\Windows Defender Security Center" "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows Defender" "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WindowsDefenderSecurityCenter" "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Defender" "HKLM\SOFTWARE\Policies\Microsoft\Microsoft Antimalware" "HKCR\Folder\shell\WindowsDefender" "HKCR\DesktopBackground\Shell\WindowsSecurity" "HKLM\SOFTWARE\Microsoft\Security Center" "HKLM\SYSTEM\CurrentControlSet\Services\wscsvc" "HKLM\SYSTEM\CurrentControlSet\Services\SecurityHealthService") do (
	%currentuser% reg delete %%i /f
) > nul 2> nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f > nul 2> nul

:: Configure Windows Search
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SearchBoxVisibleInTouchImprovement" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsDeviceSearchHistoryEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsDynamicSearchBoxEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsAADCloudSearchEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsMSACloudSearchEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "SafeSearchMode" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "HasAboveLockTips" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "AnyAboveLockAppsActive" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "IsAssignedAccess" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "IsMicrophoneAvailable" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "IsWindowsHelloActive" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "DeviceHistoryEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
:: Disable Search Indexing
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventIndexOnBattery" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventIndex" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableRemovableDriveIndexing" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\SearchCompanion" /v "DisableContentFileUpdate" /t REG_DWORD /d "1" /f > nul 2> nul

:: Configure System Permissions
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t REG_SZ /d "Deny" /f > nul 2> nul

:: Configure Application Permissions
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessAccountInfo" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f > nul 2> nul

:: System Information
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Manufacturer" /t REG_SZ /d "gyrOS" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Model" /t REG_SZ /d "gyrOS" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportHours" /t REG_SZ /d "Discord" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportPhone" /t REG_SZ /d "69420" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportURL" /t REG_SZ /d "https://discord.gg/u3ruZyKsWT" /f > nul 2> nul

:: Configure Windows Update
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AlwaysAutoRebootAtScheduledTime" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f > nul 2> nul
:: Disable Windows Upgrade and Insider Previews 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableOSUpgrade" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\OSUpgrade" /v "AllowOSUpgrade" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "DisableOSUpgrade" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\Setup\UpgradeNotification" /v "UpgradeAvailable" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "AUOptions" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /v "HideInsiderPage" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableExperimentation" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Security Warning "The publisher could not be verified" 
echo %windir%\System32\notepad.exe > "%temp%\temporary.txt"
for /f "usebackq delims=" %%a in ("%temp%\temporary.txt") do (
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%%a" /t REG_SZ /d "RUNASADMIN" /f > nul 2> nul
)
del "%temp%\temporary.txt"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Associations" /v "DefaultFileTypeRisk" /t REG_DWORD /d "1808" /f > nul 2> nul

:: Disable Security Warning "Unblock the downloaded file"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable "Open File - Security Warning" 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /V "1806" /t "REG_DWORD" /d "00000000" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /V "1806" /t "REG_DWORD" /d "00000000" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Associations" /v "LowRiskFileTypes" /t REG_SZ /d ".zip;.rar;.nfo;.exe;.bat;.cmd;.reg;.msi;.htm;.html;.gif;.bmp;.jpg;.jpeg;.png;.tif;.tiff;.mp3;.wma;.wav;.ogg;.mid;.midi;.avi;.mpg;.mpeg;.mov;.wmv;.asf;.swf;.vob;.mp4;.flv;.f4v;.mkv;.m4v;.rm;.rmvb;.doc;.docx;.xls;.xlsx;.ppt;.pptx;.pdf;.vsd;.vsdx;.odt;.odp;.ods;.odg;.odc;.odb;.odf;.rtf" /f > nul 2> nul

:: Enable Detailed Startup / Shutdown Messages
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "VerboseStatus" /t REG_DWORD /d "1" /f > nul 2> nul

:: Add "Take Ownership" to Context Menu
reg add "HKCR\*\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f > nul 2> nul
reg add "HKCR\*\shell\runas" /v "HasLUAShield" /t REG_SZ /d "" /f > nul 2> nul
reg add "HKCR\*\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f > nul 2> nul
reg add "HKCR\*\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f > nul 2> nul
reg add "HKCR\*\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f > nul 2> nul
reg add "HKCR\Directory\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f > nul 2> nul
reg add "HKCR\Directory\shell\runas" /v "HasLUAShield" /t REG_SZ /d "" /f > nul 2> nul
reg add "HKCR\Directory\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f > nul 2> nul
reg add "HKCR\Directory\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F" /f > nul 2> nul
reg add "HKCR\Directory\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F" /f > nul 2> nul

:: Remove "3D Objects" from File Explorer
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f > nul 2> nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f > nul 2> nul

:: Set "Do this for all current items" to be checked by Default 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" /v "ConfirmationCheckBoxDoForAll" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\Control Panel\Desktop" /v "ConfirmFileDelete" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\Control Panel\Desktop" /v "ConfirmFileOp" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Retrieving Device Metadata from the Internet
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable Enhance Pointer Precision ; Credits to HoneCtrl
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d "0000000000000000156e000000000000004001000000000029dc0300000000000000280000000000" /f > nul 2> nul
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d "0000000000000000fd11010000000000002404000000000000fc12000000000000c0bb0100000000" /f > nul 2> nul
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f > nul 2> nul

:: Hide PerfLogs Folder
attrib +h "%drive%\perflogs" > nul 2> nul

:: Static Scrollbars***
reg add "HKCU\\Control Panel\Accessibility" /v "DynamicScrollbars" /t REG_DWORD /d "0" /f > nul 2> nul

:: Configure BSOD ; Credits to HoneCtrl
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "LogEvent" /t REG_DWORD /d "0" /f > nul 2> nul

:: Remove "Bitmap Image" from "New" Context Menu
reg delete "HKCR\.bmp\ShellNew" /f > nul 2> nul

:: Configure Snap Settings
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapAssist" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "JointResize" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapFill" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Feedback
%currentuser% reg add "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f > nul 2> nul
%currentuser% reg delete "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /f > nul 2> nul

:: Disable Activity History
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities " /t REG_DWORD /d "0" /f > nul 2> nul

:: File Explorer ; Credits to ArtanisInc, Rikey and Melody***
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "DesktopProcess" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t  REG_DWORD /d 0 /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableBalloonTips" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StartButtonBalloonTip" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "FolderContentsInfoTip" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowInfoTip" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoLowDiskSpaceChecks" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "LinkResolveIgnoreLinkInfo" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveSearch" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveTrack" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetOpenWith" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoOnlinePrintsWizard" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoPublishingWizard" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWebServices" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /d "1" /t REG_DWORD /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ClearRecentDocsOnExit" /d "1" /t REG_DWORD /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /d "1" /t REG_DWORD /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "Norecentdocsnethood" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete" /v "AutoSuggest" /t REG_SZ /d "no" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoRemoteDestinations" /t REG_DWORD /d "1" /f > nul 2> nul

:: Set DNS
::netsh interface ip set dns name="Ethernet" static 8.8.8.8 > nul 2> nul
::netsh interface ip add dns name="Ethernet" 8.8.4.4 index=2 > nul 2> nul

:: Configure Firewall
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes > nul 2> nul
:: Disable Firewall
netsh advfirewall set allprofiles state off > nul 2> nul
::reg add "HKLM\SYSTEM\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "3" /f > nul 2> nul
::reg add "HKLM\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "3" /f > nul 2> nul

:: Remove "Include in Library" Context Menu
reg delete "HKCR\Folder\ShellEx\ContextMenuHandlers\Library Location" /f > nul 2> nul
reg delete "HKLM\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location" /f > nul 2> nul

:: Remove "Share" from Context Menu
reg delete "HKCR\*\shellex\ContextMenuHandlers\ModernSharing" /f > nul 2> nul

:: Disable IPv6, Client for Microsoft Networks, QoS Packet Scheduler, File and Printer Sharing ; Credits to DuckOS
PowerShell -Mta -NoProfile -Command "Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6, ms_msclient, ms_pacer, ms_server" > nul 2> nul

:: Add "Run with Priority" to Context Menu
reg add "HKCR\exefile\shell\Priority" /v "MUIVerb" /t REG_SZ /d "Run with priority" /f > nul 2> nul
reg add "HKCR\exefile\shell\Priority" /v "SubCommands" /t REG_SZ /d "" /f > nul 2> nul
reg add "HKCR\exefile\Shell\Priority\shell\001flyout" /ve /t REG_SZ /d "Realtime" /f > nul 2> nul
reg add "HKCR\exefile\Shell\Priority\shell\001flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /Realtime \"%%1\"" /f > nul 2> nul
reg add "HKCR\exefile\Shell\Priority\shell\002flyout" /ve /t REG_SZ /d "High" /f > nul 2> nul
reg add "HKCR\exefile\Shell\Priority\shell\002flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /High \"%%1\"" /f > nul 2> nul
reg add "HKCR\exefile\Shell\Priority\shell\003flyout" /ve /t REG_SZ /d "Above normal" /f > nul 2> nul
reg add "HKCR\exefile\Shell\Priority\shell\003flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /AboveNormal \"%%1\"" /f > nul 2> nul
reg add "HKCR\exefile\Shell\Priority\shell\004flyout" /ve /t REG_SZ /d "Normal" /f > nul 2> nul
reg add "HKCR\exefile\Shell\Priority\shell\004flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /Normal \"%%1\"" /f > nul 2> nul
reg add "HKCR\exefile\Shell\Priority\shell\005flyout" /ve /t REG_SZ /d "Below normal" /f > nul 2> nul
reg add "HKCR\exefile\Shell\Priority\shell\005flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /BelowNormal \"%%1\"" /f > nul 2> nul
reg add "HKCR\exefile\Shell\Priority\shell\006flyout" /ve /t REG_SZ /d "Low" /f > nul 2> nul
reg add "HKCR\exefile\Shell\Priority\shell\006flyout\command" /ve /t REG_SZ /d "cmd.exe /c start \"\" /Low \"%%1\"" /f > nul 2> nul

:: Remove "Edit with Paint 3D" from Context Menu 
reg delete "HKCR\SystemFileAssociations\.3mf\Shell\3D Edit" /f > nul 2> nul
reg delete "HKCR\SystemFileAssociations\.bmp\Shell\3D Edit" /f > nul 2> nul
reg delete "HKCR\SystemFileAssociations\.fbx\Shell\3D Edit" /f > nul 2> nul
reg delete "HKCR\SystemFileAssociations\.gif\Shell\3D Edit" /f > nul 2> nul
reg delete "HKCR\SystemFileAssociations\.jfif\Shell\3D Edit" /f > nul 2> nul
reg delete "HKCR\SystemFileAssociations\.jpe\Shell\3D Edit" /f > nul 2> nul
reg delete "HKCR\SystemFileAssociations\.jpeg\Shell\3D Edit" /f > nul 2> nul
reg delete "HKCR\SystemFileAssociations\.jpg\Shell\3D Edit" /f > nul 2> nul
reg delete "HKCR\SystemFileAssociations\.png\Shell\3D Edit" /f > nul 2> nul
reg delete "HKCR\SystemFileAssociations\.tif\Shell\3D Edit" /f > nul 2> nul
reg delete "HKCR\SystemFileAssociations\.tiff\Shell\3D Edit" /f > nul 2> nul

:: Disable USB Autorun / Autoplay ; Credits to ArtanisInc
reg add "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main" /v "Autorun" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutoplayfornonVolume" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DontSetAutoplayCheckbox" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t REG_DWORD /d "1" /f > nul 2> nul

:: Hide Disconnected Audio Devices
reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowHiddenDevices" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowDisconnectedDevices" /t REG_DWORD /d "0" /f > nul 2> nul

:: Set Sound Scheme to "No Sounds"
reg add "HKCU\AppEvents\Schemes" /t REG_SZ /v "" /d ".None" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\.Default\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\.Default\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\DeviceFail\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\DeviceFail\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\FaxBeep\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\FaxBeep\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\MailBeep\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\MailBeep\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\MessageNudge\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\MessageNudge\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Default\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Default\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\Notification.IM\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.IM\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Mail\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Mail\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Proximity\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Proximity\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Reminder\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.Reminder\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\Notification.SMS\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\Notification.SMS\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\ProximityConnection\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\ProximityConnection\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\SystemExclamation\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\SystemExclamation\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\SystemHand\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\SystemHand\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\SystemNotification\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\SystemNotification\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\.Default\WindowsUAC\.Current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\.Default\WindowsUAC\.Current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound\.current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound\.current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\sapisvr\HubOffSound\.current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\HubOffSound\.current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\sapisvr\HubOnSound\.current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\HubOnSound\.current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\sapisvr\HubSleepSound\.current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\HubSleepSound\.current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\sapisvr\MisrecoSound\.current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\MisrecoSound\.current" /f > nul 2> nul
reg delete "HKCU\AppEvents\Schemes\Apps\sapisvr\PanelSound\.current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\PanelSound\.current" /f > nul 2> nul

:: Set Sound Communications to "Do nothing"
reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f > nul 2> nul

:: Disable Startup Sound
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" /v "DisableStartupSound" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable "Notify me if my PC is charging slowly over USB" 
reg add "HKCU\Software\Microsoft\Shell\USB" /v "NotifyOnWeakCharger" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable "Autocorrect Misspelled Words"
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableAutocorrection" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable "Highlight Misspelled Words"
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableSpellchecking" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable "Add a Space After I Choose a Text Suggestion"
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnablePredictionSpaceInsertion" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable "Add a Period After I Double Tap the Spacebar"
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableDoubleTapSpace" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Text Suggestions on Touch Keyboard
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableTextPrediction" /t REG_DWORD /d "0" /f > nul 2> nul

:: Remove "Quick Access" from "This PC" 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "HubMode" /t REG_DWORD /d "1" /f > nul 2> nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace_36354489\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" /f > nul 2> nul

:: Hide Recently Added Applications from Start Menu 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HideRecentlyAddedApps" /t REG_DWORD /d "1" /f > nul 2> nul

:: Hide Most Used Applications from Start Menu 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoStartMenuMFUprogramsList" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable Enable Open Xbox Game Bar using Game Controller
reg add "HKCU\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable "USB Connection Error" Notification
reg add "HKCU\SOFTWARE\Microsoft\Shell\USB" /v "NotifyOnUsbErrors" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable "Let Windows Manage my Default Printer"
reg add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "LegacyDefaultPrinterMode" /t REG_DWORD /d "1" /f > nul 2> nul

:: Remove "Troubleshoot Compatibility" from Context Menu 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f > nul 2> nul

:: Remove "-Shortcut" Text Addition 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates" /v "ShortcutNameTemplate" /t REG_SZ /d "\"%s.lnk\"" /f > nul 2> nul

:: Remove "Send To" from Context Menu 
reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" /f > nul 2> nul
reg delete "HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\SendTo" /f > nul 2> nul

:: Add "New CMD File" to Context Menu 
reg add "HKCR\.cmd\ShellNew" /v "NullFile" /t REG_SZ /d "" /f > nul 2> nul

:: Add "New Batch File" to Context Menu 
reg add "HKCR\.bat\ShellNew" /v "NullFile" /t REG_SZ /d "" /f > nul 2> nul

:: Add "Registry Entries" to Context Menu ; Credits to DuckOS 
reg add "HKLM\Software\Classes\.reg\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@%WinDir%\regedit.exe,-309" /f > nul 2> nul
reg add "HKLM\Software\Classes\.reg\ShellNew" /v "NullFile" /t REG_SZ /d "" /f > nul 2> nul

:: Add Option "Merge as TrustedInstaller" ; Credits to DuckOS 
reg add "HKCR\regfile\Shell\RunAs" /ve /t REG_SZ /d "Merge as TrustedInstaller" /f > nul 2> nul
reg add "HKCR\regfile\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "1" /f > nul 2> nul
reg add "HKCR\regfile\Shell\RunAs\Command" /ve /t REG_SZ /d "%WinDir%\gyrOS\NSudo\NSudoLG.exe -U:T -P:E reg import "%%1"" /f > nul 2> nul

:: Add "Install CAB File" to Context Menu 
reg delete "HKCR\CABFolder\Shell\RunAs" /f > nul 2> nul
reg add "HKCR\CABFolder\Shell\RunAs" /v "" /t REG_SZ /d "Install" /f > nul 2> nul
reg add "HKCR\CABFolder\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "" /f > nul 2> nul
reg add "HKCR\CABFolder\Shell\RunAs\Command" /v "" /t REG_SZ /d "cmd /k dism /online /add-package /packagepath:\"%1\"" /f > nul 2> nul

:: Add "Copy as Path" to Context Menu 
reg add "HKCR\Allfilesystemobjects\shell\windows.copyaspath" /v "" /t REG_SZ /d "Copy &as path" /f > nul 2> nul
reg add "HKCR\Allfilesystemobjects\shell\windows.copyaspath" /v "Icon" /t REG_SZ /d "imageres.dll,-5302" /f > nul 2> nul
reg add "HKCR\Allfilesystemobjects\shell\windows.copyaspath" /v "InvokeCommandOnSelection" /t REG_DWORD /d 0x00000001 /f > nul 2> nul
reg add "HKCR\Allfilesystemobjects\shell\windows.copyaspath" /v "VerbHandler" /t REG_SZ /d "{f3d06e7c-1e45-4a26-847e-f9fcdee59be0}" /f > nul 2> nul
reg add "HKCR\Allfilesystemobjects\shell\windows.copyaspath" /v "VerbName" /t REG_SZ /d "copyaspath" /f > nul 2> nul

:: Remove "Restore Previous Versions" from Context Menu ; Credits to Melody 
reg delete "HKCR\AllFilesystemObjects\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f > nul 2> nul
reg delete "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f > nul 2> nul
reg delete "HKCR\Directory\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f > nul 2> nul
reg delete "HKCR\Drive\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f > nul 2> nul
reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f > nul 2> nul
reg delete "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f > nul 2> nul
reg delete "HKCR\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f > nul 2> nul
reg delete "HKCR\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "NoPreviousVersionsPage" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\Software\Policies\Microsoft\PreviousVersions" /v "DisableLocalPage" /t REG_DWORD /d "1" /f > nul 2> nul

:: Remove "Look for an Application in the Microsoft Store" 
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "0xffffffff" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "1" /f > nul 2> nul

:: Remove "Compressed (zipped) Folder from "New" Context Menu

:: Unpin Tiles from Start Menu***
for /f "tokens=*" %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" /s /f "start.tilegrid"^| findstr "start.tilegrid"') do reg delete "%%i" /f > nul 2> nul

:: Disable Ease of Access Settings
reg add "HKCU\Software\Microsoft\Ease of Access" /v "selfvoice" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Ease of Access" /v "selfscan" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Accessibility" /v "Sound on Activation" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Accessibility" /v "Warning Sounds" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Accessibility\HighContrast" /v "Flags" /t REG_SZ /d "4194" /f > nul 2> nul
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_SZ /d "2" /f > nul 2> nul
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatRate" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatDelay" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Accessibility\MouseKeys" /v "Flags" /t REG_SZ /d "130" /f > nul 2> nul
reg add "HKCU\Control Panel\Accessibility\MouseKeys" /v "MaximumSpeed" /t REG_SZ /d "39" /f > nul 2> nul
reg add "HKCU\Control Panel\Accessibility\MouseKeys" /v "TimeToMaximumSpeed" /t REG_SZ /d "3000" /f > nul 2> nul
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "2" /f > nul 2> nul
reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_SZ /d "34" /f > nul 2> nul
reg add "HKCU\Control Panel\Accessibility\SoundSentry" /v "Flags" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Accessibility\SoundSentry" /v "FSTextEffect" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Accessibility\SoundSentry" /v "TextEffect" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Accessibility\SoundSentry" /v "WindowsEffect" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Accessibility\SlateLaunch" /v "ATapp" /t REG_SZ /d "" /f > nul 2> nul
reg add "HKCU\Control Panel\Accessibility\SlateLaunch" /v "LaunchAT" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Magnifier Settings
reg add "HKCU\SOFTWARE\Microsoft\ScreenMagnifier" /v "FollowCaret" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\ScreenMagnifier" /v "FollowNarrator" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\ScreenMagnifier" /v "FollowMouse" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\ScreenMagnifier" /v "FollowFocus" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Narrator Settings
reg add "HKCU\SOFTWARE\Microsoft\Narrator" /v "IntonationPause" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Narrator" /v "ReadHints" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Narrator" /v "ErrorNotificationType" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Narrator" /v "EchoChars" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Narrator" /v "EchoWords" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Narrator" /v "NarratorCursorHighlight" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Narrator" /v "CoupleNarratorCursorKeyboard" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Narrator\NoRoam" /v "EchoToggleKeys" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Narrator\NoRoam" /v "DuckAudio" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Narrator\NoRoam" /v "WinEnterLaunchEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Narrator\NoRoam" /v "ScriptingEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Narrator\NoRoam" /v "OnlineServicesEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Narrator\NarratorHome" /v "MinimizeType" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Narrator\NarratorHome" /v "AutoStart" /t REG_DWORD /d "0" /f > nul 2> nul

:: Appearance Optimizations ; Credits to Melody and DuckOS 
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000" /f > nul 2> nul
:: Disable Animations in the Taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f > nul 2> nul
:: Disable "Peek"
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f > nul 2> nul
:: Disable "Save Taskbar Thumbnail Previews"
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d "0" /f > nul 2> nul
:: Enable "Show Thumbnails Instead of Icons"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "IconsOnly" /t REG_DWORD /d "0" /f > nul 2> nul
:: Disable "Animate Windows when Minimizing and Maximizing"
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_DWORD /d "0" /f > nul 2> nul
:: Disable "Show Translucent Selection Rectangle"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d "0" /f > nul 2> nul
:: Disable "Use Drop Shadows for Icon Labels on the Desktop"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d "0" /f > nul 2> nul
:: Disable Transparency***
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableBlurBehind" /t REG_DWORD /d "0" /f > nul 2> nul
:: Reduce Size of Minimize, Maximize, Close Buttons
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "CaptionWidth" /t REG_SZ /d "-270" /f > nul 2> nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "CaptionHeight" /t REG_SZ /d "-270" /f > nul 2> nul
:: Disable Accent Color
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "ColorPrevalence" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "ColorPrevalence" /t REG_DWORD /d "0" /f > nul 2> nul
:: Change Clock and Date Format
reg add "HKCU\Control Panel\International" /v "iMeasure" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\International" /v "iNegCurr" /t REG_SZ /d "1" /f > nul 2> nul
reg add "HKCU\Control Panel\International" /v "iTime" /t REG_SZ /d "1" /f > nul 2> nul
reg add "HKCU\Control Panel\International" /v "sShortDate" /t REG_SZ /d "dd.MM.yyyy" /f > nul 2> nul
reg add "HKCU\Control Panel\International" /v "sShortTime" /t REG_SZ /d "HH:mm" /f > nul 2> nul
reg add "HKCU\Control Panel\International" /v "sTimeFormat" /t REG_SZ /d "H:mm:ss" /f > nul 2> nul
:: Improve Desktop Wallpaper Quality
reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t "REG_DWORD" /d "100" /f > nul 2> nul

:: Rest of Appearance Optimizations***
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ThemeManager" /v "ThemeActive" /t REG_SZ /d "0" /f > nul 2> nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d "0" /f > nul 2> nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "DesktopHeapLogging" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "DwmInputUsesIoCompletionPort" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "EnableDwmInputProcessing" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "AnimationAttributionEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "AnimationAttributionHashingEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OneCoreNoBootDWM" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DWMWA_TRANSITIONS_FORCEDISABLED" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowFlip3d" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowColorizationColorChanges" /t REG_DWORD /d "1" /f > nul 2> nul
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f > nul 2> nul / Breaks "Animate Windows when Minimizing and Maximizing" setting
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v AlwaysHibernateThumbnails /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v CompositionPolicy /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows" /v "DisableAcrylicBackgroundOnLogon" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "TurnOffSPIAnimations" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "DisableLogonBackgroundImage" /t REG_DWORD /d "1" /f > nul 2> nul

timeout /t 2
cls

:: ============================== ::
::      APPLICATION SETTINGS      ::
:: ============================== ::

echo __________________________________
echo.
echo  SYSTEM PURIFICATION - PHASE 2...
echo __________________________________
echo.

:: Configure Internet Explorer
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Main" /v "DEPOff" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Security" /v "DisableSecuritySettingsCheck" /t "REG_DWORD" /d "1" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Internet Explorer\Main" /v "NoUpdateCheck" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Enable Browser Extensions" /t REG_SZ /d "no" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Isolation" /t REG_SZ /d "PMEM" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Isolation64Bit" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\BrowserEmulation" /v "IntranetCompatibilityMode" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer" /v "DisableFlashInIE" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\SQM" /v "DisableCustomerImprovementProgram" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\DomainSuggestion" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Security" /v "DisableFixSecuritySettings" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Privacy" /v "EnableInPrivateBrowsing" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Privacy" /v "ClearBrowsingHistoryOnExit" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Main" /v "EnableAutoUpgrade" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Main" /v "DisableFirstRunCustomize" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Main" /v "HideNewEdgeButton" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Feed Discovery" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Feeds" /v "BackgroundSyncStatus" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\FlipAhead" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Suggested Sites" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\TabbedBrowsing" /v "NewTabPageShow" /t REG_DWORD /d "1" /f > nul 2> nul

:: Configure Notepad
::reg add "HKCR\*\shell\Open with Notepad" /v "Icon" /t REG_SZ /d "notepad.exe,-2" /f > nul 2> nul
::reg add "HKCR\*\shell\Open with Notepad\command" /v "" /t REG_SZ /d "notepad.exe %1" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Notepad" /v "StatusBar" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Notepad" /v "fWrap" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Notepad" /v "fSavePageSettings" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Notepad" /v "fSaveWindowPositions" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Notepad" /v "fWindowsOnlyEOL" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Notepad" /v "fPasteOriginalEOL" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Notepad" /v "iWindowPosDX" /t REG_DWORD /d "1934" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Notepad" /v "iWindowPosDY" /t REG_DWORD /d "651" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Notepad" /v "iWindowPosX" /t REG_DWORD /d "4294967289" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Notepad" /v "iWindowPosY" /t REG_DWORD /d "436" /f > nul 2> nul

:: Configure Microsoft Store
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d 2 /f > nul 2> nul

:: Configure Windows Media Player
reg add "HKLM\Software\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\WindowsMediaPlayer" /v "GroupPrivacyAcceptance" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "AcceptedEULA" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "AcceptedPrivacyStatement" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "FirstTime" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "UsageTracking" /t REG_DWORD /d "0" /f > nul 2> nul

timeout /t 2
cls

:: ============================== ::
::    UNDER THE HOOD SETTINGS     ::
:: ============================== ::

echo __________________________________
echo.
echo  SYSTEM PURIFICATION - PHASE 3...
echo __________________________________
echo.

:: Miscellaneous
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "AllowClipboardHistory" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "AllowCrossDeviceClipboard " /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SmartActionPlatform\SmartClipboard" /v "Disabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f > nul 2> nul
%currentuser% reg add "HKCU\Software\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f > nul 2> nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\FindMyDevice" /v "AllowFindMyDevice" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\FindMyDevice" /v "LocationSyncEnabled" /t REG_DWORD /d "0" /f > nul 2> nul

:: WinLogon Tweaks
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v ShowLogonOptions /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoRestartShell /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DeleteRoamingCache /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v KeepRASConnections /t REG_SZ /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v RasDisable /t REG_SZ /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v WinStationsDisabled /t REG_SZ /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v SyncForegroundPolicy /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DisableBkGndGroupPolicy /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v WaitForNetwork /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v SFCDisable /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AllowMultipleTSSessions /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\services\Netlogon\Parameters" /v ExpectedDialupDelay /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\services\Netlogon\Parameters" /v TryNextClosestSite /t REG_DWORD /d "0" /f > nul 2> nul

:: Data Execution
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "NoDataExecutionPrevention" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "DisableHHDEP" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable Biometrics
reg add "HKLM\Software\Policies\Microsoft\Biometrics" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowDomainPINLogon" /t REG_DWORD /d 0 /f > nul 2> nul

:: Disable Microsoft Windows Just-In-Time (JIT) Script Debugging
reg add "HKCU\Software\Microsoft\Windows Script\Settings" /v "JITDebug" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKU\.Default\Microsoft\Windows Script\Settings" /v "JITDebug" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Diagnostics***
for %%i in (diagsvc DPS WdiServiceHost WdiSystemHost) do (
	reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%~i" /ve
	if %errorlevel% == 0 (
		%currentuser% reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%~i" /v "Start" /t REG_DWORD /d "4" /f
	)
) > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\ScheduledDiagnostics" /v "EnabledExecution" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\ScheduledDiagnostics" /v "EnabledExecution" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\ScriptedDiagnosticsProvider\Policy" /v "DisableQueryRemoteServer" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Windows\ScriptedDiagnosticsProvider\Policy" /v "EnableQueryRemoteServer" /t REG_DWORD /d "0" /f > nul 2> nul
:: Disable Diagnostic Tracing
%currentuser% reg add "HKLM\SYSTEM\CurrentControlSet\Control\Diagnostics\Performance" /v "DisableDiagnosticTracing" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable Sharing Across Devices
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CDP" /v "CdpSessionUserAuthzPolicy" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CDP" /v "NearShareChannelUserAuthzPolicy" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CDP" /v "RomeSdkChannelUserAuthzPolicy" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Storage Health Telemetry
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\StorageHealth" /v "AllowDiskHealthModelUpdates" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl\StorageTelemetry" /v "DeviceDumpEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl\StorageTelemetry" /v "StorageTCCode_0" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl\StorageTelemetry" /v "StorageTCCode_1" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl\StorageTelemetry" /v "StorageTCCode_2" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl\StorageTelemetry" /v "StorageTCCode_3" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl\StorageTelemetry" /v "StorageTCCode_4" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Windows Logging
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF" /v "LogEnable" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF" /v "LogLevel" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Reliability" /v "TimeStampEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Reliability" /v "IncludeShutdownErrs" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Reliability" /v "SnapShot" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Web Content Evaluation
reg add "HKCU\Control Panel\International" /v "iFiltering" /t REG_DWORD /d 0 /f > nul 2> nul
reg add "HKCU\Control Panel\International" /v "iFilteringLevel" /t REG_DWORD /d 0 /f > nul 2> nul
%currentuser% reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\AppHost\Download" /v "CheckExeSignatures" /t REG_SZ /d "no" /f > nul 2> nul

:: Printer Location
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers" /v "PhysicalLocation" /t REG_SZ /d "anonymous" /f > nul 2> nul

:: Potentional Fix for Services Being Unable to Start
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "ServicesPipeTimeout" /t REG_DWORD /d "180000" /f > nul 2> nul

:: Disable Input Prediction
reg add "HKLM\Software\Microsoft\Input\Settings" /v "HarvestContacts" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Input\Settings" /v "LMDataLoggerEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Input\Settings" /v "InsightsEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Input\Settings" /v "MultilingualEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Input\Settings" /v "EnableHwkbTextPrediction" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable MSDT-URL Protocol
reg delete "HKEY_CLASSES_ROOT\ms-msdt" /f > nul 2> nul

:: Disable Shared Experiences
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "EnableCdp" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable PerfTrack
reg add "HKLM\Software\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}" /v "ScenarioExecutionEnabled" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable WPAD
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Wpad" /v "WpadOverride" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable AutoLogger
for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger" /s /f "start"^| findstr "HKEY"') do reg add "%%i" /v "Start" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Application Compatibility Telemetry  ; Credits to DuckOS and ArtanisInc
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "AllowTelemetry" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\TelemetryController" /v "RunsBlocked" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\UEV\Agent" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\UEV\Agent\Configuration" /v "CustomerExperienceImprovementProgram" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\UEV\Agent\Configuration" /v "SyncEnabled" /t REG_DWORD /d "0" /f > nul 2> nul

:: Process Mitigations 
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "222222222222222222222222222222222222222222222222" /f > nul 2> nul
reg add "HKLM\System\ControlSet001\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "222222222222222222222222222222222222222222222222" /f > nul 2> nul
reg add "HKLM\System\ControlSet002\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "222222222222222222222222222222222222222222222222" /f > nul 2> nul

:: Disable Chain Validation
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f > nul 2> nul

:: Block Untrusted Fonts and Log Events
reg add "HKLM\Software\Policies\Microsoft\Windows NT\MitigationOptions" /v "MitigationOptions_FontBocking" /t REG_SZ /d "1000000000000" /f > nul 2> nul

:: Disable TsX to Mitigate ZombieLoad
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "DisableTsx" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable Access to Language List
%currentuser% reg add "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable Spectre and Meltdown ; Credits to HoneCtrl
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f > nul 2> nul
%WinDir%\gyrOS\NSudo\NSudoLG.exe -U:S -ShowWindowMode:Hide -wait cmd /c "reg add "HKLM\SYSTEM\CurrentControlSet\Services\TrustedInstaller" /v "Start" /t Reg_DWORD /d "3" /f" > nul 2> nul
%WinDir%\gyrOS\NSudo\NSudoLG.exe -U:S -ShowWindowMode:Hide -wait cmd /c "sc start "TrustedInstaller"" > nul 2> nul
%WinDir%\gyrOS\NSudo\NSudoLG.exe -U:T -P:E -M:S -ShowWindowMode:Hide -wait cmd /c "del %SYSTEMROOT%\System32\mcupdate_GenuineIntel.dll" > nul 2> nul
%WinDir%\gyrOS\NSudo\NSudoLG.exe -U:T -P:E -M:S -ShowWindowMode:Hide -wait cmd /c "del %SYSTEMROOT%\System32\mcupdate_AuthenticAMD.dll" > nul 2> nul
taskkill /im GameBarPresenceWriter.exe /f > nul 2> nul
%WinDir%\gyrOS\NSudo\NSudoLG.exe -U:T -P:E -M:S -ShowWindowMode:Hide -wait cmd /c "del %WinDir%\System32\GameBarPresenceWriter.exe" > nul 2> nul
%currentuser% reg add "HKLM\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter" /v "ActivationType" /t REG_DWORD /d "0" /f > nul 2> nul

:: Refuse Secure Authentication
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "LmCompatibilityLevel" /t REG_DWORD /d "5" /f > nul 2> nul

:: Prevent Storage of the LAN Manager Hash of Passwords
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "NoLMHash" /t REG_DWORD /d "1" /f > nul 2> nul

:: Prevent WinRM from using Basic Authentication
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client" /v "AllowBasic" /t REG_DWORD /d "0" /f > nul 2> nul

:: TaggedEnergy, Power Logging and Telemetry
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxTagPerApplication" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "DisableTaggedEnergyLogging" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxApplication" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\RemovalTools\MpGears" /v "HeartbeatTrackingIndex" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\RemovalTools\MpGears" /v "SpyNetReportingLocation" /t REG_MULTI_SZ /d "" /f > nul 2> nul

:: Reliable Timestamp ; Credits to EchoX
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Reliability" /v "TimeStampInterval" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Reliability" /v "IoPriority" /t REG_DWORD /d "3" /f > nul 2> nul

:: Disable Hibernation and Fast Startup
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabledDefault" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d "0" /f > nul 2> nul

powercfg /h off > nul 2> nul

:: Disable CFG Lock / Breaks Valorant
::reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable ASLR
::reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "MoveImages" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable PowerShell Telemetry
setx POWERSHELL_TELEMETRY_OPTOUT 1 > nul 2> nul

:: Disable NET Core CLI Telemetry
setx DOTNET_CLI_TELEMETRY_OPTOUT 1 > nul 2> nul

:: Enable Numlock on Startup
%currentuser% reg add "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /d "2" /t REG_DWORD /f > nul 2> nul

:: Disable DMA Remapping ; Credits to DuckOS
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\DmaGuard\DeviceEnumerationPolicy" /v "value" /t REG_DWORD /d "2" /f > nul 2> nul
for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f DmaRemappingCompatible ^| find /i "Services\" ') do (
	reg add "%%i" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f
) > nul 2> nul

:: Disable Virtualization-Based Protection of Code Integrity 
reg add "HKLM\Software\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable NetBios / NetBT ; Credits to ArtanisInc 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" /v "SMBDeviceEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\System\CurrentControlSet\Services\NetBT\Parameters" /v "EnableLMHOSTS" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\System\CurrentControlSet\Services\NetBT\Parameters\Interfaces" /v "NetbiosOptions" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBIOS" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lmhosts" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul

for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces" /s /f "NetbiosOptions"^| findstr "HKEY"') do (
	reg add "%%i" /v "NetbiosOptions" /t REG_DWORD /d "2" /f
) > nul 2> nul

:: Disable Windows Defender
bcdedit /set disableelamdrivers Yes > nul 2> nul

:: Disable DMA Memory Protection & Cores Isolation 
bcdedit /set vsmlaunchtype Off > nul 2> nul
bcdedit /set vm No > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "ConfigureSystemGuardLaunch" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "RequirePlatformSecurityFeatures" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "LsaCfgFlags" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable System Devices
%WinDir%\gyrOS\DevManView.exe /disable "WAN Miniport (IPv6)" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "WAN Miniport (IKEv2)" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "WAN Miniport (L2TP)" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "WAN Miniport (IP)" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "System Speaker" MemoryDiagnostic > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "System Speaker" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "System Timer" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "Motherboard resources" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "Microsoft Hyper-V NT Kernel Integration VSP" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "Microsoft Hyper-V PCI Server" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "UMBus Root Bus Enumerator" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "Microsoft System Management BIOS Driver" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "High Precision Event Timer" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "PCI Encryption/Decryption Controller" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "AMD PSP" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "AMD SMBus" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "PCI Data Acquisition and Signal Processing Controller" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "Intel SMBus" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "Intel Management Engine" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "Microsoft Hyper-V Virtual Machine Bus Provider" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "Microsoft Hyper-V Virtualization Infrastructure Driver" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "PCI Memory Controller" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "PCI standard RAM Controller" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "Composite Bus Enumerator" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "Microsoft Kernel Debug Network Adapter" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "SM Bus Controller" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "NDIS Virtual Network Adapter Enumerator" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "Numeric Data Processor" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "Microsoft RRAS Root Enumerator" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "Microsoft Hyper-V Virtual Disk Server" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "System CMOS/real time clock" > nul 2> nul
%WinDir%\gyrOS\DevManView.exe /disable "PCI Simple Communications Controller" > nul 2> nul

:: Opt-Out of Sending Client Activation Data to Microsoft ; Credits to ArtanisInc
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "AllowWindowsEntitlementReactivation" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable Windows Error Reporting ; Credits to DuckOS
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d "0" /f > nul 2> nul

:: Data Queue Sizes
reg add "HKLM\System\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d "25" /f > nul 2> nul
reg add "HKLM\System\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d "25" /f > nul 2> nul

:: Disable Speech Model Updates
reg add "HKLM\SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v "HasAccepted" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Remote Assistance ; Credits to ArtanisInc***
for %%i in (RasAuto SessionEnv TermService UmRdpService RpcLocator) do (
	reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%~i" /ve
	if %errorlevel% == 0 (
		%currentuser% reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%~i" /v "Start" /t REG_DWORD /d "4" /f
	)
) > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service\WinRS" /v "AllowRemoteShellAccess" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowFullControl" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "fAllowFullControl" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "fAllowUnsolicited" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "fAllowUnsolicitedFullControl" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "fDenyTSConnections" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "TSAppCompat" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "TSEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "TSUserEnabled" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Paths over 260 Characters
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "LongPathsEnabled" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable FTH
reg add "HKLM\SOFTWARE\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul

:: Enable GameMode
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "1" /f > nul 2> nul

:: Configure Gamebar
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "GamePanelStartupTipIndex" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "__COMPAT_LAYER" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f > nul 2> nul

:: Configure FSO ; Credits to ArtanisInc
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_DSEBehavior" /t REG_DWORD /d "2" /f > nul 2> nul

:: Wait to Kill Applications at Shutdown
reg add "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "1000" /f > nul 2> nul

:: Wait to End Service at Shutdown
reg add "HKLM\System\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "1000" /f > nul 2> nul

:: Blocking Data Collection and Telemetry
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowCommercialDataPipeline" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowDesktopAnalyticsProcessing" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowWUfBCloudProcessing" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "CommercialId" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DisableEnterpriseAuthProxy" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "TelemetryProxyServer" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f > nul 2> nul

:: Remove Dependencies ; Credits to DuckOS
reg add "HKLM\System\CurrentControlSet\Services\Dhcp" /v "DependOnService" /t REG_MULTI_SZ /d "NSI\0Afd" /f > nul 2> nul
reg add "HKLM\System\CurrentControlSet\Services\Dnscache" /v "DependOnService" /t REG_MULTI_SZ /d "nsi" /f > nul 2> nul
reg add "HKLM\System\CurrentControlSet\Services\rdyboost" /v "DependOnService" /t REG_MULTI_SZ /d "" /f > nul 2> nul
::reg add "HKLM\System\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "UpperFilters" /t REG_MULTI_SZ  /d "" /f > nul 2> nul

:: Disable CEIP
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Messenger\Client" /v "CEIP" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\AppV\CEIP" /v "CEIPEnable" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Sleep Study
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable Startup Delay for RunOnce and Run Keys
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f > nul 2> nul

:: Content Delivery Manager ; Credits to DuckOS 
for %%a in (310093 353698 314563 338389 338387 338388 338393) do ( %currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-%%aEnabled" /t REG_DWORD /d "0" /f ) > nul 2> nul
for %%a in (RotatingLockScreenOverlayEnabled RotatingLockScreenEnabled SoftLandingEnabled SystemPaneSuggestionsEnabled SilentInstalledAppsEnabled ContentDeliveryAllowed) do ( %currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "%%a" /t REG_DWORD /d "0" /f ) > nul 2> nul

:: Netsh Tweaks
netsh interface tcp set global autotuningl = experimental >nul
netsh interface tcp set global autotuning = experimental >nul
netsh interface tcp set heuristics disabled >nul
netsh interface tcp set global rss=enabled > nul 2> nul
netsh interface isatap set state disabled > nul 2> nul
netsh interface ip set interface ethernet currenthoplimit=64 > nul 2> nul
netsh interface tcp set global dca=enabled > nul 2> nul
netsh interface tcp set global rsc=disabled > nul 2> nul
netsh interface tcp set global ecncapability=enabled > nul 2> nul
netsh interface tcp set global timestamps=disabled > nul 2> nul
netsh interface tcp set global nonsackrttresiliency=disabled > nul 2> nul
netsh interface tcp set global maxsynretransmissions=2 > nul 2> nul
netsh interface tcp set supplemental template=custom icw=10 > nul 2> nul
netsh interface tcp set global fastopen=enabled > nul 2> nul
netsh interface tcp set global fastopenfallback=enabled > nul 2> nul
netsh interface tcp set security mpp=disabled > nul 2> nul
netsh interface tcp set security profiles=disabled > nul 2> nul
netsh interface udp set global uro=enabled > nul 2> nul
netsh interface 6to4 set state state=enabled > nul 2> nul
netsh interface tcp set global hystart=disabled > nul 2> nul
netsh interface tcp set global pacingprofile=off > nul 2> nul
netsh interface tcp set global initialRto=3000 > nul 2> nul

::netsh interface tcp set global netdma=enabled > nul 2> nul
::netsh interface tcp set global chimney=disabled > nul 2> nul

timeout /t 2
cls

:: ============================== ::
::   PERFORMANCE OPTIMIZATIONS    ::
:: ============================== ::

echo __________________________________
echo.
echo  SYSTEM PURIFICATION - PHASE 4...
echo __________________________________
echo.

:: Set Service Split Threshold ; Credits to HoneCtrl
for /f "tokens=2 delims==" %%i in ('wmic os get TotalVisibleMemorySize /value') do set /a mem=%%i + 1024000
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d %mem% /f > nul 2> nul

:: BCDedit Tweaks 
bcdedit /set x2apicpolicy Enable > nul 2> nul
bcdedit /set uselegacyapicmode No > nul 2> nul
bcdedit /set configaccesspolicy Default > nul 2> nul
bcdedit /set MSI Default > nul 2> nul
bcdedit /set nx OptIn > nul 2> nul
bcdedit /set quietboot Yes > nul 2> nul
bcdedit /set bootmenupolicy Standard > nul 2> nul
bcdedit /set recoveryenabled No > nul 2> nul
bcdedit /set allowedinmemorysettings 0x17000077 > nul 2> nul
bcdedit /set isolatedcontext Yes > nul 2> nul
bcdedit /set usephysicaldestination No > nul 2> nul
bcdedit /set usefirmwarepcisettings No > nul 2> nul
bcdedit /deletevalue useplatformclock > nul 2> nul
bcdedit /set useplatformtick Yes > nul 2> nul
bcdedit /set disabledynamictick Yes > nul 2> nul
bcdedit /set tpmbootentropy ForceDisable > nul 2> nul
bcdedit /set description gyrOS > nul 2> nul

fsutil repair set C: 0 > nul 2> nul

::bcdedit /set hypervisorlaunchtype Off > nul 2> nul
:: Disable DEP
::bcdedit /set nx AlwaysOff > nul 2> nul

:: Lower Latency
bcdedit /set tscsyncpolicy legacy > nul 2> nul
:: Better FPS
::bcdedit /set tscsyncpolicy enhanced > nul 2> nul

:: Disable Nagle's Algorithm
reg add "HKLM\Software\Microsoft\MSMQ\Parameters" /v "TCPNoDelay" /t REG_DWORD /d "1" /f > nul 2> nul
for /f %%s in ('reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\NetworkCards" /f "ServiceName" /s') do set "str=%%i" & if "!str:ServiceName_=!" neq "!str!" (
	reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TCPNoDelay" /t REG_DWORD /d "1" /f
	reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f
	reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpInitialRTT" /d "2" /t REG_DWORD /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "DeadGWDetectDefault" /d "1" /t REG_DWORD /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "UseZeroBroadcast" /d "0" /t REG_DWORD /f
) > nul 2> nul

for /f %%r in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /f "1" /d /s^|Findstr HKEY_') do (
	reg add %%r /v "NonBestEffortLimit" /t REG_DWORD /d "0" /f
	reg add %%r /v "DeadGWDetectDefault" /t REG_DWORD /d "1" /f
	reg add %%r /v "PerformRouterDiscovery" /t REG_DWORD /d "1" /f
	reg add %%r /v "TCPNoDelay" /t REG_DWORD /d "1" /f
	reg add %%r /v "TcpAckFrequency" /t REG_DWORD /d "1" /f
	reg add %%r /v "TcpInitialRTT" /t REG_DWORD /d "2" /f
	reg add %%r /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f
	reg add %%r /v "MTU" /t REG_DWORD /d "1500" /f
	reg add %%r /v "UseZeroBroadcast" /t REG_DWORD /d "0" /f
) > nul 2> nul

:: Disable JUMBOPACKET
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
    for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i" /v "Driver"') do (
        for /f %%i in ('echo %%a ^| findstr "{"') do (
			for %%a in (JumboPacket) do for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /s /f "*%%a" ^| findstr "HKEY"') do reg add "%%b" /v "*%%a" /t REG_SZ /d "1514" /f
		) > nul 2> nul
    )
)

:: Set Win32PrioritySeparation
reg add "HKLM\System\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f > nul 2> nul

:: Set CSRSS to be a High Priority Process
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f > nul 2> nul

:: Hung Apps, Wait to Kill, Mouse ; Credits to DuckOS
reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f > nul 2> nul
reg add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f > nul 2> nul
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Desktop" /v "ForegroundLockTimeout" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Desktop" /v "MouseWheelRouting" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKCU\Control Panel\Desktop" /v "LowLevelHooksTimeout" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PnP" /v "PollBootPartitionTimeout" /t REG_DWORD /d "1" /f > nul 2> nul
%currentuser% reg add "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "0" /f > nul 2> nul

:: Disallow Background Apps ; Credits to EchoX
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Disk Quota 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DiskQuota" /v "Enforce" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DiskQuota" /v "Enable" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DiskQuota" /v "LogEventOverLimit" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DiskQuota" /v "LogEventOverThreshold" /t REG_DWORD /d "0" /f > nul 2> nul


:: NIC Optimizations ; Credits to HoneCtrl 
:NIC
cls
echo __________________________________
echo.
echo  SYSTEM PURIFICATION - PHASE 4...
echo __________________________________
echo.
echo.

set /p M="Are you planning to use an Ethernet or Wi-Fi connection?   1. for Ethernet or 2. for Wi-Fi: " 
if %M%==1 goto ApplyNIC
if %M%==2 goto WiFi
goto NIC

:ApplyNIC
cls
echo __________________________________
echo.
echo  SYSTEM PURIFICATION - PHASE 4...
echo __________________________________
echo.

netsh interface tcp set supplemental Internet congestionprovider=ctcp > nul 2> nul
netsh interface tcp set supplemental InternetCustom congestionprovider=ctcp > nul 2> nul

for /f "tokens=*" %%f in ('wmic cpu get NumberOfCores /value ^| find "="') do set %%f
for /f "tokens=3*" %%a in ('reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\NetworkCards" /k /v /f "Description" /s /e ^| findstr /ri "REG_SZ"') do (
	for /f %%g in ('reg query "HKLM\System\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /s /f "%%b" /d ^| findstr /C:"HKEY"') do (
		reg add "%%g" /v "MIMOPowerSaveMode" /t REG_SZ /d "3" /f
		reg add "%%g" /v "PowerSavingMode" /t REG_SZ /d "0" /f
		reg add "%%g" /v "EnableGreenEthernet" /t REG_SZ /d "0" /f
		reg add "%%g" /v "*EEE" /t REG_SZ /d "0" /f
		reg add "%%g" /v "MIMOPowerSaveMode" /t REG_SZ /d "3" /f
		reg add "%%g" /v "PowerSavingMode" /t REG_SZ /d "0" /f
		reg add "%%g" /v "EnableGreenEthernet" /t REG_SZ /d "0" /f
		reg add "%%g" /v "*EEE" /t REG_SZ /d "0" /f
		reg add "%%g" /v "EnableConnectedPowerGating" /t REG_DWORD /d "0" /f
		reg add "%%g" /v "EnableDynamicPowerGating" /t REG_SZ /d "0" /f
		reg add "%%g" /v "EnableSavePowerNow" /t REG_SZ /d "0" /f
		reg add "%%g" /v "PnPCapabilities" /t REG_SZ /d "24" /f
		reg add "%%g" /v "*NicAutoPowerSaver" /t REG_SZ /d "0" /f
		reg add "%%g" /v "ULPMode" /t REG_SZ /d "0" /f
		reg add "%%g" /v "EnablePME" /t REG_SZ /d "0" /f
		reg add "%%g" /v "AlternateSemaphoreDelay" /t REG_SZ /d "0" /f
		reg add "%%g" /v "AutoPowerSaveModeEnabled" /t REG_SZ /d "0" /f
	) > nul 2> nul
)

reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxConnectRetransmissions" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d "32" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DelayedAckFrequency" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DelayedAckTicks" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "CongestionAlgorithm" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MultihopSets" /t REG_DWORD /d "15" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "IRPStackSize" /t REG_DWORD /d "50" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "SizReqBuf" /t REG_DWORD /d "17424" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "Size" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeSOACacheTime" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableAutoDoh" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrDisableNagleentControlSet\Services\AFD\Parameters" /v "DoNotHoldNicBuffers" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DisableRawSecurity" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "NonBlockingSendSpecialBuffering" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "IgnorePushBitOnReceives" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DynamicSendBufferDisable" /t REG_DWORD /d "0" /f > nul 2> nul

for /f "tokens=3*" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards" /f "ServiceName" /s ^|findstr /i /l "ServiceName"') do (
	reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TCPNoDelay" /t Reg_DWORD /d "1" /f
	reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpAckFrequency" /t Reg_DWORD /d "1" /f
	reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpDelAckTicks" /t Reg_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpInitialRTT" /d "300" /t REG_DWORD /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "UseZeroBroadcast" /d "0" /t REG_DWORD /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "DeadGWDetectDefault" /d "1" /t REG_DWORD /f
) > nul 2> nul

PowerShell Enable-NetAdapterQos -Name "*";^ > nul 2> nul
PowerShell Disable-NetAdapterPowerManagement -Name "*";^ > nul 2> nul
PowerShell Disable-NetAdapterIPsecOffload -Name "*";^ > nul 2> nul
PowerShell Set-NetTCPSetting -SettingName "*" -MemoryPressureProtection Disabled -InitialCongestionWindow 10 -ErrorAction SilentlyContinue > nul 2> nul

goto Continue

:: Wi-Fi Optimizations 
:WiFi
cls
echo __________________________________
echo.
echo  SYSTEM PURIFICATION - PHASE 4...
echo __________________________________
echo.

reg add "HKLM\SOFTWARE\Microsoft\DataCollection\Default\WifiAutoConnectConfig" /v "AutoConnectEnabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v "Value" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v "AutoConnectAllowedOEM" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager" /v "WiFiSenseCredShared" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager" /v "WiFiSenseOpen" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Windows\WcmSvc\GroupPolicy" /v "fSoftDisconnectConnections" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Windows\WcmSvc\GroupPolicy" /v "fMinimizeConnections" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Policies\Microsoft\Windows\WCN\UI" /v "DisableWcnUi" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HotspotAuthentication" /v "Enabled" /t REG_DWORD /d "1" /f > nul 2> nul

netsh interface tcp set supplemental Internet congestionprovider=newreno > nul 2> nul
netsh interface tcp set supplemental InternetCustom congestionprovider=newreno > nul 2> nul

:Continue
cls
echo __________________________________
echo.
echo  SYSTEM PURIFICATION - PHASE 4...
echo __________________________________
echo.

:: Disable Power Throttling  ; Credits to HoneCtrl
::reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /f > nul 2> nul

:: Enable Power Throttling If Laptop  ; Credits to HoneCtrl
::for /f "tokens=2 delims={}" %%n in ('wmic path Win32_SystemEnclosure get ChassisTypes /value') do set /a ChassisTypes=%%n
::if defined ChassisTypes if %ChassisTypes% GEQ 8 if %ChassisTypes% LSS 12 (
	::reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f
	::reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /f
::) > nul 2> nul

:: Disable Task Offload  ; Credits to HoneCtrl
netsh interface ip set global taskoffload=disabled > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t REG_DWORD /d "1" /f > nul 2> nul

:: Remove IRQ Priorities
for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /f "irq"^| findstr "IRQ"') do reg delete "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "%%i" /f > nul 2> nul

:: Set Services that use Cycles to Low Priority ; Credits to ArtanisInc
copy /y "%windir%\System32\svchost.exe" "%windir%\System32\audiosvchost.exe" > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" /v "ImagePath" /t REG_EXPAND_SZ /d "%windir%\System32\audiosvchost.exe -k LocalServiceNetworkRestricted -p" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AudioEndpointBuilder" /v "ImagePath" /t REG_EXPAND_SZ /d "%windir%\System32\audiosvchost.exe -k LocalSystemNetworkRestricted -p" /f > nul 2> nul

for /f "tokens=*" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"') do reg delete "%%i" /f > nul 2> nul
for %%i in (fontdrvhost lsass svchost spoolsv sppsvc WmiPrvSE) do (
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f
) > nul 2> nul

:: Remove Maintenance Tasks
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "WakeUp" /t REG_DWORD /d "0" /f > nul 2> nul

:: Better Cache Management
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "CacheHashTableBucketSize" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "CacheHashTableSize" /t REG_DWORD /d "180" /f > nul 2> nul

:: Enable Large System Cache
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable Administrative Shares
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareServer" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareWks" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters" /v "RestrictNullSessAccess" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "LocalAccountTokenFilterPolicy" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable BitLocker***
reg add "HKLM\SYSTEM\CurrentControlSet\Services\fvevol" /v "ErrorControl" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\fvevol" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BDESVC" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul

:: Disabling Random Drivers Verification
bcdedit /set nointegritychecks On > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "DontVerifyRandomDrivers" /t REG_DWORD /d "1" /f > nul 2> nul

:: Thread Priority Tweaks
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdkmdap\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBXHCI\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\services\mouhid\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdhid\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f > nul 2> nul

:: Network Priorities ; Credits to DuckOS
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d "5" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d "6" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d "7" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "Class" /t REG_DWORD /d "8" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUBDetect" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableICMPRedirect" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableDynamicDiscovery" /t REG_DWORD /d "1" /f > nul 2> nul

:: MMCSS Tweaks
::reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysOn" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "10" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PerfCalculateActualUtilization" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepReliabilityDetailedDiagnostics" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "QosManagesIdleProcessors" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableVsyncLatencyUpdate" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableSensorWatchdog" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLevel" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDebugMode" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v "DefaultPnPCapabilities" /t REG_DWORD /d "24" /f > nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\MMCSS" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul

::::::::::::::::::::::::::::::::::::::: MSI Mode ::::::::::::::::::::::::::::::::::::::::::::::::::

:: Enable MSI Mode for GPU ; Credits to EchoX
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" (
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f
	reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
	if %errorlevel% == 0 (
		reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
		%currentuser% reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MessageNumberLimit" /f
	)
) > nul 2> nul

:: Enable MSI Mode on SATA Controllers ; Credits to EchoX
for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" (
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
) > nul 2> nul

:: Enable MSI Mode on NET ; Credits to EchoX
for /f %%i in ('wmic path win32_NetworkAdapter get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" (
for /f "delims=" %%# in ('"wmic computersystem get manufacturer /format:value"') do set "%%#" >nul & if "!Manufacturer:VMWare=!" neq "!Manufacturer!" (set "VMWare= /t REG_DWORD /d 2") else (set "VMWare=")
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority"%VMWare% /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "3" /f
) > nul 2> nul

:: Enable MSI Mode on USB ; Credits to EchoX
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" (
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
) > nul 2> nul

:: Enable MSI Mode for PCI Devices 
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID^| findstr /l "PCI\VEN_"') do reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f > nul 2> nul
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /l "PCI\VEN_"') do reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f > nul 2> nul
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /l "PCI\VEN_"') do reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f > nul 2> nul

:: Enable MSI Mode 
for /f %%i in ('wmic path win32_VideoController get PNPDeviceID ^| findstr /L "VEN_"') do reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f > nul 2> nul
for /f %%i in ('wmic path win32_VideoController get PNPDeviceID ^| findstr /L "VEN_"') do reg delete "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f > nul 2> nul
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID ^| findstr /L "VEN_"') do reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f > nul 2> nul
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID ^| findstr /L "VEN_"') do reg delete "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f > nul 2> nul


::::::::::::::::::::::::::::::::::::::: Power Saving ::::::::::::::::::::::::::::::::::::::::::::::::::

:: Disable Power Saving on "Plug and Play" Devices ; Credits to DuckOS
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
	for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i" /v "Driver"') do (
		for /f %%i in ('echo %%a ^| findstr "{"') do (
			reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "PnPCapabilities" /t REG_DWORD /d "24" /f
		) > nul 2> nul
	)
)

:: Disable Power Saving on Drives ; Credits to HoneCtrl
for %%i in (EnableHIPM EnableDIPM EnableHDDParking) do for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "%%i" ^| findstr "HKEY"') do reg add "%%a" /v "%%i" /t REG_DWORD /d "0" /f > nul 2> nul

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Storage" /v "StorageD3InModernStandby" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device" /v "IdlePowerMode" /t REG_DWORD /d "0" /f > nul 2> nul

for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "StorPort" ^| findstr "StorPort"') do reg add "%%i" /v "EnableIdlePowerManagement" /t REG_DWORD /d "0" /f > nul 2> nul
for /f "tokens=*" %%i in ('wmic PATH Win32_PnPEntity GET DeviceID ^| findstr "USB\VID_"') do (
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "AllowIdleIrpInD3" /t REG_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnableSelectiveSuspend" /t REG_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "DeviceSelectiveSuspended" /t REG_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "D3ColdSupported" /t REG_DWORD /d "0" /f
) > nul 2> nul

PowerShell -NoProfile -Command "$devices = Get-WmiObject Win32_PnPEntity; $powerMgmt = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi; foreach ($p in $powerMgmt){$IN = $p.InstanceName.ToUpper(); foreach ($h in $devices){$PNPDI = $h.PNPDeviceID; if ($IN -like \"*$PNPDI*\"){$p.enable = $False; $p.psbase.put()}}}" > nul 2> nul

:: Disable USB Power Saving 
for %%i in (EnhancedPowerManagementEnabled AllowIdleIrpInD3 EnableSelectiveSuspend DeviceSelectiveSuspended
SelectiveSuspendEnabled SelectiveSuspendOn EnumerationRetryCount ExtPropDescSemaphore WaitWakeEnabled
D3ColdSupported WdfDirectedPowerTransitionEnable EnableIdlePowerManagement IdleInWorkingState) do for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "%%i"^| findstr "HKEY"') do reg add "%%a" /v "%%i" /t REG_DWORD /d "0" /f > nul 2> nul

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Affinity ; Credits to HoneCtrl
for /f "tokens=*" %%f in ('wmic cpu get NumberOfCores /value ^| find "="') do set %%f
for /f "tokens=*" %%f in ('wmic cpu get NumberOfLogicalProcessors /value ^| find "="') do set %%f
if "!NumberOfCores!" == "2" (
	goto HyperThreading
)
if !NumberOfCores! gtr 4 (
	for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
		reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "3" /f
		reg delete "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /f
	) > nul 2> nul
	for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
		reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "5" /f
		reg delete "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /f
	) > nul 2> nul
)

:: Hyper Threading ; Credits to HoneCtrl
:HyperThreading
if !NumberOfLogicalProcessors! gtr !NumberOfCores! (
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "4" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /t REG_BINARY /d "C0" /f
	) > nul 2> nul
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "4" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /t REG_BINARY /d "C0" /f
	) > nul 2> nul
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "4" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /t REG_BINARY /d "30" /f
	) > nul 2> nul
)

:: Monitor Latency Tolerance
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorLatencyTolerance" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "0" /f > nul 2> nul

:: GPU Optimizations
:: DXKrnl
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v DpiMapIommuContiguous /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "CreateGdiPrimaryOnSlaveGPU" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DriverSupportsCddDwmInterop" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCddSyncDxAccess" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCddSyncGPUAccess" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCddWaitForVerticalBlankEvent" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCreateSwapChain" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkFreeGpuVirtualAddress" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkOpenSwapChain" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkShareSwapChainObject" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkWaitForVerticalBlankEvent" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkWaitForVerticalBlankEvent2" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "SwapChainBackBuffer" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "TdrResetFromTimeoutAsync" /t REG_DWORD /d "1" /f > nul 2> nul
:: Disable Preemption
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d "0" /f > nul 2> nul
:: Enable Hardware Accelerated Scheduling ; Credits to HoneCtrl
reg query "HKLM\System\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" > nul 2> nul
if %errorlevel% == 0 (
	reg add "HKLM\System\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d "2" /f
) > nul 2> nul
:: Force Contiguous Memory Allocation in the DirectX Kernel
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f > nul 2> nul

:: CPU Optimizations 
reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4D36E968-E325-11CE-BFC1-08002BE10318}\0000" /v "AllowDeepCStates" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism" /v "DistanceThresholdInDIPS" /t REG_DWORD /d "00000028" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism" /v "MagnetismDelayInMilliseconds" /t REG_DWORD /d "00000032" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism" /v "MagnetismUpdateIntervalInMilliseconds" /t REG_DWORD /d "00000010" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism" /v "AttractionRectInsetInDIPS" /t REG_DWORD /d "00000005" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "IRRemoteNavigationDelta" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "CursorSensitivity" /t REG_DWORD /d "00002710" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism" /v "VelocityInDIPSPerSecond" /t REG_DWORD /d "00000168" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "CursorUpdateInterval" /t REG_DWORD /d "1" /f > nul 2> nul

:: TCP/IP Optimizations 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation" /v "AllowOfflineFilesforCAShares" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\NetworkProvider" /v "RestoreConnection" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\NetworkProvider" /v "WakeUp" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print\Monitors\Standard TCP/IP Port\Ports" /v "LprAckTimeout" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print\Monitors\Standard TCP/IP Port\Ports" /v "StatusUpdateEnabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print\Monitors\Standard TCP/IP Port\Ports" /v "StatusUpdateInterval" /t REG_DWORD /d "0x0000000a" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPCongestionControl" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableConnectionRateLimiting" /t REG_DWORD /d "0" /f > nul 2> nul
:: I/O Offload
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\I/O System" /v "IoEnableSessionZeroAccessCheck" /t REG_DWORD /d "1" /f > nul 2> nul
:: Disable Cached Windows Logons
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "CachedLogonsCount" /t REG_DWORD /d "0" /f > nul 2> nul
:: DNS
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v "DisableSmartNameResolution" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v "EnableIdnMapping" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v "RegistrationEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v "PreferLocalOverLowerBindingDNS" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v "DisableSmartProtocolReordering" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "DisableParallelAandAAAA" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaxCacheTtl" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaxNegativeCacheTtl" /t REG_DWORD /d "1" /f > nul 2> nul
:: Branch Cache
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp" /v "DisableBranchCache" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "DisableBandwidthThrottling" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "DisableLargeMtu" /t REG_DWORD /d "0" /f > nul 2> nul
:: RasMan
reg add "HKLM\SYSTEM\CurrentControlSet\Services\RasMan\PPP" /v "RestartTimer" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\RasMan\PPP" /v "ForceEncryptedData" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\RasMan\PPP" /v "ForceEncryptedPassword" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\RasMan\PPP" /v "SecureVPN" /t REG_DWORD /d "1" /f > nul 2> nul
:: BITS
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\BITS" /v "EnablePeercaching" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\BITS" /v "DisableBranchCache" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\BITS" /v "DisablePeerCachingClient" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\BITS" /v "DisablePeerCachingServer" /t REG_DWORD /d "1" /f > nul 2> nul
:: Peernet
reg add "HKLM\SOFTWARE\policies\Microsoft\Peernet" /v "Disabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\policies\Microsoft\Peernet\Pnrp\IPv6-Global" /v "Disabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\policies\Microsoft\Peernet\Pnrp\IPv6-Global" /v "DisableMulticastBootstrap" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\policies\Microsoft\Peernet\Pnrp\IPv6-Local" /v "Disabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\policies\Microsoft\Peernet\Pnrp\IPv6-Local" /v "DisableMulticastBootstrap" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\policies\Microsoft\Peernet\Pnrp\IPv6-SiteLocal" /v "Disabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\policies\Microsoft\Peernet\Pnrp\IPv6-SiteLocal" /v "DisableMulticastBootstrap" /t REG_DWORD /d "1" /f > nul 2> nul
:: QoS
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "MaxOutstandingSends" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched\DiffservByteMappingConforming" /v "ServiceTypeGuaranteed" /t REG_DWORD /d "46" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched\DiffservByteMappingConforming" /v "ServiceTypeNetworkControl" /t REG_DWORD /d "56" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched\DiffservByteMappingNonConforming" /v "ServiceTypeGuaranteed" /t REG_DWORD /d "46" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched\DiffservByteMappingNonConforming" /v "ServiceTypeNetworkControl" /t REG_DWORD /d "56" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched\UserPriorityMapping" /v "ServiceTypeGuaranteed" /t REG_DWORD /d "5" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched\UserPriorityMapping" /v "ServiceTypeNetworkControl" /t REG_DWORD /d "7" /f > nul 2> nul
:: MSMQ
reg add "HKLM\SOFTWARE\Microsoft\MSMQ\Parameters" /v "TCPNoDelay" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\MSMQ\Parameters\Security" /v "SecureDSCommunication" /t REG_DWORD /d "0" /f > nul 2> nul
:: WinHTTP Tracking
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp\Tracing" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
:: Enable RSS
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
    for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i" /v "Driver"') do (
        for /f %%i in ('echo %%a ^| findstr "{"') do (
			for %%a in (RSS) do for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /s /f "*%%a" ^| findstr "HKEY"') do reg add "%%b" /v "*%%a" /t REG_SZ /d "1" /f > nul 2> nul
		)
    )
)
reg add "HKLM\SYSTEM\CurrentControlSet\services\NDIS\Parameters" /v "RssBaseCpu" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\services\NDIS\Parameters" /v "MaxNumRssCpus" /t REG_DWORD /d "4" /f > nul 2> nul

:: Network Optimizations ; Credits to Melody and DuckOS 
PowerShell "Disable-NetAdapterChecksumOffload -Name *" > nul 2> nul
PowerShell "Enable-NetAdapterRss -Name *" > nul 2> nul
PowerShell "Disable-NetAdapterLso -Name *" > nul 2> nul
PowerShell "Set-NetOffloadGlobalSetting -PacketCoalescingFilter disabled" > nul 2> nul

for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /v "*SpeedDuplex" /s ^| findstr  "HKEY"') do (
    for /f %%i in ('reg query "%%a" /v "*ReceiveBuffers" ^| findstr "HKEY"') do ( reg add "%%i" /v "*ReceiveBuffers" /t REG_SZ /d "1024" /f )
    for /f %%i in ('reg query "%%a" /v "*TransmitBuffers" ^| findstr "HKEY"') do ( reg add "%%i" /v "*TransmitBuffers" /t REG_SZ /d "1024" /f )
    for /f %%i in ('reg query "%%a" /v "*DeviceSleepOnDisconnect" ^| findstr "HKEY"') do (  reg add "%%i" /v "*DeviceSleepOnDisconnect" /t REG_SZ /d "0" /f )
    for /f %%i in ('reg query "%%a" /v "*EEE" ^| findstr "HKEY"') do (  reg add "%%i" /v "*EEE" /t REG_SZ /d "0" /f )
    for /f %%i in ('reg query "%%a" /v "*ModernStandbyWoLMagicPacket" ^| findstr "HKEY"') do ( reg add "%%i" /v "*ModernStandbyWoLMagicPacket" /t REG_SZ /d "0" /f )
    for /f %%i in ('reg query "%%a" /v "*SelectiveSuspend" ^| findstr "HKEY"') do ( reg add "%%i" /v "*SelectiveSuspend" /t REG_SZ /d "0" /f )
    for /f %%i in ('reg query "%%a" /v "*WakeOnMagicPacket" ^| findstr "HKEY"') do ( reg add "%%i" /v "*WakeOnMagicPacket" /t REG_SZ /d "0" /f )
    for /f %%i in ('reg query "%%a" /v "*WakeOnPattern" ^| findstr "HKEY"') do ( reg add "%%i" /v "*WakeOnPattern" /t REG_SZ /d "0" /f )
    for /f %%i in ('reg query "%%a" /v "AutoPowerSaveModeEnabled" ^| findstr "HKEY"') do ( reg add "%%i" /v "AutoPowerSaveModeEnabled" /t REG_SZ /d "0" /f )
    for /f %%i in ('reg query "%%a" /v "EEELinkAdvertisement" ^| findstr "HKEY"') do ( reg add "%%i" /v "EEELinkAdvertisement" /t REG_SZ /d "0" /f )
    for /f %%i in ('reg query "%%a" /v "EeePhyEnable" ^| findstr "HKEY"') do ( reg add "%%i" /v "EeePhyEnable" /t REG_SZ /d "0" /f  )
    for /f %%i in ('reg query "%%a" /v "EnableGreenEthernet" ^| findstr "HKEY"') do ( reg add "%%i" /v "EnableGreenEthernet" /t REG_SZ /d "0" /f )
    for /f %%i in ('reg query "%%a" /v "EnableModernStandby" ^| findstr "HKEY"') do ( reg add "%%i" /v "EnableModernStandby" /t REG_SZ /d "0" /f )
    for /f %%i in ('reg query "%%a" /v "GigaLite" ^| findstr "HKEY"') do ( reg add "%%i" /v "GigaLite" /t REG_SZ /d "0" /f  )
    for /f %%i in ('reg query "%%a" /v "PowerDownPll" ^| findstr "HKEY"') do ( reg add "%%i" /v "PowerDownPll" /t REG_SZ /d "0" /f  )
    for /f %%i in ('reg query "%%a" /v "PowerSavingMode" ^| findstr "HKEY"') do ( reg add "%%i" /v "PowerSavingMode" /t REG_SZ /d "0" /f  )
    for /f %%i in ('reg query "%%a" /v "ReduceSpeedOnPowerDown" ^| findstr "HKEY"') do ( reg add "%%i" /v "ReduceSpeedOnPowerDown" /t REG_SZ /d "0" /f )
    for /f %%i in ('reg query "%%a" /v "S5WakeOnLan" ^| findstr "HKEY"') do ( reg add "%%i" /v "S5WakeOnLan" /t REG_SZ /d "0" /f  )
    for /f %%i in ('reg query "%%a" /v "SavePowerNowEnabled" ^| findstr "HKEY"') do ( reg add "%%i" /v "SavePowerNowEnabled" /t REG_SZ /d "0" /f )
    for /f %%i in ('reg query "%%a" /v "ULPMode" ^| findstr "HKEY"') do ( reg add "%%i" /v "ULPMode" /t REG_SZ /d "0" /f )
    for /f %%i in ('reg query "%%a" /v "WakeOnLink" ^| findstr "HKEY"') do ( reg add "%%i" /v "WakeOnLink" /t REG_SZ /d "0" /f )
    for /f %%i in ('reg query "%%a" /v "WakeOnSlot" ^| findstr "HKEY"') do ( reg add "%%i" /v "WakeOnSlot" /t REG_SZ /d "0" /f )
    for /f %%i in ('reg query "%%a" /v "WakeUpModeCap" ^| findstr "HKEY"') do ( reg add "%%i" /v "WakeUpModeCap" /t REG_SZ /d "0" /f )
    for /f %%i in ('reg query "%%a" /v "WakeUpModeCap" ^| findstr "HKEY"') do ( reg add "%%i" /v "PnPCapabilities" /t REG_SZ /d "24" /f )
) > nul 2> nul

:: File System Optimizations 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "FilterSupportedFeaturesMode" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsAllowExtendedCharacter8dot3Rename" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsBugcheckOnCorrupt" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDefaultTier" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisableVolsnapHints" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsForceNonPagedPoolAllocation" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsMemoryUsage" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsParallelFlushThreshold" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsParallelFlushWorkers" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "SymlinkLocalToLocalEvaluation" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "SymlinkLocalToRemoteEvaluation" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "SymlinkRemoteToLocalEvaluation" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "SymlinkRemoteToRemoteEvaluation" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "UdfsCloseSessionOnEject" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "UdfsSoftwareDefectManagement" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "Win31FileSystem" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "DisableDeleteNotification" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "Win95TruncatedExtensions" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisableSpotCorruptionHandling" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsMftZoneReservation" /t REG_DWORD /d "2" /f > nul 2> nul

:: Disable NTFS Compression
reg add "HKLM\SYSTEM\CurrentControlSet\Policies" /v "NtfsDisableCompression" /t REG_DWORD /d "1" /f > nul 2> nul

:: Storage Optimizations ; Credits to ArtanisInc***
for /f "skip=1" %%i in ('wmic os get TotalVisibleMemorySize') do if not defined TOTAL_MEMORY set "TOTAL_MEMORY=%%i"
if !TOTAL_MEMORY! LSS 8000000 (
	fsutil behavior set memoryusage 1
	fsutil behavior set mftzone 1
) > nul 2>nul else if !TOTAL_MEMORY! LSS 16000000 (
	fsutil behavior set memoryusage 1
	fsutil behavior set mftzone 2
) > nul 2>nul else (
	fsutil behavior set memoryusage 2
	fsutil behavior set mftzone 2
) > nul 2>nul
fsutil behavior set Bugcheckoncorrupt 0 > nul 2> nul
fsutil behavior set disable8dot3 1 > nul 2> nul
fsutil behavior set disablecompression 1 > nul 2> nul
fsutil behavior set encryptpagingfile 0 > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "ShippedWithReserves" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "PassedPolicy" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "MiscPolicyInfo" /t REG_DWORD /d "2" /f > nul 2> nul

:StorageOptimizations
cls
echo __________________________________
echo.
echo  SYSTEM PURIFICATION - PHASE 4...
echo __________________________________
echo.
echo.
set /p M="What type of storage disk is Windows installed on?   1. for SSD/NVMe or 2. for HDD: " 
if %M%==1 goto SSD
if %M%==2 goto HDD
goto StorageOptimizations

:HDD
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NTFSDisableLastAccessUpdate" /t REG_DWORD /d "1" /f > nul 2> nul
fsutil behavior set disablelastaccess 1 > nul 2> nul
goto SkipSSDOptimizations

:SSD
cls
echo __________________________________
echo.
echo  SYSTEM PURIFICATION - PHASE 4...
echo __________________________________
echo.

fsutil behavior set disablelastaccess 0 > nul 2> nul
fsutil behavior set disabledeletenotify 0 > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableBoottrace" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" /v "Enable" /t REG_SZ /d "N" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OptimalLayout" /v "EnableAutoLayout" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\rdyboost" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\System\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ  /d "" /f > nul 2> nul
PowerShell "Optimize-Volume -DriveLetter C -ReTrim"

:SkipSSDOptimizations
cls
echo __________________________________
echo.
echo  SYSTEM PURIFICATION - PHASE 4...
echo __________________________________
echo.

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\currentcontrolset\control\session manager\Memory Management" /v "DisablePagingCombining" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePageCombining" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "HeapDeCommitFreeBlockThreshold" /t REG_DWORD /d "262144" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NTFSDisable8dot3NameCreation" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "AlwaysUnloadDLL" /t REG_DWORD /d "1" /f > nul 2> nul
PowerShell "Disable-MMAgent -MemoryCompression" > nul 2> nul
PowerShell -NoProfile -Command "Disable-MMAgent -PagingCombining -mc" > nul 2> nul

:: Security Optimizations 
PowerShell "Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol" > nul 2> nul
PowerShell "Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol-Client" > nul 2> nul
PowerShell "Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol-Server" > nul 2> nul
PowerShell "Set-SmbClientConfiguration -RequireSecuritySignature $True -Force" > nul 2> nul
PowerShell "Set-SmbClientConfiguration -EnableSecuritySignature $True -Force" > nul 2> nul
PowerShell "Set-SmbServerConfiguration -EncryptData $True -Force" > nul 2> nul
PowerShell "Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force" > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RunAsPPL" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "EveryoneIncludesAnonymous" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "RestrictAnonymous" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "RestrictAnonymousSAM" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" /v "RestrictReceivingNTLMTraffic" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" /v "RestrictSendingNTLMTraffic" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "SMB1" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\System\CurrentControlSet\Services\LanmanServer\Parameters" /v "SMB2" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters" /v "DisableCompression" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\System\CurrentControlSet\Services\NetBT\Parameters" /v "NodeType" /t REG_DWORD /d "2" /f > nul 2> nul

:: Fixes for bugs caused by code or stripped components
:: Fix Folder View Settings
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSaveSettings" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKLM\software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSaveSettings" /t REG_SZ /d "0" /f > nul 2> nul
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f > nul 2> nul
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f > nul 2> nul
reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\All Folders\Shell" /v "FolderType" /t "REG_SZ" /d "NotSpecified" /f > nul 2> nul
reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell" /v "BagMRU Size" /t "REG_DWORD" /d "2710" /f > nul 2> nul
:: Disable "Do not Connect to Windows Update Internet Locations" / Used to Fixed Microsoft Store
::reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DoNotConnectToWindowsUpdateInternetLocations" /t REG_DWORD /d "0" /f > nul 2> nul

timeout /t 2
cls

:: ============================== ::
::             TASKS              ::
:: ============================== ::

echo ______________________
echo.
echo  CONFIGURING TASKS...
echo ______________________
echo.

:: Disable Tasks***
for %%i in ("UpdateOrchestrator\Reboot" "UpdateOrchestrator\Refresh Settings" "UpdateOrchestrator\USO_UxBroker_Display"
"UpdateOrchestrator\USO_UxBroker_ReadyToReboot" "WindowsUpdate\sih" "WindowsUpdate\sihboot") do schtasks /Change /TN "Microsoft\Windows\%%~i" /disable > nul 2> nul

schtasks /Change /Disable /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /f > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /f > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\PcaPatchDbTask" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Device Information\Device" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Device Information\Device User" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\WaaSMedic\PerformRemediation" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskFootprint\Diagnostics" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\StartupAppTask" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskFootprint\StorageSense" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Registry\RegIdleBackup" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskNetwork"  > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskLogon" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\StateRepository\MaintenanceTasks" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UPnP\UPnPHostConfig" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\RetailDemo\CleanupOfflineContent" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\ScanForUpdates" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\ScanForUpdatesAsUser" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\SmartRetry" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\International\Synchronize Language Settings" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Printing\EduPrintProv" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Ras\MobilityManager" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Zone\SynchronizeTimeZone" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\SynchronizeTime" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskCleanup\SilentCleanup" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Diagnosis\Scheduled" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Wininet\CacheTask" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\NetTrace\GatherNetworkInfo" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\TPM\Tpm-HASCertRetr" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\TPM\Tpm-Maintenance" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Sysmain\ResPriStaticDbSync" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\ApplicationData\appuriverifierdaily" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\ApplicationData\appuriverifierinstall" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\ApplicationData\DsSvcCleanup" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64 Critical" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 Critical" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\XblGameSave\XblGameSaveTask" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\XblGameSave\XblGameSaveTaskLogon" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" > nul 2> nul

timeout /t 2
cls

echo __________________________________
echo.
echo  RESTART REQUIRED, PLEASE WAIT...
echo __________________________________

timeout /t 3
cls

echo __________________________________________________________________________________________
echo.
echo                                   ===== IMPORTANT =====
echo.
echo  MAKE SURE TO CLICK "CLOSE" WHEN THE RESTART WINDOW POPS UP. PRESS ANY KEY TO CONTINUE...
echo __________________________________________________________________________________________
echo.
pause

echo __________________________________________________________________________________________
echo.
echo                                 ===== RESTARTING IN... =====
echo __________________________________________________________________________________________

timeout /t 4
shutdown /r /t 10 /f