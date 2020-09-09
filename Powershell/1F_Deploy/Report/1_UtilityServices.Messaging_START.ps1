$rootPath = (Split-Path $MyInvocation.MyCommand.Path) 
. "$rootPath\..\Core\Library.ps1"
Write-Host "BEGIN"
Open-Script-Services -srv 7 -sv 2 -a START
Open-Script-Services -srv 8 -sv 2 -a START
Write-Host "END`n"
Read-Host -Prompt "Press Enter to continue"