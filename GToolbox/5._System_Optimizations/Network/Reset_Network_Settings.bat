:: gyrOS ::

:: Reset Network Settings

@echo off
setlocal EnableDelayedExpansion

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

netsh winsock reset
netsh int ipv4 reset
netsh int ipv6 reset
ipconfig /release
ipconfig /renew
ipconfig /flushdns

devcon disable =net
timeout /t 3 /nobreak
devcon enable =net

devcon remove =net
devcon rescan

echo Your network settings have been reset.

pause >nul