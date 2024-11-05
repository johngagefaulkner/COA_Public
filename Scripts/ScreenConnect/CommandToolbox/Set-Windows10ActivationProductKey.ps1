$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
Clear-Host
Write-Host "[ Set-Windows10ActivationProductKey.ps1 ]"

try {
    cscript //B //NoLogo C:\Windows\System32\slmgr.vbs -ipk DQV2N-42GMQ-GC33B-YTBHJ-J8F8R | Out-File -FilePath "C:\Temp\slmgr_install.log" -Append
    cscript //B //NoLogo C:\Windows\System32\slmgr.vbs -ato | Out-File -FilePath "C:\Temp\slmgr_activate.log" -Append
    Write-Host "Windows 10/11 Product Key has been successfully installed and activated!"
    exit 0
}
catch {
    $_ | Out-File -FilePath "C:\Temp\slmgr_error.log" -Append
    Write-Host "[Exit Code 1] Error: $_"
    Write-Host "Failed to install and activate Windows 10/11 Product Key! See 'C:\Temp\slmgr_error.log' for more details."
    exit 1
}
