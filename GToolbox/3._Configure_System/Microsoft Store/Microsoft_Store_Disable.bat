:: ### gyrOS ###

:: Disable Microsoft Store

@echo off

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d "1" /f

sc config "InstallService" start= disabled
sc config "WinHttpAutoProxySvc" start= disabled
sc config "wlidsvc" start= disabled
sc config "AppXSvc" start= disabled
sc config "TokenBroker" start= disabled
sc config "LicenseManager" start= disabled
sc config "ClipSVC" start= disabled
sc config "FileInfo" start= disabled
sc config "FileCrypt" start= disabled

echo Microsoft Store has been disabled.

pause