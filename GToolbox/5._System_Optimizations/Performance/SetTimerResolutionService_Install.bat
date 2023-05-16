:: gyrOS ::

:: SetTimerResolutionService Installation Script 

@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

mklink "%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\Set_Timer_Resolution.lnk" "%WinDir%\gyrOS\SetTimerResolutionService.exe"

echo.
echo Success. Restart your system.
echo.

pause >nul