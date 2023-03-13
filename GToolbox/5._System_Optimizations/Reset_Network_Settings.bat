:: ### gyrOS ###

:: Reset Network Settings

@echo off
setlocal EnableDelayedExpansion

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

netsh winsock reset > nul 2> nul
netsh int ipv4 reset > nul 2> nul
netsh int ipv6 reset > nul 2> nul
ipconfig /release > nul 2> nul
ipconfig /renew > nul 2> nul
ipconfig /flushdns > nul 2> nul

devcon disable =net > nul 2> nul
timeout /t 3 /nobreak > nul 2> nul
devcon enable =net > nul 2> nul

devcon remove =net > nul 2> nul
devcon rescan > nul 2> nul

echo Your network settings have been reset.

pause >nul