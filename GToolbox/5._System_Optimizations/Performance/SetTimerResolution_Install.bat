:: gyrOS ::

:: SetTimerResolutionService Installation Script 

@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

set link="%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\Set_Timer_Resolution.lnk"
set target="%WinDir%\gyrOS\SetTimerResolution.exe"
set args=--resolution 5000 --no-console

:: Create the symbolic link
mklink %link% %target%

:: Create a shortcut to the batch file in the Startup folder
echo @echo off > "%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\Start_Timer_Resolution.bat"
echo start "" /min %target% %args% >> "%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\Start_Timer_Resolution.bat"

cls

echo Success, please reboot your device for changes to apply.
echo.
pause
exit /b