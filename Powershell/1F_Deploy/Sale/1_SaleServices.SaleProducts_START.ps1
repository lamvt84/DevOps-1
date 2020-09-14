$rootPath = (Split-Path $MyInvocation.MyCommand.Path) 
. "$rootPath\..\Core\Library.ps1"
Write-Host "BEGIN"
Open-Script-Services -srv 10 -sv 5 -a START
Open-Script-Services -srv 11 -sv 5 -a START
Write-Host "END`n"
Read-Host -Prompt "Press Enter to continue"