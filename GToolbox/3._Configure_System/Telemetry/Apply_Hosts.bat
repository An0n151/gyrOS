:: gyrOS ::

:: Apply MVPS Hosts

@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

curl -l -s https://winhelp2002.mvps.org/hosts.txt -o %SystemRoot%\System32\drivers\etc\hosts.temp
if exist %SystemRoot%\System32\drivers\etc\hosts.temp (
    cd %SystemRoot%\System32\drivers\etc
    del /f /q hosts
    ren hosts.temp hosts
)

echo.
echo Success.
echo.

pause >nul