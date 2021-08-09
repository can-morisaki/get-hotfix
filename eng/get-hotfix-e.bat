@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

Write-Host "

=============================================================================================
I acquire a list of applied Security Patch and make "patch-evidence.log" to a desktop.
You must attach "patch-evidence.log" to FlowLites as evidence.
=============================================================================================

"
Write-Host ""


$outfile = [Environment]::GetFolderPath('Desktop')+"\patch-evidence.log"
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$RegKey1 = "ReleaseId"
$RegKey2 = "DisplayVersion"

(Get-WmiObject Win32_OperatingSystem).Caption > $outfile
(Get-ItemProperty $RegPath -name $RegKey1 -ErrorAction SilentlyContinue).$RegKey1 >> $outfile
(Get-ItemProperty $RegPath -name $RegKey2 -ErrorAction SilentlyContinue).$RegKey2 >> $outfile
get-hotfix >> $outfile

gwmi -Computer . -Class Win32_NetworkAdapterConfiguration | Select IPAddress, MACAddress, Caption >> $outfile
Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object{$_.IPEnabled -eq "TRUE"} | Format-List MACAddress >> $outfile

echo "get-hotfix Ver.1.2" >> $outfile

Write-Host "Finished"