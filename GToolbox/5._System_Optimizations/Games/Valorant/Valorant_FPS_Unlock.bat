@echo off

reg add "HKLM\SOFTWARE\Riot Games\VALORANT" /v "FrameRateCap" /t REG_SZ /d "0" /f

pause