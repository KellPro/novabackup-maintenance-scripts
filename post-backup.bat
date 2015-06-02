@ECHO OFF
SETLOCAL EnableDelayedExpansion

CD /D %~dp0
IF EXIST configuration.bat (
	CALL configuration.bat show-message
)

IF EXIST %backupPath% (
	FOR %%f IN ("%backupPath%\*.nbd") DO (
		SET backup=%%f
		FOR %%a IN ("!backup!") DO SET lastModified=%%~ta
		SET modifiedYear=!lastModified:~6,4!
		SET modifiedMonth=!lastModified:~0,2!
		SET modifiedDay=!lastModified:~3,2!
		SET backupDirectory=%backupPath%\nsbackup-!modifiedYear!-!modifiedMonth!-!modifiedDay!
		ECHO !backup! - !backupDirectory!
		IF NOT EXIST "!backupDirectory!" MD "!backupDirectory!"
		MOVE /Y "!backup!" "!backupDirectory!"
	)
)
