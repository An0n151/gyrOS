:: ### gyrOS ###

:: Disable Microsoft Store

@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d "1" /f

sc config "InstallService" start= disabled
sc config "WinHttpAutoProxySvc" start= disabled
sc config "wlidsvc" start= disabled
sc config "AppXSvc" start= disabled
sc config "TokenBroker" start= disabled
sc config "LicenseManager" start= disabled
sc config "ClipSVC" start= disabled
sc config "FileInfo" start= disabled
sc config "FileCrypt" start= disabled

echo Microsoft Store has been disabled.

pause >nul