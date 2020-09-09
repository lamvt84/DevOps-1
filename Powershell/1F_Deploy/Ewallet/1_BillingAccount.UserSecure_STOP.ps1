$rootPath = (Split-Path $MyInvocation.MyCommand.Path) 
. "$rootPath\..\Core\Library.ps1"
Write-Host "BEGIN"
Open-Script-Services -srv 1 -sv 3 -a STOP
Open-Script-Services -srv 2 -sv 3 -a STOP
Write-Host "END`n"
Read-Host -Prompt "Press Enter to continue"