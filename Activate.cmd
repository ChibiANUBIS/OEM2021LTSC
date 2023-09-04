@echo off
title Windows Activation
cls
REM Used After OEM SLIC Activation
REM Supported editions are activated, if detected unsupported edition Infinite Rearm is installed
REM Supported products by activators
set WindowsLoader=(Starter StarterE HomeBasic HomePremium HomePremiumE Professional ProfessionalE Ultimate UltimateE)
set EzWindSLIC=(Starter StarterE HomeBasic HomePremium HomePremiumE Professional ProfessionalE Ultimate UltimateE)
set KMS=(Professional ProfessionalE ProfessionalN Enterprise EnterpriseE EnterpriseN Embedded)
set Rearm=(StarterN HomeBasicE HomeBasicN HomePremiumN UltimateN)
REM Get Windows Edition
for /f "tokens=3 delims=: " %%i in ('dism /english /online /get-currentedition ^| find /i "Current Edition : "') do set EditionName=%%i
REM Get DVD / USB
FOR %%I IN (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO IF EXIST %%I:\sources\install.esd SET DRIVE=%%I:
IF "%DRIVE%" == "" FOR %%I IN (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO IF EXIST %%I:\sources\install.wim SET DRIVE=%%I:
IF "%DRIVE%" == "" FOR %%I IN (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO IF EXIST %%I:\sources\install.swm SET DRIVE=%%I:
REM Windows Loader
call :GetActStatus
for %%i in %WindowsLoader% do (
    if "%EditionName%" == "%%i" (
        REM Activation using Windows Loader
        "%DRIVE%\support\Loader\WindowsLoader.exe" /silent /preactivate /norestart
    )
)
REM EzWindSLIC - UEFI Windows Loader
call :GetActStatus
for %%i in %EzWindSLIC% do (
    if "%EditionName%" == "%%i" (
        REM Activation using EzWindSLIC
        "%WinDir%\System32\wscript.exe" //nologo "%WinDir%\setup\scripts\invisible.vbs" "%DRIVE%\support\EzWindSLIC\install.bat" /s /norestart
    )
)
REM KMS
call :GetActStatus
for %%i in %KMS% do (
    if "%EditionName%" == "%%i" (
        REM Activation using KMS
        "%WinDir%\System32\wscript.exe" //nologo "%WinDir%\setup\scripts\invisible.vbs" "%DRIVE%\support\KMS\Activate.cmd" /s 
    )
)
REM Infinite REARM
call :GetActStatus
REM Applying IR7 - 30day infinite trial
"%WinDir%\System32\wscript.exe" //nologo "%WinDir%\setup\scripts\invisible.vbs" "%DRIVE%\support\Rearm\RearmWizard.cmd" /s 
goto :EOF
:GetActStatus
REM 0=Unlicensed
REM 1=Licensed
REM 2=OOBGrace
REM 3=OOTGrace
REM 4=NonGenuineGrace
REM 5=Notification
REM 6=ExtendedGrace
for /f "tokens=2 delims==" %%i in ('"wmic path SoftwareLicensingProduct where (PartialProductKey is not null and ApplicationID='55c92734-d682-4d71-983e-d6ec3f16059f') get LicenseStatus /value"') do set ActStatus=%%i
if "%ActStatus%" == "1" exit
goto :EOF