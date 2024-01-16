:: ### gyrOS Optimization Script ###

:: ### Credits: EchoX, HoneCtrl, ArtanisInc, Rikey, DuckOS, Melody

@echo off
setlocal EnableDelayedExpansion

set "VERSION=23.5.2"
set "SCRIPT_VERSION_DATE=15/05/2023"
title gyrOS Post Installation Script "!SCRIPT_VERSION_DATE!"

:: Configure Variables
set "currentuser=%WinDir%\gyrOS\MinSudo\MinSudo.exe --trustedinstaller --nologo"
set "PowerShell=%WinDir%\System32\WindowsPowerShell\v1.0\PowerShell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command"

:: Uninstall Microsoft Edge
cd /d "%ProgramFiles(x86)%\Microsoft"
for /f "tokens=1 delims=\" %%i in ('dir /B /A:D "%ProgramFiles(x86)%\Microsoft\Edge\Application" ^| find "."') do (set "edge_chromium_package_version=%%i")
if defined edge_chromium_package_version (
		EdgeWebView\Application\%edge_chromium_package_version%\Installer\setup.exe --uninstall --force-uninstall --msedgewebview --system-level --verbose-logging
		Edge\Application\%edge_chromium_package_version%\Installer\setup.exe --uninstall --force-uninstall --msedge --system-level --verbose-logging
		EdgeCore\%edge_chromium_package_version%\Installer\setup.exe --uninstall --force-uninstall --msedge --system-level --verbose-logging
)
cd /d "%~dp0"
for /f "tokens=8 delims=\" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" ^| findstr "Microsoft-Windows-Internet-Browser-Package" ^| findstr "~~"') do (set "edge_legacy_package_version=%%i")
if defined edge_legacy_package_version (
		reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%edge_legacy_package_version%" /v "Visibility" /t REG_DWORD /d "1" /f > nul 2> nul
		reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\%edge_legacy_package_version%\Owners" /va /f > nul 2> nul
		dism /online /Remove-Package /PackageName:%edge_legacy_package_version%
		powershell.exe -Command "Get-AppxPackage *edge* | Remove-AppxPackage" > nul 2> nul
)
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /f > nul 2> nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge Update" /f > nul 2> nul
reg delete "HKLM\SOFTWARE\Classes\MSEdgeHTM" /f > nul 2> nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Application\edgeupdate" /f > nul 2> nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Application\edgeupdatem" /f  > nul 2> nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Clients\StartMenuInternet\Microsoft Edge" /f > nul 2> nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" /f > nul 2> nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" /f > nul 2> nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate" /f > nul 2> nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Edge" /f > nul 2> nul
reg delete "HKLM\SOFTWARE\Clients\StartMenuInternet\Microsoft Edge" /f > nul 2> nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /f > nul 2> nul
del "%drive%\Users\%username%\Desktop\Microsoft*Edge.lnk" > nul 2> nul
del "%drive%\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" > nul 2> nul
cls

echo _____________________________________________________________________________________________________
echo.
echo  THANK YOU FOR INSTALLING GYROS 1909 %VERSION%. PRESS ANY KEY TO START APPLYING GYROS OPTIMIZATIONS.
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

:: Turn on Automatic Time Update
%WinDir%\System32\SystemSettingsAdminFlows.exe SetInternetTime 1

:: Turn on Automatic Time Zone Update
start "" "%WinDir%\System32\SystemSettingsAdminFlows.exe" SetAutoTimeZoneUpdate 1

:: Force Sync Time
start "" "%WinDir%\System32\SystemSettingsAdminFlows.exe" ForceTimeSync 1

:: Configure Power Plan
powercfg -import "%WinDir%\HoneV2.pow" 77777777-7777-7777-7777-777777777777 > nul 2> nul
powercfg -SETACTIVE "77777777-7777-7777-7777-777777777777" > nul 2> nul
powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c > nul 2> nul
powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a > nul 2> nul
cls

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
echo  INSTALLING VISUAL CPP REDISTRIBUTABLES 1/3
echo ____________________________________________
echo.
"%WinDir%\gyrOS\VCRedist_AIO.exe" /ai
cls

echo ________________________
echo.
echo  INSTALLING DIRECTX 2/3
echo ________________________
echo.
ping 8.8.8.8 -n 1 -w 1000 > nul 2> nul
if %errorlevel% == 0 (
:DirectX
start /wait "" "%WinDir%\gyrOS\DirectX.exe" /q
cls
) else (
echo No internet connection detected. Skipping DirectX installation.
echo.
echo Install DirectX manually using GToolbox.
timeout /t 3 >nul
)

:OpenShell
echo ___________________________
echo.
echo  INSTALLING OPEN-SHELL 3/3
echo ___________________________
echo.
"%drive%\ProgramData\Installers\OpenShellSetup.exe" /qn
timeout /t 2 >nul
reg add "HKCU\SOFTWARE\OpenShell" /t REG_SZ "" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\OpenShell" /t REG_SZ "" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\OpenShell\Settings" /t REG_SZ "" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\ClassicExplorer" /t REG_SZ "" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\ClassicExplorer" /v "ShowedToolbar" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\ClassicExplorer" /v "NewLine" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\ClassicExplorer\Settings" /t REG_SZ "" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\ClassicExplorer\Settings" /v "ShowStatusBar" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu" /t REG_SZ "" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu" /v "ShowedStyle2" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu" /v "CSettingsDlg" /t REG_BINARY /d "c80100001a0100000000000000000000360d00000100000000000000" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu" /v "OldItems" /t REG_BINARY "" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu" /v "ItemRanks" /t REG_BINARY /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu\Settings" /t REG_SZ "" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu\Settings" /v "Version" /t REG_DWORD /d "04040098" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu\Settings" /v "AllProgramsMetro" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu\Settings" /v "RecentMetroApps" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu\Settings" /v "StartScreenShortcut" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu\Settings" /v "SearchInternet" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu\Settings" /v "GlassOverride" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu\Settings" /v "GlassColor" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu\Settings" /v "SkinW7" /t REG_SZ /d "Midnight" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu\Settings" /v "SkinVariationW7" /t REG_SZ "" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu\Settings" /v "SkinOptionsW7" /t REG_MULTI_SZ /d "USER_IMAGE=1"\0"SMALL_ICONS=0"\0"LARGE_FONT=0"\0"DISABLE_MASK=0"\0"OPAQUE=0"\0"TRANSPARENT_LESS=0"\0"TRANSPARENT_MORE=1"\0"WHITE_SUBMENUS2=0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu\Settings" /v "SkipMetro" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\OpenShell\StartMenu\Settings" /v "MenuItems7" /t REG_MULTI_SZ /d "Item1.Command=user_files"\0"Item1.Settings=NOEXPAND"\0"Item2.Command=user_documents"\0"Item2.Settings=NOEXPAND"\0"Item3.Command=user_pictures"\0"Item3.Settings=NOEXPAND"\0"Item4.Command=user_music"\0"Item4.Settings=NOEXPAND"\0"Item5.Command=user_videos"\0"Item5.Settings=NOEXPAND"\0"Item6.Command=downloads"\0"Item6.Settings=NOEXPAND"\0"Item7.Command=homegroup"\0"Item7.Settings=ITEM_DISABLED"\0"Item8.Command=separator"\0"Item9.Command=games"\0"Item9.Settings=TRACK_RECENT|NOEXPAND|ITEM_DISABLED"\0"Item10.Command=favorites"\0"Item10.Settings=ITEM_DISABLED"\0"Item11.Command=recent_documents"\0"Item12.Command=computer"\0"Item12.Settings=NOEXPAND"\0"Item13.Command=network"\0"Item13.Settings=ITEM_DISABLED"\0"Item14.Command=network_connections"\0"Item14.Settings=ITEM_DISABLED"\0"Item15.Command=separator"\0"Item16.Command=control_panel"\0"Item16.Settings=TRACK_RECENT"\0"Item17.Command=pc_settings"\0"Item17.Settings=TRACK_RECENT"\0"Item18.Command=admin"\0"Item18.Settings=TRACK_RECENT|ITEM_DISABLED"\0"Item19.Command=devices"\0"Item19.Settings=ITEM_DISABLED"\0"Item20.Command=defaults"\0"Item20.Settings=ITEM_DISABLED"\0"Item21.Command=help"\0"Item21.Settings=ITEM_DISABLED"\0"Item22.Command=run"\0"Item23.Command=apps"\0"Item23.Settings=ITEM_DISABLED"\0"Item24.Command=windows_security"\0"Item24.Settings=ITEM_DISABLED" /f > nul 2> nul
taskkill /f /im "explorer.exe" > nul 2> nul
timeout /t 2 /nobreak > nul 2> nul
start "" "explorer.exe" > nul 2> nul
cls

