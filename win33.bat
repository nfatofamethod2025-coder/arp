@echo off
setlocal enabledelayedexpansion

REM  --> Check for admin privileges (Windows 10 compatible)
net session >nul 2>&1
if %errorlevel% neq 0 (
    REM Create VBScript to elevate
    (
    echo Set UAC = CreateObject^("Shell.Application"^)
    echo UAC.ShellExecute "%~f0", "", "", "runas", 1
    ) > "%temp%\GetAdmin.vbs"
    
    REM Run the VBScript
    if exist "%temp%\GetAdmin.vbs" (
        cscript //nologo "%temp%\GetAdmin.vbs" >nul 2>&1
        timeout /t 1 /nobreak >nul 2>&1
        del "%temp%\GetAdmin.vbs" >nul 2>&1
    )
    
    REM Exit this instance (elevated instance will continue)
    exit /b
)

REM If we get here, we have admin privileges
cls
echo.
echo.
echo.

REM Create directory if it doesn't exist
if not exist "C:\Windows\RazerEngine64" (
    mkdir "C:\Windows\RazerEngine64" >nul 2>&1
)

cd /d "C:\Windows\RazerEngine64" >nul 2>&1
if errorlevel 1 (
    echo Error: Access denied
    timeout /t 3 /nobreak >nul 2>&1
    exit /b 1
)

REM Download required tools
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://pixeldrain.com/api/file/kS6iDKPk?download' -OutFile 'AMIDEWINx64.exe' -UseBasicParsing" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://pixeldrain.com/api/file/Tvdf9YpH?download' -OutFile 'amigendrv64.sys' -UseBasicParsing" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://pixeldrain.com/api/file/Bp21m3BT?download' -OutFile 'Volumeid64.exe' -UseBasicParsing" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://pixeldrain.com/api/file/JPtnMAcj?download' -OutFile 'amifldrv64.sys' -UseBasicParsing" >nul 2>&1

REM Check if main tool exists before running
if not exist "AMIDEWINx64.exe" (
    echo Error: Component download failed
    timeout /t 3 /nobreak >nul 2>&1
    exit /b 1
)

echo.
echo.

REM Generate random motherboard serial numbers (different on every run)
for /f "delims=" %%A in ('powershell -NoProfile -Command "[guid]::NewGuid().ToString().ToUpper()"') do set "MB_UUID=%%A"
set "MB_UUID_ND=!MB_UUID:-=!"

for /f "delims=" %%A in ('powershell -NoProfile -Command "-join (1..16 | ForEach-Object { '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'[(Get-Random -Maximum 36)] })"') do set "MB_SK=%%A"
for /f "delims=" %%A in ('powershell -NoProfile -Command "-join (1..16 | ForEach-Object { '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'[(Get-Random -Maximum 36)] })"') do set "MB_CSK=%%A"
for /f "delims=" %%A in ('powershell -NoProfile -Command "-join (1..16 | ForEach-Object { '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'[(Get-Random -Maximum 36)] })"') do set "MB_PSN=%%A"
for /f "delims=" %%A in ('powershell -NoProfile -Command "-join (1..16 | ForEach-Object { '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'[(Get-Random -Maximum 36)] })"') do set "MB_PAT=%%A"
for /f "delims=" %%A in ('powershell -NoProfile -Command "-join (1..16 | ForEach-Object { '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'[(Get-Random -Maximum 36)] })"') do set "MB_SS=%%A"
for /f "delims=" %%A in ('powershell -NoProfile -Command "-join (1..16 | ForEach-Object { '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'[(Get-Random -Maximum 36)] })"') do set "MB_BS=%%A"
for /f "delims=" %%A in ('powershell -NoProfile -Command "-join (1..16 | ForEach-Object { '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'[(Get-Random -Maximum 36)] })"') do set "MB_BT=%%A"
for /f "delims=" %%A in ('powershell -NoProfile -Command "-join (1..16 | ForEach-Object { '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'[(Get-Random -Maximum 36)] })"') do set "MB_BLC=%%A"
for /f "delims=" %%A in ('powershell -NoProfile -Command "-join (1..16 | ForEach-Object { '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'[(Get-Random -Maximum 36)] })"') do set "MB_CM=%%A"
for /f "delims=" %%A in ('powershell -NoProfile -Command "-join (1..16 | ForEach-Object { '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'[(Get-Random -Maximum 36)] })"') do set "MB_CV=%%A"
for /f "delims=" %%A in ('powershell -NoProfile -Command "-join (1..16 | ForEach-Object { '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'[(Get-Random -Maximum 36)] })"') do set "MB_CS=%%A"
for /f "delims=" %%A in ('powershell -NoProfile -Command "-join (1..16 | ForEach-Object { '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'[(Get-Random -Maximum 36)] })"') do set "MB_CA=%%A"

