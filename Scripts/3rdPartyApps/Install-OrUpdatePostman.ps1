$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
Clear-Host

try {
    Write-Host "Installing the Postman CLI, please wait... "
    $POSTMAN_CLI_PATH = "$Env:USERPROFILE\AppData\Local\Microsoft\WindowsApps"
    New-Item -type directory -Path "$POSTMAN_CLI_PATH" -Force | Out-Null
    $client = New-Object System.Net.WebClient
    $client.DownloadFile("https://dl-cli.pstmn.io/download/latest/win64", "$POSTMAN_CLI_PATH\postman-cli.zip")
    Expand-Archive "$POSTMAN_CLI_PATH\postman-cli.zip" "$POSTMAN_CLI_PATH" -Force
    Remove-Item "$POSTMAN_CLI_PATH\postman-cli.zip"
    #mv "$POSTMAN_CLI_PATH\postman-cli.exe" "$POSTMAN_CLI_PATH\postman.exe" -Force
    Rename-Item -Path "$POSTMAN_CLI_PATH\postman-cli.exe" -NewName "postman.exe" -Force
    Write-Host "Done!" -ForegroundColor Green
    Write-Host "The Postman CLI has been installed"
    exit 0
}
catch {
    Write-Host "An error occurred while installing the Postman CLI!" -ForegroundColor Red
    Write-Host $_.Exception.Message
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json")

    $body = @{
        level       = 'error'
        transaction = 'postman-cli-install'
        tags        = @{
            os = 'win64'
        }
        exception   = @{
            values = @(
                @{
                    type  = 'InstallationError'
                    value = $_.Exception.Message
                }
            )
        }
    } | ConvertTo-Json -Compress -Depth 3

    Write-Host "Reporting Error Message to Sentry, please wait... " -NoNewline
    $response = Invoke-RestMethod 'https://o1224273.ingest.sentry.io/api/4504100877828096/store/?sentry_key=0b9fcaeae27d4918b933ed747b1a1047' -Method 'POST' -Headers $headers -Body $body
    Write-Host "Done!" -ForegroundColor Green
    Write-Host
    Write-Host "Response: $response"
    Write-Host "Exiting with error code 1"
    exit 1
}