:Chocolatey
::@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
::choco feature enable -n allowGlobalConfirmation

echo ______________________________
echo.
echo  FINISHED INSTALLING SOFTWARE
echo ______________________________
echo.

timeout /t 1 >nul
cls

:: Delete Post Setup Files
del /f /q %WinDir%\HoneV2.pow > nul 2> nul
del /f /q %drive%\ProgramData\Installers\OpenShellSetup.exe > nul 2> nul
del /f /q %WinDir%\gyrOS\VisualCppRedist_AIO.exe > nul 2> nul
del /f /q %WinDir%\gyrOS\DirectX.exe > nul 2> nul

:: Delete Shortcuts
::del /f /q "%drive%\Users\Public\Desktop\gyrOS.lnk" > nul 2> nul

:: ============================== ::
::       WINDOWS SETTINGS         ::
:: ============================== ::

echo ______________________
echo.
echo  ANALYZING BIOMETRICS
echo ______________________
echo.

:: Kill Windows Explorer
taskkill /f /im explorer.exe

:: Services Configuration
reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wcncsvc" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SNMPTRAP" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PcaSvc" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /v "Start" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CDPSvc" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\VaultSvc" /v "Start" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CryptSvc" /v "Start" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DusmSvc" /v "Start" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthAvctpSvc" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DoSvc" /v "Start" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DevQueryBroker" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SstpSvc" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\swprv" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\svsvc" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\VSS" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wmiApSrv" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\FrameServer" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\defragsvc" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NcbService" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\MSDTC" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationService" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DmEnrollmentSvc" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\McpManagementService" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DPS" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
sc config "DPS" start= disabled > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\diagsvc" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdiServiceHost" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
sc config "WdiServiceHost" start= disabled > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdiSystemHost" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
sc config "WdiSystemHost" start= disabled > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\diagnosticshub.standardcollector.service" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wcnfs" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lmhosts" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SSDPSRV" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\StorSvc" /v "Start" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dhcp" /v "Start" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\IKEEXT" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WerSvc" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wercplsupport" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\camsvc" /v "Start" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppMgmt" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppIDSvc" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\iphlpsvc" /v "Start" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wlidsvc" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NgcSvc" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NgcCtnrSvc" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\InstallService" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppXSvc" /v "Start" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\ClipSVC" /v "Start" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PerfHost" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TokenBroker" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WSearch" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul

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
rd "%drive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Open-Shell" /s /q > nul 2> nul
rd "%drive%\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Maintenance" /s /q > nul 2> nul
rd "%drive%\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows Ease of Access" /s /q > nul 2> nul

:: Clean Registry Entries ; Credits to CatGamerOP and ArtanisInc
for %%a in ({E0CBF06C-CD8B-4647-BB8A-263B43F0F974} {C06FF265-AE09-48F0-812C-16753D7CBA83} {4D36E97B-E325-11CE-BFC1-08002BE10318} {A0A588A4-C46F-4B37-B7EA-C82FE89870C6} {7EBEFBC0-3200-11D2-B4C2-00A0C9697D07} {4D36E965-E325-11CE-BFC1-08002BE10318} {53D29EF7-377C-4D14-864B-EB3A85769359} {4658EE7E-F050-11D1-B6BD-00C04FA372A7} {4D36E978-E325-11CE-BFC1-08002BE10318} {4D36E977-E325-11CE-BFC1-08002BE10318} {4D36E979-E325-11CE-BFC1-08002BE10318} {4D36E96D-E325-11CE-BFC1-08002BE10318}) do (
    %currentuser% reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%a" /f
)

:: Disable Windows Defender
bcdedit /set disableelamdrivers Yes > nul 2> nul

:: Delete Windows Defender Entries
for %%i in ("HKLM\SOFTWARE\Microsoft\Windows Defender" "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WindowsDefenderSecurityCenter" "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Defender") do (
	%currentuser% reg delete %%i /f
)

:: Configure Windows Search
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SearchBoxVisibleInTouchImprovement" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsDeviceSearchHistoryEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsDynamicSearchBoxEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsAADCloudSearchEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsMSACloudSearchEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "SafeSearchMode" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "HasAboveLockTips" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "AnyAboveLockAppsActive" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "IsAssignedAccess" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "IsMicrophoneAvailable" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "IsWindowsHelloActive" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "DeviceHistoryEnabled" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Search Indexing
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventIndexOnBattery" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventIndex" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableRemovableDriveIndexing" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\SearchCompanion" /v "DisableContentFileUpdate" /t REG_DWORD /d "1" /f > nul 2> nul

:: Configure System Permissions
:: Contacts
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t REG_SZ /d "Deny" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessContacts" /t REG_DWORD /d "2" /f > nul 2> nul
:: Notifications
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\notifications" /v "Value" /t REG_SZ /d "Deny" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessNotifications" /t REG_DWORD /d "2" /f > nul 2> nul
:: Pictures Library
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v "Value" /t REG_SZ /d "Deny" /f > nul 2> nul
:: Videos Library
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v "Value" /t REG_SZ /d "Deny" /f > nul 2> nul
:: Documents Library
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v "Value" /t REG_SZ /d "Deny" /f > nul 2> nul
:: Diagnostic Information
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsGetDiagnosticInfo" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t "REG_SZ" /d "Deny" /f > nul 2> nul
:: Unpaired Devices
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsSyncWithDevices" /t REG_DWORD /d "2" /f > nul 2> nul
:: Account Information
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessAccountInfo" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f > nul 2> nul

:: System Information
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Manufacturer" /t REG_SZ /d "gyrOS" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Model" /t REG_SZ /d "!VERSION!" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportHours" /t REG_SZ /d "Discord" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportPhone" /t REG_SZ /d "69420" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportURL" /t REG_SZ /d "https://discord.gg/gyros" /f > nul 2> nul

