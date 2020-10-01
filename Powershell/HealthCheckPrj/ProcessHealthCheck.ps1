[CmdletBinding()]
Param(    
    [Parameter(Mandatory = $false)]    
    [System.Int32]
    $ServiceId = 0 # ServiceId
)

$rootPath = (Split-Path $MyInvocation.MyCommand.Path)
Import-Module $rootPath/Modules/HealthCheck

# Functions
function Invoke-ProcessSpecialCase {
    [CmdletBinding()]
    Param(       
        [Parameter(Mandatory = $true)]    
        [System.Int32]
        $ServiceId # ServiceId
    )
    $dtStart = [datetime]::UtcNow 
    $Config = Get-Content $rootPath\config.json | ConvertFrom-Json
    
    $ApiUrl = $Config.RootUrl + "/api_service/Get?id=$ServiceId"
    try {
        $ServiceData = Invoke-WebRequest -Method GET -Uri $ApiUrl -ContentType "application/json" | ConvertFrom-Json
    }
    catch {        
        Write-Warning $Error[0]   
        return
    }    

    if ($ServiceData.data -eq $null) { return }
    if ($ServiceData.data.specialCase -eq 0 -OR $ServiceData.data.enalble -eq 0) { return }

    $ApiUrl = $Config.RootUrl + "/api_group/Get?id=$($ServiceData.data.groupId)"
    try {
        $GroupData = Invoke-WebRequest -Method GET -Uri $ApiUrl -ContentType "application/json" | ConvertFrom-Json
    }
    catch {        
        Write-Warning $Error[0]   
        return
    }   
    
    $IpAddress = ($ServiceData.Data.Url.Split("/")[2]).Split(":")[0]
    $Port = ($ServiceData.Data.Url.Split("/")[2]).Split(":")[1]
    
    $Guid = New-Guid
    Write-Host "Guid: $Guid"
    try {            
            $HealthCheckResult = Invoke-HealthCheck -DnsName $IpAddress -Port $Port -Type $GroupData.Data.groupTypeId -Url $ServiceData.Data.Url
            $status = if ($HealthCheckResult -eq $true) { "OK" } else { "ERROR" }
        }
    catch {
        Write-Warning $Error[0]
    }  

    $Uri = $Config.RootUrl + "/api/UpdateHealthCheckSpecialCase?serviceId=$ServiceId&jGuid=$Guid&status=$status&url=$($ServiceData.Data.Url)"
   
    try {
        Invoke-WebRequest -Method POST -Uri $Uri -ContentType "application/json"
    }
    catch {
        Write-Warning $Error[0]   
    }    
    Write-Host "Total time elapsed: $([datetime]::UtcNow - $dtStart)"
}

