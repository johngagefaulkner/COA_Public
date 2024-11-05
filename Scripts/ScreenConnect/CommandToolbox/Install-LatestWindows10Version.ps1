$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
Clear-Host
Write-Host "[ Install-LatestWindows10Version.ps1 ]"

# Define Variables
## Directory to download the Windows 10 Upgrade Assistant
$dlDir = "C:\WindowsUpgradeAssistant\"
$dlPath = "$($dlDir)\Win10Upgrade.exe"
$dlUrl = "https://go.microsoft.com/fwlink/?LinkID=799445"
$webClient = New-Object System.Net.WebClient

# Create the download directory if it doesn't exist
if (-not (Test-Path -Path $dlDir)) {
    Write-Host "Creating download directory..."
    New-Item -Path $dlDir -ItemType Directory
    Write-Host "Done! Created directory: $($dlDir)"
}

# Download the Windows 10 Upgrade Assistant if it doesn't exist
if (-not (Test-Path -Path $dlPath)) {
    Write-Host "Downloading Windows 10 Upgrade Assistant..."
    $webClient.DownloadFile($dlUrl, $dlPath)
    Write-Host "Done!"
}

# Update to the latest version of Windows 10 via silent/quiet install using the Windows 10 Upgrade Assistant
Write-Host "Starting Windows 10 Upgrade Assistant, this will take a while, please wait... "
Start-Process -FilePath $dlPath -ArgumentList "/quietinstall /skipeula /auto upgrade /copylogs $dlDir"
Write-Host "Done! Windows 10 Upgrade Assistant has initiated the upgrade process!"
