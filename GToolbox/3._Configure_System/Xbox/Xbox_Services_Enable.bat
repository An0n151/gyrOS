:: ### gyrOS ###

:: Enable Xbox Services

@echo off
setlocal EnableDelayedExpansion

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

reg add "HKLM\SYSTEM\CurrentControlSet\Services\XblAuthManager" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\XboxNetApiSvc" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\xbgm" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WlidSvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WpnService" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WpnUserService" /v "Start" /t REG_DWORD /d "2" /f

sc config "XblAuthManager" start= auto
sc config "XboxGipSvc" start= demand
sc config "XblGameSave" start= demand
sc config "XboxNetApiSvc" start= auto
sc config "xbgm" start= demand
sc config "WpnService" start= auto
sc config "WpnUserService" start= auto
sc config "WlidSvc" start= demand

schtasks /Change /Enable /TN "Microsoft\XblGameSave\XblGameSaveTask"
schtasks /Change /Enable /TN "Microsoft\XblGameSave\XblGameSaveTaskLogon"

echo.
echo Xbox services have been enabled.
echo.

pause >nul