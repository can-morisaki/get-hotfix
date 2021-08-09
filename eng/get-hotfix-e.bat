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
$RegKey = "ReleaseId"

(Get-WmiObject Win32_OperatingSystem).Caption > $outfile
(Get-ItemProperty $RegPath -name $RegKey -ErrorAction SilentlyContinue).$RegKey >> $outfile
get-hotfix >> $outfile

gwmi -Computer . -Class Win32_NetworkAdapterConfiguration | Select IPAddress, MACAddress, Caption >> $outfile
Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object{$_.IPEnabled -eq "TRUE"} | Format-List MACAddress >> $outfile


Write-Host "Finished"