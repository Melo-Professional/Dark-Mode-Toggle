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
setlocal enableDelayedExpansion
set "appname=Dark Mode Auto"
set "menuchoice="
set "menuchoice2="
cls
echo DARK MODE AUTO
echo.
if exist "%appdata%\%appname%\" (
goto Existing
) else (
goto InstallQuestion
)
goto End

:Existing
CHOICE /C ru /N /M "[R] reinstall or [U] uninstall?"
SET menuchoice=%ERRORLEVEL%
IF %menuchoice% EQU 1 goto Reinstall
IF %menuchoice% EQU 2 goto Uninstall
goto End

:Reinstall
rd /s /q "%appdata%\%appname%\"
schtasks /delete /F /TN "Dark Mode Auto"
echo Uninstall complete
echo Reinstalling
goto Install
goto End

:Uninstall
rd /s /q "%appdata%\%appname%\"
del /f /q "%userprofile%\Start Menu\Programs\Dark Mode Toggle.lnk"
schtasks /delete /F /TN "Dark Mode Auto" >nul 2>&1
echo Uninstall complete
goto End

:InstallQuestion
CHOICE /C ie /N /M "[I] Install or [E] Exit?"
SET menuchoice2=%ERRORLEVEL%
IF %menuchoice2% EQU 2 goto End
IF %menuchoice2% EQU 1 (
:Install
md "%appdata%\%appname%"
robocopy . "%appdata%\%appname%" >nul 2>&1
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%userprofile%\Start Menu\Programs\Dark Mode Toggle.lnk');$s.TargetPath='%appdata%\%appname%\Dark Mode Toggle.bat';$s.Save()"
cmd /c "Import Task Schedule.bat"
cmd /c "Apply Theme.bat"
echo Install complete
goto End
)

:End
Echo Done
pause
exit 0

