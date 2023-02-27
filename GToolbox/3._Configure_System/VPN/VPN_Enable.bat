:: gyrOS VPN Enablement Script ::

@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

%WinDir%\gyrOS\DevManView.exe /enable "WAN Miniport (IPv6)"
%WinDir%\gyrOS\DevManView.exe /enable "WAN Miniport (IKEv2)"
%WinDir%\gyrOS\DevManView.exe /enable "WAN Miniport (L2TP)"
%WinDir%\gyrOS\DevManView.exe /enable "WAN Miniport (IP)"
%WinDir%\gyrOS\DevManView.exe /enable "Microsoft RRAS Root Enumerator"
%WinDir%\gyrOS\DevManView.exe /enable "NDIS Virtual Network Adapter Enumerator"

reg add "HKLM\SYSTEM\CurrentControlSet\Services\SstpSvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NdisVirtualBus" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\IKEEXT" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\RasMan" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Eaphost" /v "Start" /t REG_DWORD /d "3" /f

echo.
echo VPN services enabled. Restart your computer.
echo.

pause >nul