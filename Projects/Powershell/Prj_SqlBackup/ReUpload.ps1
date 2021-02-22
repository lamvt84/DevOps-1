# ======================================== INITIALIZE ======================================== #
$RootPath = $MyInvocation.MyCommand.Path | Split-Path | Split-Path
$PrivateKeyPath = "{0}\Credentials\PrivateKey.txt" -F $RootPath
$PrivateKey = Get-Content -Path $PrivateKeyPath 
# ======================================== DATABASE CONFIG ======================================== #
$FTP_SERVER = "192.168.101.55"

$FtpUser = "kvtmpR"
$FtpKeyHashPath = "{0}\Credentials\PasswordHash_FTP.txt" -F $RootPath
$FtpPassword = Get-Content -Path $FtpKeyHashPath | ConvertTo-SecureString -Key $PrivateKey
$FTPCredential = New-Object System.Management.Automation.PSCredential($FtpUser, $FtpPassword)
. ("{0}\Libs\Ftp.ps1" -F $RootPath)

$Instance = $ENV:COMPUTERNAME
$DBUser = "replicator"
$DBPasswordHashPath = "{0}\Credentials\PasswordHash_DB.txt" -F $RootPath
$DBPassword = Get-Content -Path $DBPasswordHashPath | ConvertTo-SecureString -Key $PrivateKey
$DBCredential = New-Object System.Management.Automation.PSCredential($DBUser, $DBPassword)

$Query = "SELECT TOP (1000) *
  FROM [Monitoring].[dbo].[BackupHistory]
  WHERE ftp_upload_start_date > '2021-02-05 00:00:00 +07:00'"
  
$fileList = Invoke-DBAQuery -SqlInstance $Instance -SqlCredential $DBCredential -Query $Query -EA Stop

$HistoryQueryParams = @{
	SqlInstance = $Instance
	Database = "Monitoring"
	SqlCredential = $DBCredential	
	CommandType = "StoredProcedure"
}
#$HistoryInsertProc = "sp_BackupHistory_Insert"
$HistoryUpdateProc = "sp_BackupHistory_Update"

# Check if file Exists
$fileList | Foreach-Object {
	$item = $_
	$filePath = "{0}\{1}" -F $item.backup_file_path, $item.backup_file_name
	if (Test-Path -Path $filePath) {
		"{0} - existed" -F $filePath
		# Reupload
		$RemoteFile = "ftp://{0}/{1}" -F $FTP_SERVER, $item.backup_file_name

		$QueryParameters = $null
		$QueryParameters = @{
			id = $item.id		
			ftp_status = 1
			ftp_file_path = "ftp://{0}@{1}/{2}" -F $FtpUser, $FTP_SERVER, $item.backup_file_name
		}
		Invoke-DbaQuery @HistoryQueryParams -Query $HistoryUpdateProc -SqlParameters $QueryParameters -ErrorAction Stop | Out-Null

		# try ftp
		$UploadResult = Move-FTP -LocalFile $filePath -RemoteFile $RemoteFile -FtpCredential $FTPCredential
			
		$QueryParameters = $null
		$QueryParameters = @{
			id = $item.id			
			ftp_status = if ($UploadResult.Error -eq 0) { 2 } else { $UploadResult.Error }
			error_message = if ($UploadResult.Error -eq 0) { $null } else { $UploadResult.Detail }
		}
		Invoke-DbaQuery @HistoryQueryParams -Query $HistoryUpdateProc -SqlParameters $QueryParameters -ErrorAction Stop | Out-Null

		if ($UploadResult.Error -eq 0) {
			$RemoteFileSize = Get-FileSize -RemoteFile $RemoteFile -FtpCredential $FTPCredential
			if (($RemoteFileSize.Error -eq 0) -and ($RemoteFileSize.Detail = (Get-Item $filePath).Length)) {			
				try {
					$verify_file_size = $True
					Remove-Item $filePath | Out-Null
					Write-Host "$($filePath) deleted"
				}
				catch {
					$verify_file_size = $False
					Write-Warning "$($filePath) - Delete file error - $($Error[0].Exception.Message)"
				}
			}
			else {			
				$verify_file_size = $False
				Write-Warning "Upload file error - $($filePath)"
			}

			$QueryParameters = $null
			$QueryParameters = @{
				id = $BackupHistory.id		
				ftp_status = 2
				verify_file_size = $verify_file_size
			}
			
			Invoke-DbaQuery @HistoryQueryParams -Query $HistoryUpdateProc -SqlParameters $QueryParameters -ErrorAction Stop | Out-Null
		}
	}
}