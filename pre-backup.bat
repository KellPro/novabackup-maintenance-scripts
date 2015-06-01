@ECHO OFF
SETLOCAL EnableDelayedExpansion
SET "updatePackage=https://github.com/gillsonkell/novabackup-maintenance-scripts/archive/master.zip"
SET "updatePackageFolder=novabackup-maintenance-scripts-master"

REM ### Update Scripts ###
IF NOT [%1] == [no-update] (
	curl -o update.zip -L -k %updatePackage%
	7z x update.zip
	XCOPY .\%updatePackageFolder%\* .\ /C /Q /S /E /H /Y
    RMDIR /S /Q %updatePackageFolder%
    DEL update.zip
	CALL pre-backup.bat no-update
	EXIT /B
)
