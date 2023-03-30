:: gyrOS ::

:: Disable Hyper-V

@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

bcdedit /set hypervisorlaunchtype off
bcdedit /set vm No
bcdedit /set vsmlaunchtype Off
bcdedit /set loadoptions DISABLE-LSA-ISO,DISABLE-VBS

reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HypervisorEnforcedCodeIntegrity" /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "ConfigureSystemGuardLaunch" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "RequirePlatformSecurityFeatures" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "LsaCfgFlags" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequireMicrosoftSignedBootChain" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t REG_DWORD /d "0" /f

%WinDir%\gyrOS\DevManView.exe /disable "Microsoft Hyper-V NT Kernel Integration VSP"
%WinDir%\gyrOS\DevManView.exe /disable "Microsoft Hyper-V PCI Server"
%WinDir%\gyrOS\DevManView.exe /disable "Microsoft Hyper-V Virtual Machine Bus Provider"
%WinDir%\gyrOS\DevManView.exe /disable "Microsoft Hyper-V Virtualization Infrastructure Driver"
%WinDir%\gyrOS\DevManView.exe /disable "Microsoft Hyper-V Virtual Disk Server"

echo.
echo. Hyper-V has been disabled.
echo.

pause >nul