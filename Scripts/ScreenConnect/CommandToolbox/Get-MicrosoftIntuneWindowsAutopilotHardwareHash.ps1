$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
Clear-Host

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

New-Item -Type Directory -Path "C:\HWID"
Set-Location -Path "C:\HWID"
$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
Install-Script -Name Get-WindowsAutopilotInfo
Get-WindowsAutopilotInfo -OutputFile AutopilotHWID.csv
# While Windows OOBE runs, open a command prompt, run the PowerShell command then type use the following commands:


PowerShell.exe -ExecutionPolicy Bypass
Install-Script -Name Get-WindowsAutopilotInfo -Force

Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned

Get-WindowsAutopilotInfo -Online

#https://www.nuget.org/Content/gallery/img/microsoft-account.svg
#dotnet add package Microsoft.Graphics.Win2D --version 1.2.0