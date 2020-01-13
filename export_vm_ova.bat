@ECHO OFF
CLS

REM Script taken from https://forums.virtualbox.org/viewtopic.php?f=1&t=34940
 
SET ERROR=0
SET RUNNING_INICIAL=2
 
ECHO Starting backup VM "%VM%"...
 
:check_running
%VBOXMANAGE% list runningvms > %TEMP%\runningvms.txt
FIND "%VM%" %TEMP%\runningvms.txt > nul
 
IF %errorlevel% EQU 0 (
    SET RUNNING_INICIAL=1
) ELSE (
    SET RUNNING_INICIAL=0
)
 
DEL %TEMP%\runningvms.txt
 
IF %RUNNING_INICIAL% EQU 1 (
    ECHO Saving state VM "%VM%"...
    %VBOXMANAGE% controlvm "%VM%" savestate
 
    IF %errorlevel% NEQ 0 (
        SET ERROR=1
        GOTO end
    )
)
 
:export_vm
ECHO Exporting VM "%VM%"...
TIMEOUT /t 3 /nobreak > nul
SET FECHA=%DATE:~6,4%-%DATE:~3,2%-%DATE:~0,2%
%VBOXMANAGE% export "%VM%" -o "%BACKUP_DIR%%VM% %FECHA%.ova"
 
IF %errorlevel% NEQ 0 (
    SET ERROR=2
    GOTO end
)
 
:start_vm
IF %RUNNING_INICIAL% EQU 1 (
    ECHO Starting VM "%VM%"...
    %VBOXMANAGE% startvm "%VM%"
     
    IF %errorlevel% NEQ 0 (
        SET ERROR=3
        GOTO end
    )
)
 
:end
IF %ERROR% GTR 0 (
    ECHO Error ^(%ERROR%^) while creating backup VM "%VM%".
) ELSE (
    ECHO Backup finished OK.
)