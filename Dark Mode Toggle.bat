@echo off
FOR /F "tokens=3* skip=2" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme"') do SET query=%%a
IF %query%==0x1 set newval=0x0
IF %query%==0x0 set newval=0x1
IF "%newval%" == "" exit
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /t REG_DWORD /v AppsUseLightTheme /d %newval% /f >NUL 2>&1
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /t REG_DWORD /v SystemUsesLightTheme /d %newval% /f >NUL 2>&1
exit
