:: ### gyrOS ###

:: Enable Microsoft Store

@echo off

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d "0" /f

sc config "InstallService" start= demand
sc config "WinHttpAutoProxySvc" start= demand
sc config "wlidsvc" start= demand
sc config "AppXSvc" start= demand
sc config "TokenBroker" start= demand
sc config "LicenseManager" start= demand
sc config "ClipSVC" start= demand
sc config "FileInfo" start= boot
sc config "FileCrypt" start= system

echo Microsoft Store has been enabled.

pause