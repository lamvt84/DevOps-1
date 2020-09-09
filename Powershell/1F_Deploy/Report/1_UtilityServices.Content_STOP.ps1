$rootPath = (Split-Path $MyInvocation.MyCommand.Path) 
. "$rootPath\..\Core\Library.ps1"
Write-Host "BEGIN"
Open-Script-Services -srv 7 -sv 1 -a STOP
Open-Script-Services -srv 8 -sv 1 -a STOP
Write-Host "END`n"
Read-Host -Prompt "Press Enter to continue"