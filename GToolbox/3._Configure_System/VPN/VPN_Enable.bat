:: gyrOS VPN Enablement Script ::

@echo off

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

echo VPN services enabled. Restart your computer.

pause