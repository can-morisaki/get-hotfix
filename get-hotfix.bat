@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

Write-Host "

=============================================================================================
適用されているセキュリティパッチの一覧を取得します。
デスクトップに作成される「パッチ証跡.log」をパッチ適用証跡としてFlowLitesに添付してください。
=============================================================================================

"
Write-Host ""

Write-Host "続行するには何かキーを押してください..."
$host.UI.RawUI.ReadKey()

$outfile = [Environment]::GetFolderPath('Desktop')+"\パッチ証跡.log"
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$RegKey = "ReleaseId"

(Get-WmiObject Win32_OperatingSystem).Caption > $outfile
(Get-ItemProperty $RegPath -name $RegKey -ErrorAction SilentlyContinue).$RegKey >> $outfile
get-hotfix >> $outfile

gwmi -Computer . -Class Win32_NetworkAdapterConfiguration | Select IPAddress, MACAddress, Caption >> $outfile
Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object{$_.IPEnabled -eq "TRUE"} | Format-List MACAddress >> $outfile


Write-Host "ファイル出力が完了しました"