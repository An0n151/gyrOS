:: gyrOS ::

:: Clipboard History Services prompt script

@echo off
setlocal EnableDelayedExpansion


set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

echo 1. Enable Clipboard History
echo 2. Disable Clipboard History (Default)
echo.
set /p menu=:
if %menu% EQU 1 goto enable
if %menu% EQU 2 goto disable

:enable
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowClipboardHistory" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\cbdhsvc" /v "Start" /t REG_DWORD /d "2" /f

for /f %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services" /s /k /f cbdhsvc ^| find /i "cbdhsvc" ') do (
  reg add "%%i" /v "Start" /t REG_DWORD /d "3" /f
)

cls

echo Finished enabling clipboard history, please reboot your device for changes to apply.
pause
exit /b

:disable
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowClipboardHistory" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\cbdhsvc" /v "Start" /t REG_DWORD /d "4" /f

for /f %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services" /s /k /f cbdhsvc ^| find /i "cbdhsvc" ') do (
  reg add "%%i" /v "Start" /t REG_DWORD /d "4" /f
)

cls

echo Finished disabling  clipboard history, please reboot your device for changes to apply.
pause
exit /b