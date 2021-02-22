Param(
    [Parameter()]
	[int]$syncType	
)

if ($null -eq $syncType) {
	$syncType = 0
}
# 1: Sync EventMonitoring
# 2: Sync Shard
# null | 0: do nothing

$rootPath = $MyInvocation.MyCommand.Path | Split-Path | Split-Path
$privateKeyPath = "{0}\Credentials\PrivateKey.txt" -F $rootPath
$dbPasswordHashPath = "{0}\Credentials\PasswordHash_DB.txt" -F $rootPath
$queryPath = "{0}\Queries\publish.sql" -F $rootPath
$logPath = "{0}\log" -F $rootPath

$privateKey = Get-Content -Path $privateKeyPath 
$dbUser = "replicator"
$dbPass = Get-Content -Path $dbPasswordHashPath | ConvertTo-SecureString -Key $PrivateKey
$SqlCredential = New-Object System.Management.Automation.PSCredential($DBUser, $dbPass)

function SyncEventMonitoring {
    Param(
        [Parameter()]
        [string]$QueryPath        
        ,
        [Parameter()]
        [string]$LogPath        
        ,
        [Parameter()]
        [PSCredential]$SqlCredential
    )

    $Response = @()

    $Response += Connect-DbaInstance -SqlInstance "172.16.1.13" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB1
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.81" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB14
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.19" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB2
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.24" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB4
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.29" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB5
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.35" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB6
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.40" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB7
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.47" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB8
    #$Response += Connect-DbaInstance -SqlInstance "172.16.1.41" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DBMASTER
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.200" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB10
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.12" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB11
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.25" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB12
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.17" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB12A
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.72" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB12
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.14" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB15
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.16" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB5
    #$Response += Connect-DbaInstance -SqlInstance "172.16.13.27" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB9
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.22" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB6
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.26" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB2
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.13" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB3
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.15" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB7
    #$Response += Connect-DbaInstance -SqlInstance "192.168.41.11" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DBREP1

    $logFile = "{0}\LogSync_EventMonitoring_{1}.txt" -F $LogPath, ('{0:yyyyMMddHHmmss}' -f (Get-Date))
    $Response | Out-File -FilePath $logFile
}

function SyncShard {
    Param(
        [Parameter()]
        [string]$QueryPath        
        ,
        [Parameter()]
        [string]$LogPath        
        ,
        [Parameter()]
        [PSCredential]$SqlCredential
    )

    $Response = @()

    $Response += Connect-DbaInstance -SqlInstance "172.16.1.13" -Database "KiotViet" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB1
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.26" -Database "KiotVietShard2" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB2
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.13" -Database "KiotVietShard3" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB3
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.24" -Database "KiotVietShard4" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB4
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.29" -Database "KiotVietShard5" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB5
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.35" -Database "KiotVietShard6" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB6
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.40" -Database "KiotVietShard7" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB7
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.47" -Database "KiotVietShard8" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB8
    $Response += Connect-DbaInstance -SqlInstance "192.168.41.11" -Database "KiotVietShard9" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DBREP1
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.27" -Database "KiotVietShard10" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB9
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.12" -Database "KiotVietShard11" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB11
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.25" -Database "KiotVietShard12" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB12
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.12" -Database "KiotVietShard13" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB11
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.29" -Database "KiotVietShard14" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB5
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.15" -Database "KiotVietShard15" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB7
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.17" -Database "KiotVietShard16" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB12A
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.81" -Database "KiotVietShard17" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB14
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.24" -Database "KiotVietShard18" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB4
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.200" -Database "KiotVietShard19" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB10
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.14" -Database "KiotVietShard20" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB15
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.81" -Database "KiotVietShard21" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB14
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.15" -Database "KiotVietShard22" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB7
    $Response += Connect-DbaInstance -SqlInstance "172.16.1.72" -Database "KiotVietShard23" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-DB12
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.22" -Database "KiotVietShard24" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB6
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.17" -Database "KiotVietShardAWS" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB12A
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.13" -Database "KiotVietShard26" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB3
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.17" -Database "KiotVietShard27" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB12A
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.16" -Database "KiotVietShard28" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB5
    $Response += Connect-DbaInstance -SqlInstance "172.16.13.14" -Database "KiotVietShard29" -SqlCredential $SqlCredential | Invoke-DbaQuery -File $QueryPath -MessagesToOutput # VM-KV-DB15    

    $logFile = "{0}\LogSync_Shard_{1}.txt" -F $LogPath, ('{0:yyyyMMddHHmmss}' -f (Get-Date))
    $Response | Out-File -FilePath $logFile
}

switch ($syncType) {
    1 { SyncEventMonitoring -QueryPath $queryPath -LogPath $logPath -SqlCredential $SqlCredential }
    2 { SyncEventMonitoring -QueryPath $queryPath -LogPath $logPath -SqlCredential $SqlCredential }    
    Default { Read-Host "Do nothing!"}
}