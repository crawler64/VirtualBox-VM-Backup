@echo off
CLS
SETLOCAL ENABLEDELAYEDEXPANSION

REM Bitte diese Variablen festlegen
SET VBOXMANAGE="C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
REM Pfad zu den VMs (Einstellung von VirtualBox)
SET "VM_DIR=D:\VirtualBox VMs"
REM Ablageort der exportierten OVAs
SET "BACKUP_DIR=E:\"

REM Extract all vms to backup
for /f tokens^=1^ delims^=^" %%A in ('%VBOXMANAGE% list vms ') do ( 
set VM=%%~A
REM echo "!VM!"
CALL export_vm_ova.bat

)