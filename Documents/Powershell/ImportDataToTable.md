### Import data from result set to table

```powershell
$instance = ""
$database = ""
$user = ""
$pass = ""

$password = ConvertTo-SecureString $pass -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ($user, $password)

$query = Get-Content "G:\DBA\backuphistory.sql" | Out-String # query stored in file

$Result = @()
$instance | ForEach-Object {
    $db = Connect-DbaInstance -SqlInstance $_ -SqlCredential $Cred
    $Dataset = Invoke-DbaQuery -Query $query -SqlCredential $Cred -SqlInstance $_ -Database $database -ErrorAction Stop
    $Result += $Dataset
}

#$Result | Select-Object -Property * -ExcludeProperty "id" | Format-Table -AutoSize

$database = "Monitoring"
$table = "dbo.BackupHistory"

Write-DbaDataTable -SqlInstance $instance -Database $database -Table $table -SqlCredential $Cred -InputObject $Result
```

