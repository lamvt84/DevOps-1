# DWH Installation

### Scope

* EDWCore
* EDWStaging
* EDWInitiatorSB
* EDWTargetSB

### Source

**Path** "D:\Repo\Personal\Github\DevOps\Dba\EDW\Doc\ScriptsToRun\"
* EDWCore_DB.sql
* EDWStaging_DB.sql
* EDWInitiatorSB_DB.sql
* EDWTargetSB_DB.sql

### Installation

Run PS Scripts

```powershell
Import-Module dbatools

$scripts = get-childitem "D:\Repo\Personal\Github\DevOps\Dba\EDW\Doc\ScriptsToRun\" –Filter *DB.sql | sort-object Name
$servers = "LAMVT1FINTECH\SQL2019"
$database = "master"
    
foreach ($script in $scripts) {
    $OutputFile = $script.directoryname + "\" + $script.basename + ".txt"
    Write-Host $OutputFile
    Invoke-DbaQuery –SqlInstance $servers –File $script.FullName –Database $database –MessagesToOutput | Out-File –FilePath $OutputFile
}
```