$ProgressPreference = "SilentlyContinue"
$ErrorActionPreference = "Stop"
$script:flag = 0

# QID 370177 CVE-2016-7855 EOL Adobe Flash Player
# This script was pulled from the Qualys "Custom Assessment and Remediation (CAR)" module.

# Function to check Adobe Flash Player
function CheckFlashPlayer {
    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $apps = Get-ChildItem -Path $RegPath | Get-ItemProperty

    foreach ($app in $apps) {
        $appName = $app.DisplayName
        if ($appName -match "Flash") {
            $script:flag++
            UninstallFlashPlayer
        }
    }
}

# Function to uninstall Adobe Flash Player
function UninstallFlashPlayer {
    if ($script:flag -eq 1) {
        Write-Host "$appName is installed"
        Write-Host "Uninstalling Flash Player"

        try {
            # Download the Flash Player Uninstaller
            $uninstallerUrl = "https://fpdownload.macromedia.com/get/flashplayer/current/support/uninstall_flash_player.exe"
            $uninstallerPath = "$env:TEMP\uninstall_flash_player.exe"
            Invoke-WebRequest -Uri $uninstallerUrl -OutFile $uninstallerPath

            # Run the Flash Player Uninstaller
            Start-Process -FilePath $uninstallerPath -ArgumentList "/uninstall" -Wait

            # Clean up the downloaded uninstaller
            Remove-Item -Path $uninstallerPath -Force

            # Re-check for Flash Player
            CheckFlashPlayer
        }
        catch {
            Write-Host "Failed to download or run the Flash Player Uninstaller."
            $script:flag = 404
            exit 404
        }
    }
    elseif ($script:flag -gt 1) {
        Write-Host "Failed to uninstall Flash Player."
        exit 2
    }
}

CheckFlashPlayer

if ($script:flag -eq 0) {
    Write-Host "Flash Player is not installed."
}
elseif ($script:flag -eq 1) {
    Write-Host "Flash Player has been uninstalled."
    exit 1
}
