@echo off
setlocal enabledelayedexpansion

:: Generate a list of current disks
echo Generating list of available disks...
echo LIST DISK > %temp%\ListDisks.txt
diskpart /s %temp%\ListDisks.txt > %temp%\AvailableDisks.txt
type %temp%\AvailableDisks.txt
del %temp%\ListDisks.txt
del %temp%\AvailableDisks.txt

:: Ask the user to select a disk
echo.
:DiskPrompt
set /p DiskNum=Enter the Disk Number to format (or type EXIT to quit): 
if /i "%DiskNum%"=="EXIT" goto :eof
if "%DiskNum%"=="" goto DiskPrompt

:: Confirm the user's choice
echo You have selected Disk %DiskNum%. 
echo IMPORTANT: All data on this disk will be erased!
echo.
set /p Confirm=Are you sure you want to continue? (Y/N): 
if /i "%Confirm%" neq "Y" goto :eof

:: Prepare the Diskpart script
echo Preparing to format Disk %DiskNum%...
echo SELECT DISK %DiskNum% > %temp%\DiskpartScript.txt
echo CLEAN >> %temp%\DiskpartScript.txt
echo CREATE PARTITION PRIMARY >> %temp%\DiskpartScript.txt
echo FORMAT FS=FAT32 QUICK >> %temp%\DiskpartScript.txt
echo ASSIGN >> %temp%\DiskpartScript.txt
echo EXIT >> %temp%\DiskpartScript.txt

:: Execute the Diskpart script
diskpart /s %temp%\DiskpartScript.txt

:: Clean up
del %temp%\DiskpartScript.txt
echo.
echo Disk %DiskNum% has been successfully formatted.
echo.

endlocal
pause
