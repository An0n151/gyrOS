:: gyrOS ::

:: Apply OOSU10 Configuration

@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

%WinDir%\gyrOS\OOSU10.exe %WinDir%\gyrOS\OOSU10.cfg /quiet /nosrp

echo.
echo Success.
echo.

pause >nul