:: ### gyrOS Google Chrome Tweaks ###
:: ### I do not claim to have coded this myself ###
:: ### If you see your code in here and want to be credited, message me on Discord ###

:: ### Credits: DuckOS

@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

title Google Chrome Tweaks

:: Configure Google Chrome
sc config "gupdate" start= demand > nul 2> nul
sc config "gupdatem" start= demand > nul 2> nul
sc config "GoogleChromeElevationService" start= demand > nul 2> nul

reg add "HKLM\SOFTWARE\Policies\Google\Update" /v "UpdateDefault" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Google\Update" /v "DisableAutoUpdateChecksCheckboxValue" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Google\Update" /v "AutoUpdateCheckPeriodMinutes" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "MetricsReportingEnabled" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "ChromeCleanupReportingEnabled" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Wow6432Node\Google\Update" /v "UpdateDefault" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Wow6432Node\Google\Update" /v "DisableAutoUpdateChecksCheckboxValue" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Wow6432Node\Google\Update" /v "AutoUpdateCheckPeriodMinutes" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "1" /t REG_SZ /d "software_reporter_tool.exe" /f

echo.
echo Applied Google Chrome Tweaks. Press any key to exit.
echo.

pause >nul