:: ### gyrOS Audio Latency Reducer Service Installer ###

:: Credits to HoneCtrl

@echo off

%WinDir%\gyrOS\nssm.exe install LLAudio "%WinDir%\gyrOS\REAL.exe"
%WinDir%\gyrOS\nssm.exe set LLAudio DisplayName Audio Latency Reducer Service
%WinDir%\gyrOS\nssm.exe set LLAudio Description Reduces Audio Latency
%WinDir%\gyrOS\nssm.exe set LLAudio Start SERVICE_AUTO_START
%WinDir%\gyrOS\nssm.exe set LLAudio AppAffinity 1
%WinDir%\gyrOS\nssm.exe set LLAudio start SERVICE_AUTO_START
%WinDir%\gyrOS\nssm.exe start LLAudio

echo Success. Press any key to exit.

pause >nul