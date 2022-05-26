@ECHO OFF
REM *****************************
rem "D:\Scripts\Scripts_Windows\Dark Mode Toggle\log.txt"
pushd "%CD%"
CD /D "%~dp0"
ECHO ************************ >>log.txt
echo %date%	%time%	Starting AutoThemeMode>> log.txt
:: Put this script to registry into Computador\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run

SET "LightModeStart=0600"
SET "LightModeEnd=1800"

:: GET DATE and TIME
echo %date%	%time%	Getting date and time>> log.txt
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
echo %date%	%time%	Got it>> log.txt
SET "HH=%dt:~8,2%"
SET "min=%dt:~10,2%"
ECHO Light mode start : %LightModeStart%
ECHO Light mode end   : %LightModeEnd%
ECHO Current time     : %HH%%min%
ECHO.
SET "Theme=dark"
REM IF 1%HH%%min% LSS 1%LightModeEnd% IF 1%HH%%min% GTR 1%LightModeStart% SET "Theme=light"
IF 1%HH%%min% LSS 1%LightModeEnd% IF 1%HH%%min% GEQ 1%LightModeStart% SET "Theme=light"
echo %date%	%time%	Theme to apply - %Theme%>> log.txt
:: Check Current Theme Mode
echo %date%	%time%	Check Current Theme>> log.txt
FOR /F "tokens=3* skip=2" %%b in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme"') do SET query=%%b
IF %query%==0x1 set "CurrentTheme=light"
IF %query%==0x0 set "CurrentTheme=dark"
echo %date%	%time%	Current theme - %CurrentTheme%>> log.txt
echo Current theme - %CurrentTheme%
IF %CurrentTheme%==%theme% (
ECHO Nothing to change, exiting...
echo %date%	%time%	Nothing to change, exiting>> log.txt
EXIT /B
)
echo Changing theme to %theme%...
GOTO :task_%theme%

:task_light
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /t REG_DWORD /v AppsUseLightTheme /d 1 /f >>log.txt 2>&1
ECHO. >>log.txt
echo %date%	%time%	Reg 1 changed>> log.txt
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /t REG_DWORD /v SystemUsesLightTheme /d 1 /f >>log.txt 2>&1
ECHO. >>log.txt
echo %date%	%time%	Reg 2 changed>> log.txt
goto :eof

:task_dark
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /t REG_DWORD /v AppsUseLightTheme /d 0 /f >>log.txt 2>&1
ECHO. >>log.txt
echo %date%	%time%	Reg 3 changed>> log.txt
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /t REG_DWORD /v SystemUsesLightTheme /d 0 /f >>log.txt 2>&1
ECHO. >>log.txt
echo %date%	%time%	Reg 4 changed>> log.txt
goto :eof
REM *****************************