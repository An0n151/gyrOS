:: gyrOS ::

:: Power plans

@echo off
setlocal enabledelayedexpansion

set "activePlan="
set "deletePlans="

echo Available power plans:
set "count=0"
for %%F in ("%~dp0\*.pow") do (
    set /a "count+=1"
    echo [!count!] %%~nxF
    set "deletePlans=!deletePlans! !count!"
)

set /p "choice=Enter the number of the power plan to import and activate: "

set "count=0"
for %%F in ("%~dp0\*.pow") do (
    set /a "count+=1"
    if "!count!"=="%choice%" (
        powercfg /import "%%~dpnxF"
        powercfg /setactive "%%~nxF"
        set "activePlan=%%~nxF"
    )
)

echo.
echo Other power plans:
set "count=0"
for %%F in ("%~dp0\*.pow") do (
    set /a "count+=1"
    if not "!count!"=="%choice%" (
        echo %%~nxF
    )
)

echo.
set /p "confirm=Do you want to delete all other power plans? (Y/N): "

if /i "%confirm%"=="Y" (
    echo.
    echo Deleting non-active power plans:
    set "count=0"
    for %%F in (%deletePlans%) do (
        set /a "count+=1"
        if not "!count!"=="%choice%" (
            echo Deleting: %%~nxF
            powercfg /delete "%%~nxF"
        )
    )
    echo.
    echo Deletion completed.
) else (
    echo.
    echo No power plans were deleted.
)

echo.
echo Done.
pause
exit /b