:: gyrOS ::

:: Disable MSI Center Services

@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

sc stop MSI_Center_Service
sc stop MSI_VoiceControl_Service
sc stop MSI_Case_Service
sc stop Mystic_Light_Service
sc stop LightKeeperService

reg add "HKLM\SYSTEM\CurrentControlSet\Services\MSI_Center_Service" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\MSI_VoiceControl_Service" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\MSI_Case_Service" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Mystic_Light_Service" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LightKeeperService" /v "Start" /t REG_DWORD /d "3" /f

cls

echo Success.
pause
exit /b