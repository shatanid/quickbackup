@echo off
title Auto Backup
echo           --Auto Backup--
echo.

:: Variables
:: Be sure there's no trailing slash!

:: Where is the dir you want to backup?
SET Directory=C:\noxxrp\serverdata

:: Where should the backups be stored?
SET BackupDir=Backup

:: WinRAR or 7Zip?
SET CompressionProgram=7Zip

:: Directory of the Program specified above
SET CompressionProgramDir=C:\Program Files\7-Zip

:: The name of the folder inside the zip
SET ZipFolderName=serverdata

::=======================================================================================::
:: I wouldn't edit anything past here if I were you, but if you want to, go right ahead! ::
::=======================================================================================::

:: Timestamp for backups.
FOR /F "skip=1 tokens=1-6" %%G IN ('WMIC Path Win32_LocalTime Get Day^,Hour^,Minute^,Month^,Second^,Year /Format:table') DO (
	IF "%%~L"=="" goto s_done
	SET _yyyy=%%L
	SET _mm=00%%J
	SET _dd=00%%G
	SET _hour=00%%H
	SET _minute=00%%I
	SET _second=00%%K
)
:s_done

SET _mm=%_mm:~-2%
SET _dd=%_dd:~-2%
SET _hour=%_hour:~-2%
SET _minute=%_minute:~-2%
SET _second=%_second:~-2%

SET LOGTIMESTAMP=__%_dd%-%_mm%-%_yyyy%__%_hour%-%_minute%-%_second%

:: Begin backup
echo.
echo Started copying at %DATE% - %TIME%
echo.

:: Use robocopy with file and folder exclusions
robocopy "%Directory%" "temp\%ZipFolderName%" /E /NFL /NDL /NJH /NJS /NC /NS ^
 /XF *.zip *.7z *.rar ^
 /XD "%Directory%\cache" "%Directory%\[baju]" "%Directory%\[vehicles]"

echo.
echo Finished copying at %DATE% - %TIME%

echo.
echo Starting compression at %DATE% - %TIME%

if /I "%CompressionProgram%"=="WinRAR" (
    goto StartWinRAR
) else if /I "%CompressionProgram%"=="7Zip" (
    goto Start7Zip
) else (
    goto NoProgram
)

:StartWinRAR
"%CompressionProgramDir%\Rar.exe" a -m5 -r -s -t -ep1 -inul "%BackupDir%\backup%LOGTIMESTAMP%.rar" "temp\%ZipFolderName%\" ^
 -x"temp\%ZipFolderName%\[baju]\*" -x"temp\%ZipFolderName%\[vehicles]\*"
goto end

:Start7Zip
"%CompressionProgramDir%\7z.exe" a -m0=lzma2 -mx -r -bb0 "%BackupDir%\backup%LOGTIMESTAMP%.7z" ".\temp\%ZipFolderName%\" ^
 -xr![baju] -xr![vehicles]
goto end

:NoProgram
cls
echo.
echo You did not specify a correct compression program
echo.
pause >nul
goto end

:end
if exist "temp\%ZipFolderName%\" (
    rmdir /s /q "temp\%ZipFolderName%\"
)
echo.
echo ... Finished at %DATE% - %TIME% ...
echo.
echo ... Press Any Key to Exit ...
echo.
pause >nul
exit
