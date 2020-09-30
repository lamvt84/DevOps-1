# ENTRY POINT MAIN()
Param(
    [Parameter(Position = 1, Mandatory = $True, HelpMessage = "Backup Type: F - Full, D - Differential, L - Log", ValueFromPipeline = $true)]
    [ValidateSet("F", "D", "L")]
    [string]$Type
)

$rootPath = (Split-Path $MyInvocation.MyCommand.Path)
. "$rootPath\Libs.ps1"

Initialize-BackupProcess $Type