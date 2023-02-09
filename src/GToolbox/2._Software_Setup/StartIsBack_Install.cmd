:: ### gyrOS StartIsBack Silent Installation Script ###

@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

"%drive%\ProgramData\Installers\StartAllBack.exe" /S

:start
set choice=
set /p choice=Would you like to delete the StartIsBack installer? [Y or N]: 
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='Y' goto yes
if '%choice%'=='Yes' goto yes
if '%choice%'=='y' goto yes
if '%choice%'=='yes' goto yes
if '%choice%'=='N' goto no
if '%choice%'=='No' goto no
if '%choice%'=='n' goto no
if '%choice%'=='no' goto no
if '%choice%'=='' goto no
echo.
echo "%choice%" is not valid.
echo.
timeout /t 1
goto start

:no
echo Exiting...
timeout /t 1
exit

:yes
del /q %drive%\ProgramData\Installers\StartAllBack.exe
echo.
echo Successfully deleted. You can close this window now.
echo.

pause >nul