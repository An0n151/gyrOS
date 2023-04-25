:: gyrOS ::

:: Enable UAC

@echo off
pushd "%~dp0"

reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "5" /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v "PromptOnSecureDesktop" /t REG_DWORD /d "1" /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v "EnableLUA" /t REG_DWORD /d "1" /f

echo.
echo Success.
echo.

pause >nul