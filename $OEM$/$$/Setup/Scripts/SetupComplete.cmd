@echo off
title Windows Activation
cls
setlocal enabledelayedexpansion
REM Used After OEM SLIC Activation
REM Supported products by activators
set KMS=(EnterpriseS)
set HWID=(IoTEnterpriseS)
REM Get Windows Edition
for /F "tokens=1,2*" %%I in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID 2^>nul') do set "EditionName=%%K"
REM KMS
call :GetActStatus
for %%i in %KMS% do (
    if "%EditionName%" == "%%i" (
        REM Activation using KMS
        "%WINDIR%\Setup\Scripts\KMS38_Activation.cmd" /KMS38 
	RD /s /q "%WINDIR%\Setup\Scripts"
	exit
    )
)
REM HWID
call :GetActStatus
for %%i in %HWID% do (
    if "%EditionName%" == "%%i" (
        REM Activation using HWID
        "%WINDIR%\Setup\Scripts\HWID_Activation.cmd" /HWID
	RD /s /q "%WINDIR%\Setup\Scripts"
	exit
    )
)
:GetActStatus
REM 0=Unlicensed
REM 1=Licensed
REM 2=OOBGrace
REM 3=OOTGrace
REM 4=NonGenuineGrace
REM 5=Notification
REM 6=ExtendedGrace
for /f "tokens=2 delims==" %%b in ('"wmic path SoftwareLicensingProduct where (PartialProductKey is not null) get PartialProductKey /value"') do (
  for /f "tokens=2 delims==" %%d in ('"wmic path SoftwareLicensingProduct where (PartialProductKey='%%b') get LicenseStatus /value"') do (
    set /a LicStatus=%%d
if !LicStatus!==1 exit
 )
)
goto :EOF