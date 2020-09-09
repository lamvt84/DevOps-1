$rootPath = (Split-Path $MyInvocation.MyCommand.Path) 
. "$rootPath\..\Core\Library.ps1"
Write-Host "BEGIN"
Open-Script-IIS -srv 3 -w 4 -a START
Open-Script-IIS -srv 4 -w 4 -a START
Write-Host "END`n"
Read-Host -Prompt "Press Enter to continue"