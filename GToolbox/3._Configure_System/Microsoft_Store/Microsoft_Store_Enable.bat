:: ### gyrOS ###

:: Enable Microsoft Store

@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

set "currentuser=%WinDir%\gyrOS\NSudo\NSudoLG.exe -U:C -P:E -Wait"

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d "0" /f

sc config "InstallService" start= demand
sc config "WinHttpAutoProxySvc" start= demand
%currentuser% reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "3" /f
sc config "wlidsvc" start= demand
sc config "AppXSvc" start= demand
%currentuser% reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppXSvc" /v "Start" /t REG_DWORD /d "3" /f
sc config "TokenBroker" start= demand
sc config "LicenseManager" start= demand
sc config "ClipSVC" start= demand
%currentuser% reg add "HKLM\SYSTEM\CurrentControlSet\Services\ClipSVC" /v "Start" /t REG_DWORD /d "3" /f
sc config "FileInfo" start= boot
sc config "FileCrypt" start= system

echo.
echo Microsoft Store has been enabled.
echo.

pause >nul