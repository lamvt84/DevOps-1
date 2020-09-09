$rootPath = (Split-Path $MyInvocation.MyCommand.Path) 
. "$rootPath\Core\Library.ps1"
Write-Host "BEGIN"
# Open-Script-IIS -srv 3 -w 1 -a STOP */


$siteName = "demo"
$serverName = "mbfhn-ewallet01.paymobi.internal"
$block = {Stop-WebSite $args[0]}

Invoke-Command -ComputerName $serverName -ScriptBlock $block -ArgumentList @($siteName)

Write-Host "END`n"
Read-Host -Prompt "Press Enter to continue"