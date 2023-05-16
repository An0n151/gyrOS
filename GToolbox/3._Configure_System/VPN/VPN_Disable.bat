:: gyrOS ::

:: Disable VPN

@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

for %%i in (
	"WAN Miniport (Network Monitor)"
	"WAN Miniport (PPPOE)"
	"WAN Miniport (PPTP)"
	"WAN Miniport (SSTP)"
	"WAN Miniport (IPv6)"
	"WAN Miniport (IKEv2)"
	"WAN Miniport (L2TP)"
	"WAN Miniport (IP)"
	"Microsoft RRAS Root Enumerator"
	"NDIS Virtual Network Adapter Enumerator"
) do (
	start "" "%WinDir%\gyrOS\DevManView.exe" /disable %%i
)

reg add "HKLM\SYSTEM\CurrentControlSet\Services\SstpSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NdisVirtualBus" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\IKEEXT" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\RasMan" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Eaphost" /v "Start" /t REG_DWORD /d "4" /f

echo.
echo VPN services disabled. Restart your computer.
echo.

pause >nul