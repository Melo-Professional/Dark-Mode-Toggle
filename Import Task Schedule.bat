@echo off
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select "Run as administrator".
        pause & exit 1
    )
    exit 0
)
pushd "%CD%"
CD /D "%~dp0"

echo.>tmp
schtasks /create /ru %userdomain%\%username% /TN "Dark Mode Auto" /XML "Task Schedule Template.xml" <tmp && (
cls
echo Done
del /f /q tmp
exit 0
) || (
echo Error importing
pause
del /f /q tmp
exit 1
)
