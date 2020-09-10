<# 
    Backup all database
    Type function
#>

# VARIABLES
$SqlInstance = "LAMVT1FINTECH\SQL2019"
$SqlBackupDir = "D:\Database Backup"
$SqlDbExclude = "AdventureWorksDW2019", "StackOverflow2013", "StackOverflow"
$DbUser = "lamvt"
$DbPassword = "hh010898"


# FUNCTION
function Start-BackupProcess{
    Param([string]$Type)
    # Get all databases' name exclude system databases
    $DbArr = Get-DbaDatabase -SqlInstance $SqlInstance -ExcludeSystem | Select-Object Name

    # Do backup
    # Where DB not in $SqlDbExclude
    foreach ($item in $DbArr) {
        if ($SqlDbExclude -notcontains $item.Name) { 
            $BackupType = Get-BackupType -Type $Type
            $FileName = Get-BackupFileName -DbName $item.Name -Type $Type

            Backup-Database -DbName $item.Name -FileName $FileName -Type $BackupType
        }
    }

    
}

function Backup-Database {
    Param([string]$DbName, [string]$FileName, [string]$Type)

    $Password = ConvertTo-SecureString $DbPassword -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential ($DbUser, $Password)

    $params = @{
        SqlCredential   = $Credential
        SqlInstance     = $SqlInstance
        Database        = $DbName
        BackupDirectory = $SqlBackupDir
        BackupFileName  = $FileName
        Type            = $Type
        ReplaceInName   = $true
        CompressBackup  = $true
    }

    Backup-DbaDatabase @params
}

function Get-BackupFileName {
    Param([string]$DbName, [string]$Type)
    $timeStamp = '{0:yyyyMMddHHmmss}' -f (Get-Date)
    $fileType = Get-BackupType -Type $Type
    $fileExtension = Get-FileExtension -Type $Type
    $a = $DbName + "_" + $fileType + "_" + $timeStamp + "." + $fileExtension
    return $a
}

function Get-FileExtension {
    Param([string]$Type)
    switch ($Type) {
        "F" { $e = "bak" }
        "D" { $e = "bak" }
        "L" { $e = "trn" }
        Default { $e = "bak" }
    }
    return $e
}

function Get-BackupType {
    Param([string]$Type)
    switch ($Type) {
        "F" { $e = "Full" }
        "D" { $e = "Diff" }
        "L" { $e = "Log" }
        Default { $e = "Bak" }
    }
    return $e
}