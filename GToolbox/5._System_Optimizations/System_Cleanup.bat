:: ### gyrOS Windows Cleaner ###

@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

del /s /f /q %drive%\Windows\temp\*.*
rd /s /q %drive%\Windows\temp
md %drive%\Windows\temp
del /s /f /q %temp%\*.*
rd /s /q %temp%
md %temp%

del /s /f /q %drive%\Windows\tempor~1
del /s /f /q %drive%\Windows\temp
del /s /f /q %drive%\Windows\tmp
del /s /f /q %drive%\Windows\ff*.tmp
del /s /f /q %drive%\Windows\History
del /s /f /q %drive%\Windows\Cookies
del /s /f /q %drive%\Windows\Recent
del /s /f /q %drive%\Windows\Spool\Printers
del /s /f /q %drive%\Windows\Prefetch\*.*
del /s /f /q %drive%\Windows\Temp\*.*

del /s /f /q %userprofile%\Recent\*.*
del /s /f /q %userprofile%\AppData\Local\temp\*.*

del /s /f /q %localappdata%\Microsoft\Windows\WebCache\*.*

del /s /f /q %SystemRoot%\setupapi.log
del /s /f /q %SystemRoot%\Panther\*
del /s /f /q %SystemRoot%\inf\setupapi.app.log
del /s /f /q %SystemRoot%\inf\setupapi.dev.log
del /s /f /q %SystemRoot%\inf\setupapi.offline.log

echo.
echo Success. Press any key to exit.
echo.

pause >nul