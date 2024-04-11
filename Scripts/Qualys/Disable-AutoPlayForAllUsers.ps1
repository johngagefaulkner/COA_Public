# Define Behaviors
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

# Define Variables
$AllUsersExplorerPoliciesPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\"
$AutoPlayKeyName = "NoDriveTypeAutoRun"
$AutoPlayKeyDesiredValue = 255
$AutoPlayKeyFullPath = Join-Path -Path $AllUsersExplorerPoliciesPath -ChildPath $AutoPlayKeyName

# Initialize
try {
    Write-Host "Checking to ensure the File Explorer policies Registry Key exists..."
    # Check if the registry path exists, if not create it
    if (-not (Test-Path $AllUsersExplorerPoliciesPath)) {
        Write-Host "Not found! Creating the File Explorer policies Registry Key..."
        New-Item -Path $AllUsersExplorerPoliciesPath -Force | Out-Null
        Write-Host "Registry Key created successfully!"
    }

    # Check if the registry key exists, if not create it.
    ## If so, check to see if the value is set to the desired value -> then set it if it is not.
    Write-Host "Checking to ensure the AutoPlay Registry Key exists..."
    if (-not (Test-Path "$AutoPlayKeyFullPath")) {
        Write-Host "Not found! Creating the AutoPlay Registry Key..."
        New-ItemProperty -Path $AllUsersExplorerPoliciesPath -Name $AutoPlayKeyName -Value $AutoPlayKeyDesiredValue -PropertyType DWord -Force | Out-Null
        Write-Host "Registry Key created successfully!"
    }
    else {
        Write-Host "Registry Key found! Checking to see if the value is set to the desired value..."
        $AutoPlayKeyValue = (Get-ItemProperty -Path $AutoPlayKeyFullPath).$AutoPlayKeyName
        if ($AutoPlayKeyValue -ne $AutoPlayKeyDesiredValue) {
            Write-Host "Value is not set to the desired value! Setting the value to $AutoPlayKeyDesiredValue..."
            Set-ItemProperty -Path $AutoPlayKeyFullPath -Name $AutoPlayKeyName -Value $AutoPlayKeyDesiredValue -Force | Out-Null
            Write-Host "Value set successfully!"
        }
        else {
            Write-Host "Value is already set to the desired value!"
        }
    }

    Write-Host "Autoplay disabled successfully. Changes will take effect after a restart."
    Exit 0
}
catch {
    Write-Host "An error occurred:"
    Write-Host $_
    Exit 1
}
