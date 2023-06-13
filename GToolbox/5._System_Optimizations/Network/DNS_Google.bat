:: gyrOS ::

:: Set Google DNS

@echo off
setlocal EnableDelayedExpansion

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

ipconfig /flushdns

netsh interface ipv4 add dnsservers "Ethernet" address=8.8.8.8 index=1
netsh interface ipv4 add dnsservers "Ethernet" address=8.8.4.4 index=2

netsh interface ipv4 add dnsservers "Wi-Fi" address=8.8.8.8 index=1
netsh interface ipv4 add dnsservers "Wi-Fi" address=8.8.4.4 index=2

cls

echo Success.
echo.
pause
exit /b