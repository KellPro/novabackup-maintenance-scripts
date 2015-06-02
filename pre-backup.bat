@ECHO OFF
SETLOCAL EnableDelayedExpansion
SET updatePackage=https://github.com/gillsonkell/novabackup-maintenance-scripts/archive/master.zip
SET updatePackageDirectory=novabackup-maintenance-scripts-master
SET vdataLocations="C:\kdr\vdata" "D:\kdr\vdata"
SET services="Backup Client Agent Service" "swprv" "nsService" "VSS" "SQLBrowser" "SQLWriter"

CD /D %~dp0
IF EXIST configuration.bat (
	IF "%1" == "no-update" (
		CALL configuration.bat
	) ELSE (
		CALL configuration.bat show-message
	)
)

REM ### Update Scripts ###
IF NOT "%1" == "no-update" (
	curl -o update.zip -L -k %updatePackage%
	unzip update.zip
	XCOPY .\%updatePackageDirectory%\* .\ /C /Q /S /E /H /Y
    RD /S /Q %updatePackageDirectory%
    DEL update.zip
	CALL pre-backup.bat no-update
	EXIT /B
)

REM ### Empty VDATA Directories ###
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
	FOR /D %%f IN ("%backupPath%\nsbackup-*") DO (
		SET /A fileCount+=1
	)
	FOR /D %%f IN ("%backupPath%\nsbackup-*") DO (
		IF !fileCount! GEQ %backupDays% (
			ECHO Erasing old backup: %%f
			RD /S /Q "%%f"
		)
		SET /A fileCount-=1
	)
)