:: Disable Windows Upgrade and Insider Previews
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "DisableOSUpgrade" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\Setup\UpgradeNotification" /v "UpgradeAvailable" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /v "HideInsiderPage" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableExperimentation" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Security Warning "The publisher could not be verified"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Associations" /v "DefaultFileTypeRisk" /t REG_DWORD /d "1808" /f > nul 2> nul

:: Disable Security Warning "Unblock the downloaded file"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable "Open File - Security Warning"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t "REG_DWORD" /d "0" /f > nul 2> nul
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

:: Automatically Check "Do this for all current items"
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoFileFolderOptions" /t REG_DWORD /d "1" /f

:: Disable Retrieving Device Metadata from the Internet
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "DeviceMetadataServiceURL" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable WDigest Credential Revealing
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" /v "UseLogonCredential" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" /v "Negotiate" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Enhance Pointer Precision ; Credits to HoneCtrl
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d "0000000000000000156e000000000000004001000000000029dc0300000000000000280000000000" /f > nul 2> nul
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d "0000000000000000fd11010000000000002404000000000000fc12000000000000c0bb0100000000" /f > nul 2> nul
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f > nul 2> nul

:: Hide PerfLogs Folder
attrib +h "%drive%\perflogs" > nul 2> nul

:: Static Scrollbars
reg add "HKCU\Control Panel\Accessibility" /v "DynamicScrollbars" /t REG_DWORD /d "0" /f > nul 2> nul

:: Configure BSOD ; Credits to HoneCtrl
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "LogEvent" /t REG_DWORD /d "0" /f > nul 2> nul

:: Remove "Bitmap Image" from "New" Context Menu
reg delete "HKCR\.bmp\ShellNew" /f > nul 2> nul

:: Configure Snap Settings
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapAssist" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "JointResize" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapFill" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Feedback
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f

:: Disable Activity History
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d "0" /f > nul 2> nul

:: File Explorer ; Credits to ArtanisInc, Rikey and Melody
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "DesktopProcess" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t  REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisablePreviewDesktop" /t  REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackPics" /t REG_DWORD /d "0" /f > nul 2> nul
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

:: Disable IPv6, Client for Microsoft Networks, QoS Packet Scheduler, File and Printer Sharing ; Credits to DuckOS
%PowerShell% "Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6, ms_rspndr, ms_msclient, ms_pacer, ms_server, ms_lldp, ms_lltdio" > nul 2> nul

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

:: Disable USB Autorun / Autoplay ; Credits to ArtanisInc
reg add "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main" /v "Autorun" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d "1" /f > nul 2> nul
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
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound\.current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\HubOffSound\.current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\HubOnSound\.current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\HubSleepSound\.current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\MisrecoSound\.current" /f > nul 2> nul
reg add "HKCU\AppEvents\Schemes\Apps\sapisvr\PanelSound\.current" /f > nul 2> nul

:: Set Sound Communications to "Do nothing"
reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f > nul 2> nul

:: Disable Startup Sound
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" /v "DisableStartupSound" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable "Notify me if my PC is charging slowly over USB"
reg add "HKCU\SOFTWARE\Microsoft\Shell\USB" /v "NotifyOnWeakCharger" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable "Autocorrect Misspelled Words"
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableAutocorrection" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable "Highlight Misspelled Words"
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableSpellchecking" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable "Add a Space After I Choose a Text Suggestion"
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnablePredictionSpaceInsertion" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnablePrediction" /t REG_DWORD /d "0" /f > nul 2> nul

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

:: Disable "USB Connection Error" Notification
reg add "HKCU\SOFTWARE\Microsoft\Shell\USB" /v "NotifyOnUsbErrors" /t REG_DWORD /d "0" /f > nul 2> nul

:: Remove "Include in Library" Context Menu
reg delete "HKCR\Folder\ShellEx\ContextMenuHandlers\Library Location" /f > nul 2> nul

:: Remove "Share" from Context Menu
reg delete "HKCR\*\shellex\ContextMenuHandlers\ModernSharing" /f > nul 2> nul

:: Remove "Troubleshoot Compatibility" from Context Menu
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f > nul 2> nul

:: Remove "-Shortcut" Text Addition
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates" /v "ShortcutNameTemplate" /t REG_SZ /d "\"%.lnk\"" /f > nul 2> nul

:: Remove "Send To" from Context Menu
reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" /f > nul 2> nul
reg delete "HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\SendTo" /f > nul 2> nul

:: Add "New CMD File" to Context Menu
reg add "HKCR\.cmd\ShellNew" /v "NullFile" /t REG_SZ /d "" /f > nul 2> nul

:: Add "New Batch File" to Context Menu
reg add "HKCR\.bat\ShellNew" /v "NullFile" /t REG_SZ /d "" /f > nul 2> nul

:: Add "Registry Entries" to Context Menu ; Credits to DuckOS
reg add "HKLM\SOFTWARE\Classes\.reg\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@%WinDir%\regedit.exe,-309" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Classes\.reg\ShellNew" /v "NullFile" /t REG_SZ /d "" /f > nul 2> nul

:: Add Option "Merge as TrustedInstaller" ; Credits to DuckOS
reg add "HKCR\regfile\Shell\RunAs" /ve /t REG_SZ /d "Merge as TrustedInstaller" /f > nul 2> nul
reg add "HKCR\regfile\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "1" /f > nul 2> nul
reg add "HKCR\regfile\Shell\RunAs\Command" /ve /t REG_SZ /d "%WinDir%\gyrOS\MinSudo\MinSudo.exe --trustedinstaller --nologo reg import "%1"" /f

:: Add "Install CAB File" to Context Menu
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
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "NoPreviousVersionsPage" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Policies\Microsoft\PreviousVersions" /v "DisableLocalPage" /t REG_DWORD /d "1" /f > nul 2> nul

