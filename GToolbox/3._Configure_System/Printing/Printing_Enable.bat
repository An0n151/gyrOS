:: gyrOS ::

:: Enable Printing

@echo off
setlocal EnableDelayedExpansion

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

sc config "Spooler" start= auto
sc config "PrintNotify" start= demand
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PrintWorkflowUserSvc" /v "Start" /t REG_DWORD /d "3" /f

echo.
echo Printing has been enabled.
echo.
echo Install your printer driver, then restart your computer.
echo.

pause >nul