@ECHO OFF
SETLOCAL EnableDelayedExpansion

IF EXIST configuration.bat (
	CALL configuration.bat
	ECHO - Current configuration -
	ECHO KDR Client ID: !kdrClientId!
	ECHO Backup Path: !backupPath!
	ECHO Maximum Days of Backups: !backupDays!
	ECHO -
	ECHO.
)

:getKdrClientId
SET /P "kdrClientId=KDR Client ID: "
IF [%kdrClientId%] == [] (
	ECHO Please enter a valid KDR Client ID.
	goto getKdrClientId
)

:getBackupPath
SET /P "backupPath=Backup Path (X:\): "
IF [%backupPath%] == [] (
	SET "backupPath=X:\"
)
IF NOT EXIST !backupPath! (
	ECHO The backup path you entered could not be found on this computer.
	goto getBackupPath
)

:getBackupDays
SET /P "backupDays=Maximum days of backups (5): "
IF [%backupDays%] == [] (
	SET "backupDays=5"
)

ECHO SET "kdrClientId=%kdrClientId%"> configuration.bat
ECHO SET "backupPath=%backupPath%">> configuration.bat
ECHO SET "backupDays=%backupDays%">> configuration.bat
ECHO Configuration successful.
