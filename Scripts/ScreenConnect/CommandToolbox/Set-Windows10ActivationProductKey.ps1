$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
Clear-Host
Write-Host "[ Set-Windows10ActivationProductKey.ps1 ]"

# Replace with your Product Key
$PRODUCT_KEY = "00000-11111-22222-33333-44444"
$ErrorLogFilePath = "%TEMP%\slmgr_error.log"

try {
    cscript //B //NoLogo C:\Windows\System32\slmgr.vbs -ipk $PRODUCT_KEY | Out-File -FilePath $ErrorLogFilePath -Append
    cscript //B //NoLogo C:\Windows\System32\slmgr.vbs -ato | Out-File -FilePath $ErrorLogFilePath -Append
    Write-Host "Windows 10/11 Product Key has been successfully installed and activated!"
    exit 0
}
catch {
    $_ | Out-File -FilePath $ErrorLogFilePath -Append
    Write-Host "[Exit Code 1] Error: $_"
    Write-Host "Failed to install and activate Windows 10/11 Product Key! See '$($ErrorLogFilePath)' for more details."
    exit 1
}