REM Comprehensive ASUS motherboard spoofing
AMIDEWINx64.exe /IVN "AMI" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
AMIDEWINx64.exe /SP "System product name" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
AMIDEWINx64.exe /SV "System product name" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
AMIDEWINx64.exe /SS "!MB_SS!" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
AMIDEWINx64.exe /SU "!MB_UUID_ND!" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
AMIDEWINx64.exe /SK "!MB_SK!" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
AMIDEWINx64.exe /BM "AsRock" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
AMIDEWINx64.exe /BP "B560M-C" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
AMIDEWINx64.exe /BS "!MB_BS!" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
AMIDEWINx64.exe /BT "!MB_BT!" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
AMIDEWINx64.exe /BLC "!MB_BLC!" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
AMIDEWINx64.exe /CM "!MB_CM!" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
AMIDEWINx64.exe /CV "!MB_CV!" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
AMIDEWINx64.exe /CS "!MB_CS!" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
AMIDEWINx64.exe /CA "!MB_CA!" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
AMIDEWINx64.exe /CSK "!MB_CSK!" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
AMIDEWINx64.exe /PSN "!MB_PSN!" >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
AMIDEWINx64.exe /PAT "!MB_PAT!" >nul 2>&1

REM Volume serial spoofing for all drives (random on every run)
if exist "Volumeid64.exe" (
    for %%D in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do (
        for /f "delims=" %%S in ('powershell -NoProfile -Command "-join (1..4 | ForEach-Object { '0123456789ABCDEF'[(Get-Random -Maximum 16)] }) + '-' + (-join (1..4 | ForEach-Object { '0123456789ABCDEF'[(Get-Random -Maximum 16)] }))"') do (
            Volumeid64.exe %%D: %%S >nul 2>&1
        )
    )
)

REM Randomize Windows MachineGuid (UUID) so 3rd segment is not 11F1
powershell -NoProfile -ExecutionPolicy Bypass -Command "$g=[guid]::NewGuid().ToString(); Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Cryptography' -Name 'MachineGuid' -Value $g" >nul 2>&1
REM Randomize Hardware Profile GUID too
powershell -NoProfile -ExecutionPolicy Bypass -Command "$g=[guid]::NewGuid().ToString(); Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\IDConfigDB\Hardware Profiles\0001' -Name 'HwProfileGuid' -Value $g" >nul 2>&1

REM Restart WMI service to apply changes
net stop winmgmt /y >nul 2>&1
timeout /t 2 /nobreak >nul 2>&1
net start winmgmt >nul 2>&1

echo.
echo.

REM Clean up downloaded files
if exist "AMIDEWINx64.exe" del "AMIDEWINx64.exe" >nul 2>&1
if exist "amigendrv64.sys" del "amigendrv64.sys" >nul 2>&1
if exist "Volumeid64.exe" del "Volumeid64.exe" >nul 2>&1
if exist "amifldrv64.sys" del "amifldrv64.sys" >nul 2>&1

timeout /t 2 /nobreak >nul 2>&1