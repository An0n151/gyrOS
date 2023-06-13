:: gyrOS ::

:: UAC Services

@echo off
setlocal EnableDelayedExpansion


set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

echo 1. Enable UAC Services
echo 2. Disable UAC Services (Default)
echo.
set /p menu=: 
if %menu% EQU 1 goto enable
if %menu% EQU 2 goto disable

:enable
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "5" /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v "PromptOnSecureDesktop" /t REG_DWORD /d "1" /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v "EnableLUA" /t REG_DWORD /d "1" /f

cls

echo Finished enabling UAC, please reboot your device for changes to apply.
echo.
pause
exit /b

:disable
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "0" /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v "EnableLUA" /t REG_DWORD /d "0" /f

cls

echo Finished disabling UAC, please reboot your device for changes to apply.
echo.
pause
exit /b