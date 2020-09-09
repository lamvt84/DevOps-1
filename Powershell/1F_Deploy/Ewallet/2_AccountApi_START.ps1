$rootPath = (Split-Path $MyInvocation.MyCommand.Path) 
. "$rootPath\..\Core\Library.ps1"
Write-Host "BEGIN"
Open-Script-IIS -srv 1 -w 1 -a START
Open-Script-IIS -srv 2 -w 1 -a START
Write-Host "END`n"
Read-Host -Prompt "Press Enter to continue"