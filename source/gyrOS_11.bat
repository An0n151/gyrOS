:: ### gyrOS Optimization Script ###

:: ### Credits: EchoX, HoneCtrl, ArtanisInc, Rikey, DuckOS, Melody

@echo off
setlocal EnableDelayedExpansion
title gyrOS Post Installation Script %VERSION%

set "VERSION=23.4.1"
set "SCRIPT_VERSION_DATE=29/03/2023"

:: Configure Variables
set "currentuser=%WinDir%\gyrOS\NSudo\NSudoLG.exe -U:C -P:E -Wait"
set "PowerShell=%WinDir%\System32\WindowsPowerShell\v1.0\PowerShell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command"

::sc config = boot, or = system, or = auto, or = demand, or = disabled, or = delayed-auto

echo _____________________________________________________________________________________________________
echo.
echo  THANK YOU FOR INSTALLING GYROS 11 %VERSION%. PRESS ANY KEY TO START APPLYING GYROS OPTIMIZATIONS.
echo.
echo  DO NOT CLOSE THIS WINDOW UNTIL YOU ARE PROMPTED TO RESTART.
echo _____________________________________________________________________________________________________
echo.
pause
cls

echo _______________
echo.
echo  GETTING READY
echo _______________
echo.

:: Turn on Automatic Time Update ; Credits to DuckOS
%WinDir%\System32\SystemSettingsAdminFlows.exe SetInternetTime 1 > nul 2> nul

:: Turn on Automatic Time Zone Update ; Credits to DuckOS
start "" "%WinDir%\System32\SystemSettingsAdminFlows.exe" SetAutoTimeZoneUpdate 1 > nul 2> nul

:: Force Sync the Time with the Internet Time ; Credits to DuckOS
start "" "%WinDir%\System32\SystemSettingsAdminFlows.exe" ForceTimeSync 1 > nul 2> nul

timeout /t 1 >nul

:: ============================== ::
::       INSTALL SOFTWARE         ::
:: ============================== ::

echo _____________________
echo.
echo  INSTALLING SOFTWARE
echo _____________________
echo.
echo.
echo.
echo.

:VisualCPP
echo ____________________________________________
echo.
echo  INSTALLING VISUAL CPP REDISTRIBUTABLES 1/2
echo ____________________________________________
echo.
"%WinDir%\gyrOS\VisualCppRedist_AIO.exe" /ai


echo ________________________
echo.
echo  INSTALLING DIRECTX 2/2
echo ________________________
echo.
ping 8.8.8.8 -n 1 -w 1000 > nul 2> nul
if %errorlevel% == 0 (
:DirectX
start /wait "" "%WinDir%\gyrOS\DirectX.exe" /q

) else (
echo No internet connection detected. Skipping DirectX installation.
echo.
echo Install DirectX manually using GToolbox.
timeout /t 3 >nul
)

echo ______________________________
echo.
echo  FINISHED INSTALLING SOFTWARE
echo ______________________________
echo.

timeout /t 1 >nul

:: Delete Post Setup Files
del /f /q %WinDir%\gyrOS\VisualCppRedist_AIO.exe > nul 2> nul
del /f /q %WinDir%\gyrOS\DirectX.exe > nul 2> nul

echo __________________________
echo.
echo  DO NOT CLOSE THIS WINDOW
echo __________________________
echo.

timeout /t 2 >nul


echo _______________________________
echo.
echo  RESTART REQUIRED, PLEASE WAIT
echo _______________________________

timeout /t 3 >nul

echo _______________________________________________________________________________________
echo.
echo                                   ===== IMPORTANT =====
echo.
echo  MAKE SURE TO CLICK "CLOSE" WHEN THE RESTART WINDOW POPS UP. PRESS ANY KEY TO CONTINUE
echo _______________________________________________________________________________________
echo.
pause

echo __________________________________________________________________________________________
echo.
echo                                 ===== RESTARTING IN =====
echo __________________________________________________________________________________________

timeout /t 4 >nul
shutdown /r /t 10 /f