function Invoke-ProcessCommonCaseAsync {
    <#[CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true, Mandatory = $false)]
        [ValidateRange(1,2)]
        [int]$GroupType = 0
    )#>
    Begin
    {
        # Init
        $Config = Get-Content $rootPath\config.json | ConvertFrom-Json
        $Guid = New-Guid
        Write-Host "Guid: $Guid"

        $ThreadCount = 0
        $ErrorCount = 0
        
        $root = $PSScriptRoot            
        $initScript = [scriptblock]::Create("Import-Module -Name '$root\Modules\HealthCheck'")    
      

        $Query = "SELECT s.Id, s.Url, g.GroupTypeId FROM dbo.[Services] s JOIN dbo.Groups g ON s.GroupId = g.Id WHERE s.Enable = 1 AND s.SpecialCase = 0"
        $DataSet = Invoke-SqlCmd -Query $Query -ServerInstance $Config.SqlInstance -Username $Config.User -Password $Config.Password -Database $Config.Database `
                    | Select-Object Id, Url, GroupTypeId

        $DataSet = $DataSet | Select-Object Id, Url, @{Name = 'IpAddress'; Expression = { ($_.Url.Split("/")[2]).Split(":")[0] } }`
                                            , @{Name='Port';Expression={($_.Url.Split("/")[2]).Split(":")[1]}}, GroupTypeId
        $ThreadCount = $DataSet.Count

        $Query = "EXEC [dbo].[usp_ServicesLog_Add]
                    @JournalGuid = '$Guid',
                    @ServiceId = '0',
                    @ServiceUrl = '',
                    @ServiceStatus = 'START'"
        Invoke-SqlCmd -Query $Query -ServerInstance $Config.SqlInstance -Username $Config.User -Password $Config.Password -Database $Config.Database -ErrorAction Stop               
    }
    Process
    {   
        $dtStart = [datetime]::UtcNow   
        
        if ($DataSet.Count -gt 0) 
        {    
            $ScriptBlock = [scriptblock] `
            {    
                param($Data, $Config, $Guid)
                try {
                    if ($Data.GroupTypeId -eq 1) { $HealthCheckResult = Invoke-HealthCheck -DnsName $Data.IpAddress -Port $Data.Port -Type $Data.GroupTypeId -Url $Data.Url }
                    else {                        
                        $HealthCheckResult = Invoke-HealthCheck -DnsName $Data.IpAddress -Port $Data.Port -Type $Data.GroupTypeId 
                    }
                }
                catch {
                    Write-Warning "$($Error[0]) = $($Data.Url)"
                    $HealthCheckResult = $false
                }
                
                $ResultSet = @{
                    Id         = $Data.Id
                    Url        = $Data.Url
                    Status     = if ($HealthCheckResult -eq $true) { 1 } else { 0 }
                    StatusCode = if ($HealthCheckResult -eq $true) { "OK" } else { "ERROR" }               
                }
                
                Write-Output $ResultSet
            }

            $jobs = $DataSet | ForEach-Object { 
                $Params = ($_, $Config, $Guid)
                Start-ThreadJob -ThrottleLimit $ThreadCount -ArgumentList $Params -ScriptBlock $ScriptBlock `
                    -InitializationScript $initScript
            }


            Write-Host "Waiting for $($jobs.Count) jobs to complete..."
            
            $ResultSet = Receive-Job -Job $jobs -Wait -AutoRemoveJob  
            Write-Host "RESULT..."  

            try {
                $scope = New-Object -TypeName System.Transactions.TransactionScope

                $ResultSet | ForEach-Object {
                    $service = $_ | ConvertTo-Json -Depth 2 | ConvertFrom-Json

                    $Query = "EXEC [dbo].[usp_ServicesLog_Add] 
                        @JournalGuid = '$Guid',
                        @ServiceId = '$($service.Id)',
                        @ServiceUrl = '$($service.Url)',
                        @ServiceStatus = '$($service.StatusCode)'"
                    Invoke-SqlCmd -Query $Query -ServerInstance $Config.SqlInstance -Username $Config.User -Password $Config.Password -Database $Config.Database -ErrorAction Stop
                    $Query = "EXEC [dbo].[usp_Services_UpdateStatus] 
                        @Id = '$($service.Id)', 
                        @Status = '$($service.Status)'"
                    Invoke-SqlCmd -Query $Query -ServerInstance $Config.SqlInstance -Username $Config.User -Password $Config.Password -Database $Config.Database -ErrorAction Stop

                    if ($service.status -eq 0) { $ErrorCount += 1 }
                }
            }
            catch {
                $_.exception.message
            }
            finally {
                $scope.Complete();
                $scope.Dispose() 
            }            
        }
        Write-Host "Total time elapsed: $([datetime]::UtcNow - $dtStart)"
        $Query = "EXEC [dbo].[usp_ServicesLog_Add] 
                @JournalGuid = '$Guid',
                @ServiceId = '0',
                @ServiceUrl = '',
                @ServiceStatus = 'END'"
        Invoke-SqlCmd -Query $Query -ServerInstance $Config.SqlInstance -Username $Config.User -Password $Config.Password -Database $Config.Database -ErrorAction Stop
    }
    End {
        if ($ErrorCount -gt 0) {
            $ErrorCount 
            <#
        Invoke-WebRequest -Headers @{} `
                  -Method POST `
                  -Body (@{}|ConvertTo-Json) `
                  -Uri url `
                  -ContentType application/json
    #>
            $Uri = $Config.RootUrl + "/api/SendAlert?jGuid=$Guid"
    
            try {
                Invoke-WebRequest -Method POST -Uri $Uri -ContentType "application/json"
            }
            catch {
                Write-Warning $Error[0]   
            }    
        }
    }    
}
    
if ($ServiceId -eq 0) {
    Invoke-ProcessCommonCaseAsync
}
else {
    Invoke-ProcessSpecialCase -ServiceId $ServiceId
}