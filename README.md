# novabackup-maintenance-scripts
Simple KDR client maintenance scripts to be run before and after NovaBACKUP jobs.

## Usage
To install, simply download this repository to the client's station and then run configure.bat. You'll then need to open NovaBACKUP, go to the Backup tab, click the settings button, go to the Custom Commands tab and then select pre-backup.bat as the run before script and post-backup.bat as the run after script.

## About The Jobs
pre-backup.bat will do 4 things before a backup job:
* Update itself from this repository.
* Empty any of these directories that exist:
  * C:\KDR\VDATA
  * D:\KDR\VDATA
* Start the following services:
  * Backup Client Agent Service ('Backup Client Agent Service')
  * Microsoft Software Shadow Copy Provider ('swprv')
  * NovaStor NovaStor Backup/Copy Engine ('nsService')
  * Volume Shadow Copy ('VSS')
  * SQL Server Browser ('SQLBrowser')
  * SQL Server VSS Writer ('SQLWriter')
* Erase old backups down to the maximum backup amount configured during the installation.

post-backup.bat groups backup files into folders by day, so that pre-backup.bat can delete days of backups instead of individual backup files.
