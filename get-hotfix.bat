@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

Write-Host "

=============================================================================================
�K�p����Ă���Z�L�����e�B�p�b�`�̈ꗗ���擾���܂��B
�f�X�N�g�b�v�ɍ쐬�����u�p�b�`�ؐ�.log�v���p�b�`�K�p�ؐՂƂ���FlowLites�ɓY�t���Ă��������B
=============================================================================================

"
Write-Host ""

Write-Host "���s����ɂ͉����L�[�������Ă�������..."
$host.UI.RawUI.ReadKey()

$outfile = [Environment]::GetFolderPath('Desktop')+"\�p�b�`�ؐ�.log"
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$RegKey = "ReleaseId"

(Get-WmiObject Win32_OperatingSystem).Caption > $outfile
(Get-ItemProperty $RegPath -name $RegKey -ErrorAction SilentlyContinue).$RegKey >> $outfile
get-hotfix >> $outfile

gwmi -Computer . -Class Win32_NetworkAdapterConfiguration | Select IPAddress, MACAddress, Caption >> $outfile
Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object{$_.IPEnabled -eq "TRUE"} | Format-List MACAddress >> $outfile


Write-Host "�t�@�C���o�͂��������܂���"