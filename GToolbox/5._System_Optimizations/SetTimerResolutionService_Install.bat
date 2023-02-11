:: ### gyrOS SetTimerResolutionService Silent Installation Script ###

@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

%WinDir%\gyrOS\SetTimerResolutionService.exe -install
sc config STR start=auto
net start STR

echo.
echo Service installed and started. Press any key to exit.
echo.

pause >nul