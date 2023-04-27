@echo off
setlocal

:: Set the GitHub repository information
set "filename=gyrOS_22H2.bat"

:: Set the local file path
set "localpath=%~dp0%filename%"

:: Run the latest version
ping 8.8.8.8 -n 1 -w 1000 > nul 2> nul
if %errorlevel% == 0 (
	echo Downloading latest script version...
	curl -s -L -o "%localpath%" "https://raw.githubusercontent.com/An0n151/gyrOS/main/source/gyrOS_22H2.bat"
	%WinDir%\gyrOS\NSudo\NSudoLG.exe -U:C -P:E -Wait "%localpath%"
) else (
	echo You are offline. Using offline script version...
	%WinDir%\gyrOS\NSudo\NSudoLG.exe -U:C -P:E -Wait "%drive%\Windows\gyrOS_22H2.bat"
)

exit