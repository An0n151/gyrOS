:: ### gyrOS ###

:: Disable Printing

@echo off
setlocal EnableDelayedExpansion

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

devcon disable "=Printer" > nul 2> nul
devcon disable "=PrintQueue" > nul 2> nul

sc config Spooler start= disabled > nul 2> nul

echo Printing has been disabled.

pause >nul