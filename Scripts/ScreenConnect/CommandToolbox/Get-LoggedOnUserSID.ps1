#Get logged on user's SID
$userName = (Get-WmiObject -Class Win32_ComputerSystem | Select-Object UserName).UserName
$userSID = (New-Object System.Security.Principal.NTAccount($userName)).Translate([System.Security.Principal.SecurityIdentifier]).Value
Write-Host "[$userName] $userSID"
