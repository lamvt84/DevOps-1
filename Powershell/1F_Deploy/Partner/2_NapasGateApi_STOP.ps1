$rootPath = (Split-Path $MyInvocation.MyCommand.Path) 
. "$rootPath\..\Core\Library.ps1"
Write-Host "BEGIN"
Open-Script-IIS -srv 3 -w 4 -a STOP
Open-Script-IIS -srv 4 -w 4 -a STOP
Write-Host "END`n"
Read-Host -Prompt "Press Enter to continue"