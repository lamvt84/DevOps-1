[CmdletBinding()]
Param(
    [Parameter(
        Mandatory = $True,
        ValueFromPipeline = $True)]    
    [int]
    $BatchId,
    [Parameter(
        Mandatory = $True,
        ValueFromPipeline = $True)]    
    [int]
    $SyncId,
    [Parameter(
        Mandatory = $True,
        ValueFromPipeline = $True)]    
    [string]
    $ProcName
)
$database = "SSISDB"
$db = Connect-DbaInstance -SqlInstance $ENV:COMPUTERNAME
$query = "EXEC [SSISDB].dbo.[ProcessTransactionData]		
						@Batch_Id = {0},
						@Sync_Id = {1},
						@Proc_Name = {2}" -f $BatchId, $SyncId, $ProcName
Invoke-DbaQuery -Query $query -SqlInstance $db -Database $database -ErrorAction Stop


