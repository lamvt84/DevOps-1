$rootPath = (Split-Path $MyInvocation.MyCommand.Path) 
. "$rootPath\..\Core\Library.ps1"
Write-Host "BEGIN"
Open-Script-IIS -srv 7 -w 0 -a START
Open-Script-IIS -srv 8 -w 0 -a START
Write-Host "END`n"
Read-Host -Prompt "Press Enter to continue"