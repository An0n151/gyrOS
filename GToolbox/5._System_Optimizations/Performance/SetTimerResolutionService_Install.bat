:: gyrOS ::

:: SetTimerResolutionService Installation Script 

@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

cd "%AppData%\Microsoft\Windows\Start Menu\Programs\Startup"
mklink "Set Timer Resolution.lnk" "%WinDir%\gyrOS\SetTimerResolutionService.exe" --no-console --resolution 5000

echo.
echo Success. Restart your system.
echo.

pause >nul