:: gyrOS ::

:: Disable UAC

@echo off
pushd "%~dp0"

reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "0" /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v "EnableLUA" /t REG_DWORD /d "0" /f

echo.
echo Success.
echo.

pause >nul