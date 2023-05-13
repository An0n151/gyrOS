:: gyrOS ::

:: AMD CPU Tweaks

@echo off
setlocal EnableDelayedExpansion

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

:: Optimizations
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DistributeTimers" /t REG_DWORD /d "1" /f
:: Disable TSX
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableTsx" /t REG_DWORD /d "1" /f
:: Disable Power Saving
for %%i in (WakeEnabled WdkSelectiveSuspendEnable) do (
	for /f "delims=" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class" /s /f "%%~i" ^| findstr "HKEY"') do (
		reg add "%%a" /v "%%~i" /t REG_DWORD /d "0" /f
	)
)

echo.
echo Success.
echo.

pause >nul
