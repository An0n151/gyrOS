:: ### gyrOS ###

@ECHO OFF

"%drive%\ProgramData\Installers\StartAllBack.exe" /S

:start
SET choice=
SET /p choice=Would you like to delete the StartIsBack installer? [Y or N]: 
IF NOT '%choice%'=='' SET choice=%choice:~0,1%
IF '%choice%'=='Y' GOTO yes
IF '%choice%'=='y' GOTO yes
IF '%choice%'=='N' GOTO no
IF '%choice%'=='n' GOTO no
IF '%choice%'=='' GOTO no
ECHO "%choice%" is not valid
ECHO.
GOTO start

:no
ECHO Exiting...
EXIT

:yes
del /q %drive%\ProgramData\Installers\StartAllBack.exe
ECHO Deleted installer and exiting...
PAUSE
EXIT