:: Remove "Look for an Application in the Microsoft Store"
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "0xffffffff" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable Ease of Access Settings
reg add "HKCU\SOFTWARE\Microsoft\Ease of Access" /v "selfvoice" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Ease of Access" /v "selfscan" /t REG_DWORD /d "0" /f > nul 2> nul
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
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000" /f > nul 2> nul
:: Disable Animations in the Taskbar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f > nul 2> nul
:: Disable "Peek"
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f > nul 2> nul
:: Disable "Save Taskbar Thumbnail Previews"
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d "0" /f > nul 2> nul
:: Enable "Show Thumbnails Instead of Icons"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "IconsOnly" /t REG_DWORD /d "0" /f > nul 2> nul
:: Disable "Animate Windows when Minimizing and Maximizing"
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_DWORD /d "0" /f > nul 2> nul
:: Disable "Show Translucent Selection Rectangle"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d "0" /f > nul 2> nul
:: Disable "Use Drop Shadows for Icon Labels on the Desktop"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d "0" /f > nul 2> nul
:: Disable Transparency
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableBlurBehind" /t REG_DWORD /d "0" /f > nul 2> nul
:: Reduce Size of Minimize, Maximize, Close Buttons
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "CaptionWidth" /t REG_SZ /d "-270" /f > nul 2> nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "CaptionHeight" /t REG_SZ /d "-270" /f > nul 2> nul
:: Disable Accent Color
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "ColorPrevalence" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ColorPrevalence" /t REG_DWORD /d "0" /f > nul 2> nul
:: Change Clock and Date Format
reg add "HKCU\Control Panel\International" /v "iMeasure" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\International" /v "iNegCurr" /t REG_SZ /d "1" /f > nul 2> nul
reg add "HKCU\Control Panel\International" /v "iTime" /t REG_SZ /d "1" /f > nul 2> nul
reg add "HKCU\Control Panel\International" /v "sShortDate" /t REG_SZ /d "dd/MM/yyyy" /f > nul 2> nul
reg add "HKCU\Control Panel\International" /v "sShortTime" /t REG_SZ /d "HH:mm" /f > nul 2> nul
reg add "HKCU\Control Panel\International" /v "sTimeFormat" /t REG_SZ /d "H:mm:ss" /f > nul 2> nul
:: Show Seconds in Taskbar Clock
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSecondsInSystemClock" /t REG_DWORD /d "1" /f > nul 2> nul
:: Improve Desktop Wallpaper Quality
reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t "REG_DWORD" /d "100" /f > nul 2> nul
:: Rest of Appearance Optimizations
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ThemeManager" /v "ThemeActive" /t REG_SZ /d "0" /f > nul 2> nul
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes" /v "ThemeChangesMousePointers" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes" /v "ThemeChangesDesktopIcons" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "DesktopHeapLogging" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "DwmInputUsesIoCompletionPort" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "EnableDwmInputProcessing" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "Max Cached Icons" /t REG_SZ /d "4096" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DWMWA_TRANSITIONS_FORCEDISABLED" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowFlip3d" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowColorizationColorChanges" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "CompositionPolicy" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\DWM" /v "OneCoreNoBootDWM" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\DWM" /v "AnimationAttributionHashingEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\DWM" /v "AnimationAttributionEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f > nul 2> nul / Breaks "Animate Windows when Minimizing and Maximizing" setting
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows" /v "DisableAcrylicBackgroundOnLogon" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "TurnOffSPIAnimations" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "DisableLogonBackgroundImage" /t REG_DWORD /d "1" /f > nul 2> nul

timeout /t 2 >nul
cls

:: ============================== ::
::      APPLICATION SETTINGS      ::
:: ============================== ::

echo ____________________
echo.
echo  BLENDING MATERIALS
echo ____________________
echo.

:: Configure Internet Explorer
reg add "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main" /v "NoUpdateCheck" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main" /v "Enable Browser Extensions" /t REG_SZ /d "no" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main" /v "Isolation" /t REG_SZ /d "PMEM" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main" /v "Isolation64Bit" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\BrowserEmulation" /v "IntranetCompatibilityMode" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer" /v "DisableFlashInIE" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\SQM" /v "DisableCustomerImprovementProgram" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\DomainSuggestion" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Security" /v "DisableSecuritySettingsCheck" /t "REG_DWORD" /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Security" /v "DisableFixSecuritySettings" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Privacy" /v "EnableInPrivateBrowsing" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Privacy" /v "ClearBrowsingHistoryOnExit" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "DEPOff" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "EnableAutoUpgrade" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "DisableFirstRunCustomize" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "HideNewEdgeButton" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Feed Discovery" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Feeds" /v "BackgroundSyncStatus" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\FlipAhead" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Suggested Sites" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\TabbedBrowsing" /v "NewTabPageShow" /t REG_DWORD /d "1" /f > nul 2> nul

:: Configure Notepad
reg add "HKCU\SOFTWARE\Microsoft\Notepad" /v "StatusBar" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Notepad" /v "fWrap" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Notepad" /v "fSavePageSettings" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Notepad" /v "fSaveWindowPositions" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Notepad" /v "fWindowsOnlyEOL" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Notepad" /v "fPasteOriginalEOL" /t REG_DWORD /d "0" /f > nul 2> nul

:: Configure Microsoft Store
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d "2" /f > nul 2> nul

:: Configure Windows Media Player
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsMediaPlayer" /v "GroupPrivacyAcceptance" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "AcceptedEULA" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "AcceptedPrivacyStatement" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "FirstTime" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "UsageTracking" /t REG_DWORD /d "0" /f > nul 2> nul

timeout /t 2 >nul
cls

:: ============================== ::
::    UNDER THE HOOD SETTINGS     ::
:: ============================== ::

echo _____________________________
echo.
echo  CUSTOMIZING YOUR EXPERIENCE
echo _____________________________
echo.

:: Miscellaneous
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "MicrosoftEdgeDataOptIn" /t REG_DWORD /d "0" /f > nul 2> nul
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f

:: Disable "Find My Device"
reg add "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" /v "AllowFindMyDevice" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" /v "LocationSyncEnabled" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Clipboard History
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowClipboardHistory" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowCrossDeviceClipboard" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Settings Sync
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t REG_DWORD /d "5" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable Location Sensors
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableSensors" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableWindowsLocationProvider" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Delivery Optimization
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadFromBypassCache" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable WMI Keylogger
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Reliability Analysis\WMI" /v "WMIEnable" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\EventLog\ProtectedEventLogging" /v "EnableProtectedEventLogging" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup" /v "Enabled" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer" /v "DisableLoggingFromPackage" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudExperienceHost" /v "ETWLoggingEnabled" /t REG_DWORD /d "0" /f > nul 2> nul

:: Data Execution
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoDataExecutionPrevention" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "DisableHHDEP" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable Biometrics
reg add "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowDomainPINLogon" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Microsoft Windows Just-In-Time (JIT) Script Debugging
reg add "HKCU\SOFTWARE\Microsoft\Windows Script\Settings" /v "JITDebug" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKU\.Default\Microsoft\Windows Script\Settings" /v "JITDebug" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AeDebug" /v "Auto" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\.NETFramework\DbgJITDebugLaunchSetting" /v "enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\.NETFramework\DbgJITDebugLaunchSetting" /v "Auto" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Diagnostics
for %%i in (diagsvc DPS WdiServiceHost WdiSystemHost) do (
	reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%i" /ve
	if %errorlevel% == 0 (
		%currentuser% reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%i" /v "Start" /t REG_DWORD /d "4" /f
	)
)

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\ScheduledDiagnostics" /v "EnabledExecution" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\ScheduledDiagnostics" /v "EnabledExecution" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\ScriptedDiagnosticsProvider\Policy" /v "DisableQueryRemoteServer" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\ScriptedDiagnosticsProvider\Policy" /v "EnableQueryRemoteServer" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Diagnostic Tracing
%currentuser% reg add "HKLM\SYSTEM\CurrentControlSet\Control\Diagnostics\Performance" /v "DisableDiagnosticTracing" /t REG_DWORD /d "1" /f

:: Disable Shared Experiences
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableCdp" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Sharing Across Devices
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v "CdpSessionUserAuthzPolicy" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v "NearShareChannelUserAuthzPolicy" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v "RomeSdkChannelUserAuthzPolicy" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable PerfTrack
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}" /v "ScenarioExecutionEnabled" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Storage Health Telemetry
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Telemetry" /v "EnablePeriodicTelemetry" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\StorageHealth" /v "AllowDiskHealthModelUpdates" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl\StorageTelemetry" /v "DeviceDumpEnabled" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Web Content Evaluation
%currentuser% reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost\Download" /v "CheckExeSignatures" /t REG_SZ /d "no" /f

