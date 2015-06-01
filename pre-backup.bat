@ECHO OFF
SETLOCAL EnableDelayedExpansion
SET "updatePackage=https://github.com/gillsonkell/novabackup-maintenance-scripts/archive/master.zip"
SET "updatePackageFolder=novabackup-maintenance-scripts-master"
SET vdataLocations="C:\kdr\vdata" "D:\kdr\vdata"
SET services="Backup Client Agent Service" "swprv" "nsService" "VSS" "SQLBrowser" "SQLWriter"

IF EXIST configuration.bat (
	CALL configuration.bat
	SET backupPath=!backupPath:"=!
	IF NOT [%1] == [no-update] (
		ECHO.
		ECHO - Current configuration -
		ECHO KDR Client ID: !kdrClientId!
		ECHO Backup Path: !backupPath!
		ECHO Maximum Days Of Backups: !backupDays!
		ECHO -
		ECHO.
	)
)

REM ### Update Scripts ###
IF NOT [%1] == [no-update] (
	curl -o update.zip -L -k %updatePackage%
	7z x update.zip
	XCOPY .\%updatePackageFolder%\* .\ /C /Q /S /E /H /Y
    RD /S /Q %updatePackageFolder%
    DEL update.zip
	CALL pre-backup.bat no-update
	EXIT /B
)

REM ### Empty VDATA Folders ###
FOR %%f IN (%vdataLocations%) DO (
	IF EXIST %%f (
		ECHO Emptying %%f...
		RD /S /Q %%f
		MD %%f
	)
)

REM ### Start Services ###
FOR %%s IN (%services%) DO (
	net start %%s
)

REM ### Erase Old Backups ###
IF EXIST "%backupPath%" (
	SET fileCount=0
	FOR /D %%f IN ("!backupPath!\nsbackup-*") DO (
		SET /A fileCount+=1
	)
	FOR /D %%f IN ("%backupPath%\nsbackup-*") DO (
		IF !fileCount! GEQ !backupDays! (
			ECHO Erasing old backup: %%f
			RD /S /Q "%%f"
		)
		SET /A fileCount-=1
	)
)
