@ECHO OFF
SETLOCAL EnableDelayedExpansion

IF EXIST configuration.bat (
	CALL configuration.bat show-message
)

:getKdrClientId
SET /P kdrClientId=KDR Client ID: 
IF [%kdrClientId%] == [] (
	ECHO Please enter a valid KDR Client ID.
	GOTO getKdrClientId
)

:getBackupPath
SET /P backupPath=Backup Path (X:\): 
IF [%backupPath%] == [] (
	SET backupPath=X:\
)
IF NOT EXIST %backupPath% (
	ECHO The backup path you entered could not be found on this computer.
	GOTO getBackupPath
)
SET backupPath=%backupPath:"=%

:getBackupDays
SET /P backupDays=Maximum days of backups (5): 
IF [%backupDays%] == [] (
	SET backupDays=5
)

> configuration.bat ECHO SET kdrClientId=%kdrClientId%
>> configuration.bat ECHO SET backupPath=%backupPath%
>> configuration.bat ECHO SET backupDays=%backupDays%
>> configuration.bat ECHO IF [%%1] == [show-message] (
>> configuration.bat ECHO ECHO.
>> configuration.bat ECHO ECHO - Current configuration -
>> configuration.bat ECHO ECHO KDR Client ID: %%kdrClientId%%
>> configuration.bat ECHO ECHO Backup Path: %%backupPath%%
>> configuration.bat ECHO ECHO Maximum Days Of Backups: %%backupDays%%
>> configuration.bat ECHO ECHO -
>> configuration.bat ECHO ECHO.
>> configuration.bat ECHO )

ECHO Configuration successful.
