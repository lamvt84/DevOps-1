$rootPath = (Split-Path $MyInvocation.MyCommand.Path) 
. "$rootPath\..\Core\Library.ps1"
Write-Host "BEGIN"
Open-Script-Services -srv 1 -sv 0 -a START
Open-Script-Services -srv 2 -sv 0 -a START
Write-Host "END`n"
Read-Host -Prompt "Press Enter to continue"