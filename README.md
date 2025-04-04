# quickbackup

:: Where is the dir you want to backup?
SET Directory=(Where Ur Dir)

:: Where should the backups be stored?
SET BackupDir=(Where Backup Dir)

:: WinRAR or 7Zip?
SET CompressionProgram=7Zip

:: Directory of the Program specified above
SET CompressionProgramDir=C:\Program Files\7-Zip

:: The name of the folder inside the zip
SET ZipFolderName=(Name Folder inside zip)

:: Use robocopy with file and folder exclusions
robocopy "%Directory%" "temp\%ZipFolderName%" /E /NFL /NDL /NJH /NJS /NC /NS ^
 /XF *.zip *.7z *.rar ^
 /XD "%Directory%\(Folder Exclude)"