:: Disable Input Prediction
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings" /v "HarvestContacts" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings" /v "LMDataLoggerEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings" /v "InsightsEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings" /v "MultilingualEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings" /v "EnableHwkbTextPrediction" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable MSDT-URL Protocol
reg delete "HKCR\ms-msdt" /f > nul 2> nul

:: Disable WPAD
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Wpad" /v "WpadOverride" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "UseDomainNameDevolution" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable AutoLogger
for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger" /s /f "start"^| findstr "HKEY"') do (
	reg add "%%i" /v "Start" /t REG_DWORD /d "0" /f
) > nul 2> nul

:: Disable Application Compatibility Telemetry  ; Credits to DuckOS and ArtanisInc
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AllowTelemetry" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\TelemetryController" /v "RunsBlocked" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\UEV\Agent" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\UEV\Agent\Configuration" /v "CustomerExperienceImprovementProgram" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\UEV\Agent\Configuration" /v "SyncEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\ClientTelemetry" /v "TaskEnableRun" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable RSoP
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "RSoPLogging" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Chain Validation
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Access to Language List
%currentuser% reg add "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d "1" /f

:: Disable Spectre and Meltdown ; Credits to HoneCtrl
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f > nul 2> nul
%WinDir%\gyrOS\MinSudo\MinSudo.exe --trustedinstaller --nologo cmd /c "reg add "HKLM\SYSTEM\CurrentControlSet\Services\TrustedInstaller" /v "Start" /t Reg_DWORD /d "3" /f"
%WinDir%\gyrOS\MinSudo\MinSudo.exe --trustedinstaller --nologo cmd /c "sc start "TrustedInstaller""
%WinDir%\gyrOS\MinSudo\MinSudo.exe --trustedinstaller --nologo cmd /c "del %SYSTEMROOT%\System32\mcupdate_GenuineIntel.dll"
%WinDir%\gyrOS\MinSudo\MinSudo.exe --trustedinstaller --nologo cmd /c "del %SYSTEMROOT%\System32\mcupdate_AuthenticAMD.dll"
taskkill /im GameBarPresenceWriter.exe /f > nul 2> nul
%WinDir%\gyrOS\MinSudo\MinSudo.exe --trustedinstaller --nologo cmd /c "del %WinDir%\System32\GameBarPresenceWriter.exe"
%currentuser% reg add "HKLM\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter" /v "ActivationType" /t REG_DWORD /d "0" /f

:: Refuse Secure Authentication
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "LmCompatibilityLevel" /t REG_DWORD /d "5" /f > nul 2> nul

:: Prevent Storage of the LAN Manager Hash of Passwords
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "NoLMHash" /t REG_DWORD /d "1" /f > nul 2> nul

:: Prevent WinRM from using Basic Authentication
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client" /v "AllowBasic" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" /v "AllowBasic" /t REG_DWORD /d "0" /f > nul 2> nul

:: Configure TaggedEnergy, Power Logging
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxTagPerApplication" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "DisableTaggedEnergyLogging" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxApplication" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Hibernation and Fast Startup
powercfg /h off > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabledDefault" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepReliabilityDetailedDiagnostics" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d "0" /f > nul 2> nul

:: Configure PowerShell
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "AutoRestartShell" /t REG_DWORD /d "1" /f > nul 2> nul
setx POWERSHELL_TELEMETRY_OPTOUT 1 > nul 2> nul

:: Disable NET Core CLI Telemetry
setx DOTNET_CLI_TELEMETRY_OPTOUT 1 > nul 2> nul

:: Enable Numlock on Startup
%currentuser% reg add "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /d "2" /t REG_DWORD /f

:: Disable NetBios / NetBT ; Credits to ArtanisInc
for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces" /s /f "NetbiosOptions"^| findstr "HKEY"') do (
	reg add "%%i" /v "NetbiosOptions" /t REG_DWORD /d "2" /f
) > nul 2> nul

reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" /v "NodeType" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" /v "SMBDeviceEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" /v "EnableLMHOSTS" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" /v "NetbiosOptions" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBIOS" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lmhosts" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul

:: Disable DMA Memory Protection, Cores Isolation and VBS
bcdedit /set hypervisorlaunchtype Off > nul 2> nul
bcdedit /set vsmlaunchtype Off > nul 2> nul
bcdedit /set vm No > nul 2> nul
bcdedit /set loadoptions DISABLE-LSA-ISO,DISABLE-VBS > nul 2> nul

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "ConfigureSystemGuardLaunch" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "RequirePlatformSecurityFeatures" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "LsaCfgFlags" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequireMicrosoftSignedBootChain" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable VBS
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HypervisorEnforcedCodeIntegrity" /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable DMA Remapping ; Credits to DuckOS
for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "DmaRemappingCompatible" ^| find /i "Services\" ') do (
	reg add "%%i" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f
) > nul 2> nul

reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\DmaGuard\DeviceEnumerationPolicy" /v "value" /t REG_DWORD /d "2" /f > nul 2> nul

:: Disable System Devices
for %%i in (
	"WAN Miniport (PPPOE)"
	"WAN Miniport (PPTP)"
	"WAN Miniport (SSTP)"
	"WAN Miniport (IPv6)"
	"WAN Miniport (IKEv2)"
	"WAN Miniport (L2TP)"
	"WAN Miniport (IP)"
	"WAN Miniport (Network Monitor)"
	"Microsoft RRAS Root Enumerator"
	"NDIS Virtual Network Adapter Enumerator"
	"System Speaker MemoryDiagnostic"
	"System Speaker"
	"System Timer"
	"Motherboard resources"
	"Microsoft Hyper-V NT Kernel Integration VSP"
	"Microsoft Hyper-V PCI Server"
	"Microsoft Hyper-V Virtual Machine Bus Provider"
	"Microsoft Hyper-V Virtualization Infrastructure Driver"
	"Microsoft Hyper-V Virtual Disk Server"
	"UMBus Root Bus Enumerator"
	"Microsoft System Management BIOS Driver"
	"ACPI Processor Aggregator"
	"Microsoft Windows Management Interface for ACPI"
	"High Precision Event Timer"
	"PCI Encryption/Decryption Controller"
	"AMD PSP"
	"AMD SMBus"
	"PCI Data Acquisition and Signal Processing Controller"
	"Intel SMBus"
	"Intel Management Engine"
	"Intel Management Engine Interface"
	"PCI Memory Controller"
	"PCI standard RAM Controller"
	"Composite Bus Enumerator"
	"Microsoft Kernel Debug Network Adapter"
	"SM Bus Controller"
	"Numeric Data Processor"
	"System CMOS/real time clock"
	"PCI Simple Communications Controller"
	"Microsoft GS Wavetable Synth"
	"Amdlog"
	"Remote Desktop Device Redirector Bus"
) do (
	start "" "%WinDir%\gyrOS\DevManView.exe" /disable %%i
) > nul 2> nul

:: Opt-Out of Sending Client Activation Data to Microsoft ; Credits to ArtanisInc
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "AllowWindowsEntitlementReactivation" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable Windows Error Reporting
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "AutoApproveOSDumps" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DontShowUI" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d "1" /f > nul 2> nul

