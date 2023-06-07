:: gyrOS ::

:: Workstation services prompt script

@echo off
setlocal EnableDelayedExpansion


set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

echo 1. Enable Workstation Services
echo 2. Disable Workstation Services (Default)
echo.
set /p menu=:
if %menu% EQU 1 goto enable
if %menu% EQU 2 goto disable

:enable
reg add "HKLM\SYSTEM\CurrentControlSet\Services\rdbss" /v "Start" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\KSecPkg" /v "Start" /t REG_DWORD /d "0" /f

cls

echo Finished enabling the workstation services, please reboot your device for changes to apply.
pause
exit /b

:disable
reg add "HKLM\SYSTEM\CurrentControlSet\Services\rdbss" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\KSecPkg" /v "Start" /t REG_DWORD /d "4" /f

cls

echo Finished disabling the workstation services, please reboot your device for changes to apply.
pause
exit /b