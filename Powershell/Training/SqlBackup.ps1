# ENTRY POINT MAIN()
Param(
    [Parameter(Mandatory = $true)]
    $Type = ""
)

. "\SqlBackupLibs.ps1"

Start-BackupProcess -Type $Type