:: Data Queue Sizes ; Credits to EchoX
for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" 2^>nul') do set /a "kbdqueuesize=%%a"
if "%kbdqueuesize%" gtr "50" reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d "50" /f > nul 2> nul
for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" 2^>nul') do set /a "mssqueuesize=%%a"
if "%mssqueuesize%" gtr "50" reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d "50" /f > nul 2> nul

:: Disable Speech Model Updates
reg add "HKLM\SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v "HasAccepted" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Remote Assistance ; Credits to ArtanisInc
for %%i in (RasAuto SessionEnv TermService UmRdpService RpcLocator) do (
	reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%i" /ve
	if %errorlevel% == 0 (
		%currentuser% reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%i" /v "Start" /t REG_DWORD /d "4" /f
	)
)

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service\WinRS" /v "AllowRemoteShellAccess" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowFullControl" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fEnableChatControl" /t REG_DWORD /d "0" /f > nul 2> nul
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

:: Enable Game Mode
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "1" /f > nul 2> nul

:: Configure Gamebar
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "GamePanelStartupTipIndex" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f > nul 2> nul
%currentuser% reg delete "HKCU\SYSTEM\GameConfigStore\Children" /f
%currentuser% reg delete "HKCU\SYSTEM\GameConfigStore\Parents" /f

:: Configure FSO ; Credits to ArtanisInc
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_DSEBehavior" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "__COMPAT_LAYER" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f > nul 2> nul

:: Wait to Kill Applications at Shutdown
reg add "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "1000" /f > nul 2> nul

:: Wait to End Service at Shutdown
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "2000" /f > nul 2> nul
reg add "HKCU\Control Panel\Desktop" /v "WaitToKillServiceTimeout" /t REG_SZ /d "2000" /f > nul 2> nul

:: Blocking Data Collection and Telemetry
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowCommercialDataPipeline" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowDesktopAnalyticsProcessing" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowWUfBCloudProcessing" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "CommercialId" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DisableEnterpriseAuthProxy" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "TelemetryProxyServer" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\RemovalTools\MpGears" /v "HeartbeatTrackingIndex" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\RemovalTools\MpGears" /v "SpyNetReportingLocation" /t REG_MULTI_SZ /d "" /f > nul 2> nul

:: Disable CEIP
%currentuser% reg add "HKCU\SOFTWARE\Policies\Microsoft\Messenger\Client" /v "CEIP" /t REG_DWORD /d "2" /f
%currentuser% reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKLM\SOFTWARE\Policies\Microsoft\AppV\CEIP" /v "CEIPEnable" /t REG_DWORD /d "0" /f

:: Disable Sleep Study
for %%a in (SleepStudy Kernel-Processor-Power UserModePowerService) do (
	wevtutil set-log Microsoft-Windows-%%a/Diagnostic /e:false
) > nul 2> nul

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepStudyEnabled" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\9A6B7878-AD52-4AEC-9B44-767F1A8F3FDC" /v "Attributes" /t REG_DWORD /d "2" /f > nul 2> nul

:: Disable Startup Delay for RunOnce and Run Keys
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Desktop" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f > nul 2> nul

:: Content Delivery Manager
for %%a in (310093 353698 314563 338389 338387 338388 338393) do (
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-%%aEnabled" /t REG_DWORD /d "0" /f
) > nul 2> nul

for %%a in (RotatingLockScreenOverlayEnabled OemPreInstalledAppsEnabled PreInstalledAppsEnabled PreInstalledAppsEverEnabled RotatingLockScreenEnabled SoftLandingEnabled SystemPaneSuggestionsEnabled SilentInstalledAppsEnabled ContentDeliveryAllowed) do (
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "%%a" /t REG_DWORD /d "0" /f
) > nul 2> nul

reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d "1" /f > nul 2> nul

timeout /t 2 >nul
cls

:: ============================== ::
::   PERFORMANCE OPTIMIZATIONS    ::
:: ============================== ::

echo _____________________________
echo.
echo  CUSTOMIZING YOUR EXPERIENCE
echo _____________________________
echo.

:: Set Service Split Threshold ; Credits to HoneCtrl
for /f "tokens=2 delims==" %%i in ('wmic os get TotalVisibleMemorySize /value') do set /a mem=%%i + 1024000
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d %mem% /f > nul 2> nul

:: BCDedit
bcdedit /set disabledynamictick Yes > nul 2> nul

:: Enable X2Apic and Memory Mapping for PCI-E Devices ; Credits to HoneCtrl
bcdedit /set x2apicpolicy Enable > nul 2> nul
bcdedit /set uselegacyapicmode No > nul 2> nul
bcdedit /set configaccesspolicy Default > nul 2> nul
bcdedit /set usephysicaldestination No > nul 2> nul
bcdedit /set usefirmwarepcisettings No > nul 2> nul

:: Boot Configuration
bcdedit /set bootux Disabled > nul 2> nul
bcdedit /set quietboot Yes > nul 2> nul
bcdedit /set bootmenupolicy Legacy > nul 2> nul
bcdedit /set recoveryenabled No > nul 2> nul
bcdedit /set tpmbootentropy ForceDisable > nul 2> nul
bcdedit /set description gyrOS > nul 2> nul

:: Lower Latency
::bcdedit /set tscsyncpolicy legacy > nul 2> nul

:: Better FPS
bcdedit /set tscsyncpolicy enhanced > nul 2> nul

:: Configure DEP
bcdedit /deletevalue nx > nul 2> nul
bcdedit /set nx AlwaysOff > nul 2> nul

:: Set Win32PrioritySeparation
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f > nul 2> nul

:: Set CSRSS to be a High Priority Process
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f > nul 2> nul

:: Hung Apps, Wait to Kill, Mouse ; Credits to DuckOS
reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f > nul 2> nul
reg add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "2000" /f > nul 2> nul
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_DWORD /d "0" /f
reg add "HKCU\Control Panel\Desktop" /v "ForegroundLockTimeout" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKCU\Control Panel\Desktop" /v "MouseWheelRouting" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKCU\Control Panel\Desktop" /v "LowLevelHooksTimeout" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PnP" /v "PollBootPartitionTimeout" /t REG_DWORD /d "1" /f > nul 2> nul
%currentuser% reg add "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v "DisableSelectiveSuspend" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disallow Background Apps ; Credits to EchoX
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Disk Quota
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DiskQuota" /v "Enforce" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DiskQuota" /v "Enable" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DiskQuota" /v "LogEventOverLimit" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DiskQuota" /v "LogEventOverThreshold" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Maintenance Tasks
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "WakeUp" /t REG_DWORD /d "0" /f > nul 2> nul

:: Remove IRQ Priorities
for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /f "irq"^| findstr "IRQ"') do (
	reg delete "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "%%i" /f
) > nul 2> nul

:: Better Cache Management
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "CacheHashTableBucketSize" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "CacheHashTableSize" /t REG_DWORD /d "180" /f > nul 2> nul

:: Enable Large System Cache
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable Administrative Shares
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareServer" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareWks" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" /v "RestrictNullSessAccess" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "LocalAccountTokenFilterPolicy" /t REG_DWORD /d "0" /f > nul 2> nul

