<#
    To install the script directly and capture the hardware hash from the local computer, run the following commands from an elevated Windows PowerShell prompt.
#>
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
Clear-Host
Write-Host "Registering device with Intune Autopilot, please wait..."


[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
New-Item -Type Directory -Path "C:\HWID"
Set-Location -Path "C:\HWID"
$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
Install-Script -Name Get-WindowsAutopilotInfo
Get-WindowsAutopilotInfo -OutputFile AutopilotHWID.csv
