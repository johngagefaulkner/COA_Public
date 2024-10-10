# Run PowerShell as Administrator
$ProgressPreference = 'SilentlyContinue'
# Set ErrorActionPreference to Stop to treat all errors as terminating
$ErrorActionPreference = 'Stop'

Clear-Host
Write-Host "[ Remove-AzureAD.ps1 ]"
Write-Host "Removing Azure AD Join and related settings..."

# Script to remove Azure AD Join and related settings
try {
    # 1. Leave Azure AD
    dsregcmd /leave
    Write-Host "Successfully left Azure AD."
}
catch {
    Write-Error "Failed to leave Azure AD: $_"
    # Optionally, exit the script or handle the error as needed

    Write-Host "Exiting script due to failure to complete the first step..."
    exit 1
}

# 2. Remove relevant registry keys
$keysToDelete = @(
    "HKLM:\SOFTWARE\Microsoft\Enrollments",
    "HKLM:\SOFTWARE\Microsoft\Enrollments\Status",
    "HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers",
    "HKLM:\SOFTWARE\Microsoft\DeviceManageabilityCSP",
    "HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Accounts"
)
foreach ($key in $keysToDelete) {
    try {
        if (Test-Path $key) {
            Remove-Item -Path $key -Recurse -Force
            Write-Host "Deleted: $key"
        }
        else {
            Write-Host "Key not found: $key"
        }
    }
    catch {
        Write-Error "Failed to delete registry key '$key': $_"
        # Handle individual key deletion errors if necessary
    }
}
# 3. Ensure required services are running and set to Automatic
$services = @(
    "dmwappushservice", # Device Management Enrollment Service
    "wuauserv", # Windows Update
    "TrkWks", # Workstation Service (for Azure AD Join/Workplace Join)
    "Netlogon", # Net Logon Service (for domain-joined systems)
    "UserManager"        # User Profile Service
)
foreach ($service in $services) {
    try {
        Set-Service -Name $service -StartupType Automatic
        Start-Service -Name $service
        Write-Host "Ensured service '$service' is set to Automatic and started."
    }
    catch {
        Write-Error "Failed to set or start service '$service': $_"
        # Handle service configuration errors if necessary
    }
}
# 4. Sync Time and Date with Internet Time Server
try {
    w32tm /resync
    Write-Host "Time synchronized successfully."
}
catch {
    Write-Error "Failed to synchronize time: $_"
}
# 5. Restart the device (optional)
# Uncomment the following lines if you want to enable automatic restart
# try {
#     Restart-Computer -Force
# }
# catch {
#     Write-Error "Failed to restart the computer: $_"
# }
Write-Host "Completed the steps. Please restart the computer manually or uncomment the restart command."
