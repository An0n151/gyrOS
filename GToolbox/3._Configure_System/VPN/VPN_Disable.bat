:: gyrOS VPN Disablement Script ::

@echo off

%WinDir%\gyrOS\DevManView.exe /disable "WAN Miniport (IPv6)"
%WinDir%\gyrOS\DevManView.exe /disable "WAN Miniport (IKEv2)"
%WinDir%\gyrOS\DevManView.exe /disable "WAN Miniport (L2TP)"
%WinDir%\gyrOS\DevManView.exe /disable "WAN Miniport (IP)"
%WinDir%\gyrOS\DevManView.exe /disable "Microsoft RRAS Root Enumerator"
%WinDir%\gyrOS\DevManView.exe /disable "NDIS Virtual Network Adapter Enumerator"

reg add "HKLM\SYSTEM\CurrentControlSet\Services\SstpSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NdisVirtualBus" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\IKEEXT" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\RasMan" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Eaphost" /v "Start" /t REG_DWORD /d "4" /f


echo VPN services disabled. Restart your computer.

pause