:: Disable Random Drivers Verification
bcdedit /set nointegritychecks On > nul 2> nul
bcdedit /set testsigning Off > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "DontVerifyRandomDrivers" /t REG_DWORD /d "1" /f > nul 2> nul

:: MMCSS
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "10" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f > nul 2> nul

:: GPU Tweaks, Disable GpuEnergyDrv ; Credits to HoneCtrl
reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t Reg_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDr" /v "Start" /t Reg_DWORD /d "4" /f > nul 2> nul

for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class" /v "VgaCompatible" /s ^| findstr "HKEY"') do (
	reg add "%%a" /v "KMD_EnableGDIAcceleration" /t REG_DWORD /d "1" /f
) > nul 2> nul

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Netsh Tweaks ; Credits to HoneCtrl, Melody and ArtanisInc
netsh interface Teredo set state type=enterpriseclient > nul 2> nul
netsh interface Teredo set state servername=default > nul 2> nul
netsh interface tcp set heuristics disabled > nul 2> nul
netsh interface tcp set global dca=enabled > nul 2> nul
netsh interface tcp set global rsc=disabled > nul 2> nul
netsh interface tcp set global timestamps=disabled > nul 2> nul
netsh interface tcp set supplemental Internet congestionprovider=ctcp > nul 2> nul

:: Enable RSS
netsh interface tcp set global rss=enabled > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Ndis\Parameters" /v "RssBaseCpu" /t REG_DWORD /d "1" /f > nul 2> nul

:: Network Optimizations
%PowerShell% "Enable-NetAdapterRss -Name *" > nul 2> nul
%PowerShell% "Disable-NetAdapterLso -Name *" > nul 2> nul
%PowerShell% "Set-NetOffloadGlobalSetting -PacketCoalescingFilter Disabled" > nul 2> nul

:: Disable Window Scaling Heuristics
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t REG_DWORD /d "0" /f > nul 2> nul

:: Enable DNS over HTTPS ; Credits to EchoX
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableAutoDoh" /t REG_DWORD /d "2" /f > nul 2> nul

:: Enable TCP Extensions ; Credits to EchoX
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d "1" /f > nul 2> nul

:: Configure NIC ; Credits to HoneCtrl and Melody
for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class" /v "*WakeOnMagicPacket" /s ^| findstr "HKEY"') do (
    for %%i in (
        "*EEE"
        "*FlowControl"
        "EnableSavePowerNow"
        "EnablePowerManagement"
        "EnableDynamicPowerGating"
        "EnableConnectedPowerGating"
        "AutoPowerSaveModeEnabled"
        "AdvancedEEE"
        "ULPMode"
        "ReduceSpeedOnPowerDown"
        "EnablePME"
        "*WakeOnMagicPacket"
        "*WakeOnPattern"
        "*LsoV2IPv4"
        "*LsoV2IPv6"
        "EnableGreenEthernet"
        "GigaLite"
        "PowerSavingMode"
        "AutoDisableGigabit"
        "SelectiveSuspend"
        "EnableModernStandby"
        "WakeOnLink"
        "WakeOnSlot"
        "WakeUpModeCap"
		"*NicAutoPowerSaver"
    ) do (
        for /f %%k in ('reg query "%%a" /v "%%~i" ^| findstr "HKEY"') do (
            reg add "%%k" /v "%%~i" /t REG_SZ /d "0" /f
        )
    )
) > nul 2> nul

:: Disable Nagle's Algorithm ; Credits to ArtanisInc
reg add "HKLM\Software\Microsoft\MSMQ\Parameters" /v "TCPNoDelay" /t REG_DWORD /d "1" /f > nul 2> nul
for /f %%i in ('wmic path Win32_NetworkAdapter get GUID^| findstr "{"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TCPNoDelay" /t REG_DWORD /d "1" /f
) > nul 2> nul

:: Disable JUMBOPACKET
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
    for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i" /v "Driver"') do (
        for /f %%i in ('echo %%a ^| findstr "{"') do (
			for %%a in (JumboPacket) do for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /s /f "*%%a" ^| findstr "HKEY"') do reg add "%%b" /v "*%%a" /t REG_SZ /d "1514" /f
		)
    )
) > nul 2> nul

:: Patch IGMP
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "IGMPLevel" /t REG_DWORD /d "0" /f > nul 2> nul

:: DNS
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v "DisableSmartNameResolution" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "DisableParallelAandAAAA" /t REG_DWORD /d "1" /f > nul 2> nul

:: Branch Cache
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "DisableBandwidthThrottling" /t REG_DWORD /d "1" /f > nul 2> nul

:: QoS
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_DWORD /d "1" /f > nul 2> nul

:: Disable Task Offload  ; Credits to HoneCtrl
netsh interface ip set global taskoffload=disabled > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t REG_DWORD /d "1" /f > nul 2> nul

:: Configure Firewall
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f > nul 2> nul
netsh advfirewall set allprofiles state off > nul 2> nul
netsh advfirewall firewall set rule group="Network Discovery" new enable=No > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "3" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "3" /f > nul 2> nul

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Enable MSI Mode
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
	reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f
) > nul 2> nul

for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
	reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f
) > nul 2> nul

for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
	reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f
) > nul 2> nul

for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
	reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f
) > nul 2> nul

:: Set Priority to Normal if used on VMWare
wmic computersystem get manufacturer /format:value | findstr /i /C:VMWare && (
    for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "2" /f
    ) > nul 2> nul
)

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Disable Power Saving on Plug and Play Devices ; Credits to DuckOS
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
	for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i" /v "Driver"') do (
		for /f %%i in ('echo %%a ^| findstr "{"') do (
			reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "PnPCapabilities" /t REG_DWORD /d "24" /f
		) > nul 2> nul
	)
)

:: Disable Power Saving ; Credits to HoneCtrl and ArtanisInc
for %%i in (EnableHIPM EnableDIPM EnableHDDParking) do (
	for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "%%i" ^| findstr "HKEY"') do (
		reg add "%%a" /v "%%i" /t REG_DWORD /d "0" /f
	) > nul 2> nul
)

for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "StorPort" ^| findstr "StorPort"') do (
	reg add "%%i" /v "EnableIdlePowerManagement" /t REG_DWORD /d "0" /f
) > nul 2> nul

for /f "tokens=*" %%i in ('wmic PATH Win32_PnPEntity GET DeviceID ^| findstr "USB\VID_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "AllowIdleIrpInD3" /t REG_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnableSelectiveSuspend" /t REG_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "DeviceSelectiveSuspended" /t REG_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "D3ColdSupported" /t REG_DWORD /d "0" /f
) > nul 2> nul

for %%i in (EnumerationRetryCount ExtPropDescSemaphore WaitWakeEnabled WdfDirectedPowerTransitionEnable EnableIdlePowerManagement IdleInWorkingState) do (
	for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "%%i"^| findstr "HKEY"') do (
		reg add "%%a" /v "%%i" /t REG_DWORD /d "0" /f
	) > nul 2> nul
)

for %%i in (DisableIdlePowerManagement) do (
	for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "%%i"^| findstr "HKEY"') do (
		reg add "%%a" /v "%%i" /t REG_DWORD /d "1" /f
	) > nul 2> nul
)

