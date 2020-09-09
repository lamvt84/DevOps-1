$username = 'sa'
$password = 'lamvt84'

$SQLInstance = "LAMVT1FINTECH,6699"
$SQLDatabase = "SMDB"
$SQLBackupDir = "D:\Database"

$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential $username, $password
Get-Credential
Import-Module DBATools

Backup-DBADatabase -SqlInstance $SQLInstance -Credential $credential -Database $SQLDatabase -BackupDirectory $SQLBackupDir -IgnoreFileChecks

