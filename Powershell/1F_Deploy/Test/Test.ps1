# ENTRY POINT MAIN()
Param(
    [Parameter(Mandatory = $true)]
    $SvrName = "",
    [Parameter(Mandatory = $true)]
    $SiteName = "",
    [Parameter(Mandatory = $true)]
    $Action = ""
)
$rootPath = (Split-Path $MyInvocation.MyCommand.Path) 
. "$rootPath\..\Core\Library.ps1"
Write-Host "BEGIN"
Update-IISWebsiteStatus -server $SvrName -site $SiteName -a $Action
Write-Host "END`n"
Read-Host -Prompt "Press Enter to continue"