reg add "HKLM\SYSTEM\CurrentControlSet\Services\pci\Parameters" /v "ASPMOptOut" /t	REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Storage" /v "StorageD3InModernStandby" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device" /v "IdlePowerMode" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v "DefaultPnPCapabilities" /t REG_DWORD /d "24" /f > nul 2> nul

:: Affinity ; Credits to HoneCtrl
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "3" /f
	reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /f
) > nul 2> nul

for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "5" /f
	reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /f
) > nul 2> nul

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Enable Hardware Accelerated Scheduling ; Credits to HoneCtrl
reg query "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" > nul 2> nul
if %errorlevel% == 0 (
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d "2" /f
) > nul 2> nul

:: Force Contiguous Memory Allocation in the DirectX Kernel
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f > nul 2> nul

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Security Tweaks
%PowerShell% "Set-SmbClientConfiguration -RequireSecuritySignature $True -Force" > nul 2> nul
%PowerShell% "Set-SmbClientConfiguration -EnableSecuritySignature $True -Force" > nul 2> nul
%PowerShell% "Set-SmbServerConfiguration -EncryptData $True -Force" > nul 2> nul
%PowerShell% "Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force" > nul 2> nul

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RunAsPPL" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdminOutboundCreds" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdmin" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "EveryoneIncludesAnonymous" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RestrictAnonymous" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RestrictAnonymousSAM" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" /v "RestrictReceivingNTLMTraffic" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" /v "RestrictSendingNTLMTraffic" /t REG_DWORD /d "2" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" /v "DisableCompression" /t REG_DWORD /d "1" /f > nul 2> nul

:: Storage Optimizations ; Credits to ArtanisInc
for /f "skip=1" %%i in ('wmic os get TotalVisibleMemorySize') do if not defined TOTAL_MEMORY set "TOTAL_MEMORY=%%i"
if !TOTAL_MEMORY! LSS 8000000 (
	fsutil behavior set memoryusage 1
	fsutil behavior set mftzone 1
) > nul 2> nul else if !TOTAL_MEMORY! LSS 16000000 (
	fsutil behavior set memoryusage 1
	fsutil behavior set mftzone 2
) > nul 2> nul else (
	fsutil behavior set memoryusage 2
	fsutil behavior set mftzone 2
) > nul 2> nul

fsutil behavior set disablelastaccess 1 > nul 2> nul
fsutil behavior set Bugcheckoncorrupt 0 > nul 2> nul
fsutil behavior set disable8dot3 1 > nul 2> nul
fsutil behavior set disablecompression 1 > nul 2> nul
fsutil behavior set disabledeletenotify 0 > nul 2> nul
fsutil behavior set encryptpagingfile 0 > nul 2> nul

reg add "HKLM\SYSTEM\CurrentControlSet\Services\rdyboost" /v "Start" /t REG_DWORD /d "4" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePageCombining" /t REG_DWORD /d "1" /f > nul 2> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ  /d "" /f > nul 2> nul

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Fix Folder View Settings
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSaveSettings" /t REG_SZ /d "0" /f > nul 2> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSaveSettings" /t REG_SZ /d "0" /f > nul 2> nul
reg delete "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f > nul 2> nul
reg delete "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\All Folders\Shell" /v "FolderType" /t "REG_SZ" /d "NotSpecified" /f > nul 2> nul
reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell" /v "BagMRU Size" /t "REG_DWORD" /d "2710" /f > nul 2> nul

:: Disable Mitigations ; Credits to Amit
%PowerShell% "Set-ProcessMitigation -System -Disable CFG"

for /f "tokens=3 skip=2" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions"') do (
    set "mitigation_mask=%%a"
)
for /l %%a in (0,1,9) do (
    set "mitigation_mask=!mitigation_mask:%%a=2!"
)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions" /t REG_BINARY /d "%mitigation_mask%" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "%mitigation_mask%" /f

timeout /t 2 >nul
cls

:: ============================== ::
::             TASKS              ::
:: ============================== ::

echo __________________
echo.
echo  WELCOME TO GYROS
echo __________________
echo.

:: Disable Tasks
for %%i in (
	UpdateOrchestrator\Reboot
	UpdateOrchestrator\USO_UxBroker_Display
	UpdateOrchestrator\USO_UxBroker_ReadyToReboot
	WindowsUpdate\sih
	WindowsUpdate\sihboot
	WindowsUpdate\Scheduled
	WindowsUpdate\sihpostreboot
) do (
	schtasks /Change /TN "\Microsoft\Windows\%%i" /disable
) > nul 2> nul

for %%i in (
	Consolidator
	BthSQM
	KernelCeipTask
	UsbCeip
	Uploader
) do (
	schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\%%i" /disable
) > nul 2> nul

for %%i in (
	PcaPatchDbTask
	StartupAppTask
	ProgramDataUpdater
) do (
	schtasks /Change /TN "\Microsoft\Windows\Application Experience\%%i" /disable
) > nul 2> nul

for %%i in (
	Defrag\ScheduledDefrag
	DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector
	MemoryDiagnostic\ProcessMemoryDiagnosticEvents
	MemoryDiagnostic\RunFullMemoryDiagnostic
	Shell\IndexerAutomaticMaintenance
	WaaSMedic\PerformRemediation
	DiskFootprint\Diagnostics
	DiskFootprint\StorageSense
	BrokerInfrastructure\BgTaskRegistrationMaintenanceTask
	CloudExperienceHost\CreateObjectTask
	Registry\RegIdleBackup
	SoftwareProtectionPlatform\SvcRestartTaskNetwork
	SoftwareProtectionPlatform\SvcRestartTaskLogon
	StateRepository\MaintenanceTasks
	UPnP\UPnPHostConfig
	RetailDemo\CleanupOfflineContent
	InstallService\ScanForUpdates
	InstallService\ScanForUpdatesAsUser
	InstallService\SmartRetry
	Printing\EduPrintProv
	Ras\MobilityManager
	DiskCleanup\SilentCleanup
	Diagnosis\Scheduled
	Wininet\CacheTask
	NetTrace\GatherNetworkInfo
	TPM\Tpm-HASCertRetr
	TPM\Tpm-Maintenance
	Sysmain\ResPriStaticDbSync
	ApplicationData\appuriverifierdaily
	ApplicationData\appuriverifierinstall
	ApplicationData\DsSvcCleanup
	PushToInstall\LoginCheck
	Shell\FamilySafetyMonitor
	Shell\FamilySafetyRefresh
) do (
	schtasks /Change /TN "\Microsoft\Windows\%%i" /disable
) > nul 2> nul

schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Refresh Settings" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Device Information\Device" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Device Information\Device User" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\International\Synchronize Language Settings" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Zone\SynchronizeTimeZone" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\SynchronizeTime" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64 Critical" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 Critical" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\XblGameSave\XblGameSaveTask" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\XblGameSave\XblGameSaveTaskLogon" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\WindowsManagement\Provisioning\Cellular" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\TaskScheduler\Maintenance Configurator" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\TaskScheduler\Regular Maintenance" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Windows Media Sharing\UpdateLibrary" > nul 2> nul

timeout /t 2 >nul
cls

echo _______________________________
echo.
echo  RESTART REQUIRED, PLEASE WAIT
echo _______________________________

timeout /t 3 >nul
cls

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

timeout /t 4
shutdown /r /t 6 /f
