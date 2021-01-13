# ENTRY POINT MAIN()
Param(
    [Parameter(Mandatory, HelpMessage = "Backup Type: F - Full, D - Differential, L - Log")]
    [ValidateSet("F", "D", "L")]
    [string]$Type
)

Try {
    Import-Module G:\DBA\Modules/BackupDatabase -ErrorAction Stop
}
Catch {
    $_.Exception.Message
    Write-Verbose "BackupDatabase module not installed!"
    Break
}
Try {
    Import-Module G:\DBA\Modules/FtpLibs -ErrorAction Stop
}
Catch {
    $_.Exception.Message
    Write-Verbose "FtpLibs module not installed!"
    Break
}

$Config = Get-Content "$(Split-Path $MyInvocation.MyCommand.Path)\config_current.json" | ConvertFrom-Json

$backupConfig = $Config.backup_config
$historyConfig = $Config.history_config
$mailConfig = $Config.mail_config
$ftpConfig = $Config.ftp_config


# Backup split multi files
$ReplaceInName = $false
$FileCount = 1 # count of files

# Create Credential
$isCredential = $false
try {
    $SecurePassword = ConvertTo-SecureString $backupConfig.sql_password -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential ($backupConfig.sql_login, $SecurePassword)
    $isCredential =$true
}
catch {
    $isCredential = $false
    Write-Verbose -Message "Using Windows authentication"
}

# Backup Database
$startTime = (Get-Date)
$params = @{
    Type = $Type
    SqlInstance = $backupConfig.sql_instance
    SqlBackupDir = $backupConfig.sql_backup_dir
	CompressBackup = $True
    Checksum = $True
    Encryption = $False
    EncryptionAlgorithm = $backupConfig.cert_algorithm
    EncryptionCertificate = $backupConfig.cert_name
    ReplaceInName = $ReplaceInName
    FileCount = $FileCount
    Verify = $True
}

try {
    if ($isCredential) {
        $Response = $backupConfig.databases | Invoke-BackupSQLDatabase @params -SqlCredential $Credential
    }
    else {
        $Response = $backupConfig.databases | Invoke-BackupSQLDatabase @params
    }
}
catch {
    "Error happened! Here is the error message"
    $_
}

$endTime = (Get-Date)
'Duration: {0:mm} min {0:ss} sec' -f ($endTime-$startTime)

# Logging to backup history
$password = ConvertTo-SecureString $historyConfig.sql_password -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ($historyConfig.sql_login, $password)

$params = @{
    SqlInstance = $historyConfig.sql_instance
    Database = $historyConfig.database
    SqlCredential = $Cred
    Query = "sp_BackupHistory_Insert"   
    CommandType = "StoredProcedure"
}

# Hash List
$Response | ForEach-Object {
	if ($_.Error -ne 0) {
        $password = ConvertTo-SecureString $mailConfig.pass -AsPlainText -Force
        $mailCred = New-Object System.Management.Automation.PSCredential ($mailConfig.user, $password)

        $sendMailParams = @{
            From = $mailConfig.from
            To = $mailConfig.to.Split(";")
            Subject = $mailConfig.subject
            BodyAsHtml = $True
            Body = $mailConfig.body -Replace "1", ($_.Database | Select-Object -First 1) -Replace "2", $_.Detail
            Encoding = "UTF8"
            SMTPServer = $mailConfig.server
            Port = $mailConfig.port
            UseSsl = $True
            Credential = $mailCred
        }
        Send-MailMessage @sendMailParams  -EA Stop;
    }   
    
	# FTP
	if ($_.Error -eq 0) {
		#$HashList = $null
		#$_.Detail | ForEach-Object {
        #    $HashList += Get-FileHash $_.BackupPath -Algorithm MD5
        #}

		$HashFile = (Get-FileHash $_.Detail.BackupPath -Algorithm MD5).Hash
		
		$start_date = [System.DateTimeOffset]::Now.DateTime	
		$RemoteFile = "ftp://{0}:{1}@{2}/{3}" -F $ftpConfig.user, $ftpConfig.pass, $ftpConfig.server, $_.Detail.BackupFile
		$uploadResult = Move-FTP -LocalFile $_.Detail.BackupPath -RemoteFile $RemoteFile
		$end_date = [System.DateTimeOffset]::Now.DateTime
		
		if ($uploadResult.Error -eq 0) {		
			$verifyResult = Get-FileSize -RemoteFile $RemoteFile
			if (($verifyResult.Error -eq 0) -and ($verifyResult.Detail = (Get-Item $_.Detail.BackupPath).Length)) {			
				try {
					$verify_file_size = $True
					Remove-Item $_.Detail.BackupPath | Out-Null
					$deleted = [System.DateTimeOffset]::Now.DateTime							
				}
				catch {
					Write-Verbose "Delete file error"
					$deleted = $null
				}
			}
			else {
				$deleted = $null
				$verify_file_size = $Frue
			}
		}
		
		$QueryParameters = @{
			database_name = ($_.Database | Select-Object -First 1)
			backup_type = $Type
			backup_file_name = $_.Detail.BackupFile
			backup_file_path = $_.Detail.BackupFolder
			backup_file_hash = $HashFile
			backup_start_date = $_.Detail.Start
			backup_end_date = $_.Detail.End
			ftp_upload_start_date = if ($uploadResult.Error -eq 0) { $start_date } else { $null }
			ftp_upload_end_date = if ($uploadResult.Error -eq 0) { $end_date } else { $null }
			is_notification = 0
			status = $_.Error
			error_message = if ($uploadResult.Error -ne 0) { $uploadResult.Detail } else { $null }
			ftp_status = $uploadResult.Error
			ftp_file_path = "ftp://{0}@{1}/{2}" -F $ftpConfig.user, $ftpConfig.server, $_.Detail.BackupFile
			deleted_time = $deleted
			verify_file_size = $verify_file_size
		}		
	}
	else {
		$QueryParameters = @{
			database_name = ($_.Database | Select-Object -First 1)
			backup_type = $Type
			backup_file_name = $null
			backup_file_path = $null
			backup_file_hash =$null
			backup_start_date = $null
			backup_end_date = $null
			ftp_upload_start_date = $null
			ftp_upload_end_date = $null
			is_notification = 0
			status = $_.Error
			error_message = $_.Detail
			ftp_status = $null
			ftp_file_path = $null
			deleted_time = $null
			verify_file_size = $null
		}
	}
	Invoke-DbaQuery @params -SqlParameters $QueryParameters -ErrorAction Stop | Out-Null
} 