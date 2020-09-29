[CmdletBinding()]
Param(
    [Parameter(Mandatory = $false)]    
    [System.Int32]
    $GroupType = 0 # 1: api, 2: tcp
    ,
    [Parameter(Mandatory = $false)]    
    [System.String]
    $Url = "" # special case, need to call API for update status
    ,
    [Parameter(Mandatory = $false)]    
    [System.Int32]
    $ServiceId = 0 # ServiceId
)

$rootPath = (Split-Path $MyInvocation.MyCommand.Path)
Import-Module $rootPath/Modules/HealthCheck

# Functions
function Invoke-ProcessSpecialCase() {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]    
        [System.Int32]
        $GroupType # 1: api, 2: tcp
        ,
        [Parameter(Mandatory = $true)]    
        [System.String]
        $Url # special case, need to call API for update status
        ,
        [Parameter(Mandatory = $true)]    
        [System.Int32]
        $ServiceId # ServiceId
    )
    $dtStart = [datetime]::UtcNow 
    $Config = Get-Content $rootPath\config.json | ConvertFrom-Json

    $IpAddress = ($Url.Split("/")[2]).Split(":")[0]
    $Port = ($Url.Split("/")[2]).Split(":")[1]
    
    $Guid = New-Guid
    Write-Host $Guid
    try {
            if ($GroupType -eq 1) { $HealthCheckResult = Invoke-HealthCheck -DnsName $IpAddress -Port $Port -Type $GroupType -Url $Url }
            else { $HealthCheckResult = Invoke-HealthCheck -DnsName $IpAddress -Port $Port -Type $GroupType }
            $status = if ($HealthCheckResult -eq $true) { "OK" } else { "ERROR" }
        }
    catch {
        Write-Warning $Error[0]
    }  
    
    $Uri = $Config.UpdateUrl + "?serviceId=$ServiceId&jGuid=$Guid&status=$status&url=$Url"
    Write-Host $Uri
    try {
        Invoke-WebRequest -Method POST -Uri $Uri -ContentType "application/json"
    }
    catch {
        Write-Warning $Error[0]   
    }    
    Write-Host "Total time elapsed: $([datetime]::UtcNow - $dtStart)"
}

function Invoke-ProcessCommonCaseAsync() {
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

        $ThreadCount = 20
        $ErrorCount = 0
        
        $root = $PSScriptRoot            
        $initScript = [scriptblock]::Create("Import-Module -Name '$root\Modules\HealthCheck'")    
      

        $Query = "SELECT s.Id, s.Url, g.GroupTypeId FROM dbo.[Services] s JOIN dbo.Groups g ON s.GroupId = g.Id WHERE s.Enable = 1 AND s.SpecialCase = 0"
        $DataSet = Invoke-SqlCmd -Query $Query -ServerInstance $Config.SqlInstance -Username $Config.User -Password $Config.Password -Database $Config.Database `
                    | Select-Object Id, Url, GroupTypeId

        $DataSet = $DataSet | Select-Object Id, Url, @{Name = 'IpAddress'; Expression = { ($_.Url.Split("/")[2]).Split(":")[0] } }`
                                            , @{Name='Port';Expression={($_.Url.Split("/")[2]).Split(":")[1]}}, GroupTypeId

        $Query = "EXEC [dbo].[usp_ServicesLog_Add]
                    @JournalGuid = '$Guid',
                    @ServiceId = '0',
                    @ServiceUrl = '',
                    @ServiceStatus = 'START'"
        Invoke-SqlCmd -Query $Query -ServerInstance $Config.SqlInstance -Username $Config.User -Password $Config.Password -Database $Config.Database                
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
                }
                
                try {
                    #Write-Warning $Url
                    $status = if ($HealthCheckResult -eq $true) { 1 } else { 0 }
                    if ($status -eq 1) { $ErrorCount += 1 }
                    $statusCode = if ($HealthCheckResult -eq $true) { "OK" } else { "ERROR" }

                    $Query = "EXEC [dbo].[usp_ServicesLog_Add] 
                        @JournalGuid = '$Guid',
                        @ServiceId = '$($Data.Id)',
                        @ServiceUrl = '$($Data.Url)',
                        @ServiceStatus = $statusCode"
                    Invoke-SqlCmd -Query $Query -ServerInstance $Config.SqlInstance -Username $Config.User -Password $Config.Password -Database $Config.Database 

                            
                    $Query = "EXEC [dbo].[usp_Services_UpdateStatus] 
                        @Id = $($Data.Id), 
                        @Status = $status"
                    Invoke-SqlCmd -Query $Query -ServerInstance $Config.SqlInstance -Username $Config.User -Password $Config.Password -Database $Config.Database 
                }
                catch {
                    #Write-Warning $Error[0]
                    $ErrorCount += 1
                    $Query = "EXEC [dbo].[usp_ServicesLog_Add] 
                        @JournalGuid = '$Guid',
                        @ServiceId = '$($Data.Id)',
                        @ServiceUrl = '$($Data.Url)',
                        @ServiceStatus = 'ERROR'"
                    Invoke-SqlCmd -Query $Query -ServerInstance $Config.SqlInstance -Username $Config.User -Password $Config.Password -Database $Config.Database 
                    $Query = "EXEC [dbo].[usp_Services_UpdateStatus] 
                        @Id = $($Data.Id), 
                        @Status = $status"
                    Invoke-SqlCmd -Query $Query -ServerInstance $Config.SqlInstance -Username $Config.User -Password $Config.Password -Database $Config.Database 
                }   
            }

            $jobs = $DataSet | ForEach-Object { 
                $Params = ($_, $Config, $Guid)
                Start-ThreadJob -ThrottleLimit $ThreadCount -ArgumentList $Params -ScriptBlock $ScriptBlock `
                    -InitializationScript $initScript
            }

            Write-Host "Waiting for $($jobs.Count) jobs to complete..."

            Receive-Job -Job $jobs -Wait -AutoRemoveJob
            Write-Host "Total time elapsed: $([datetime]::UtcNow - $dtStart)"

            $Query = "EXEC [dbo].[usp_ServicesLog_Add] 
                    @JournalGuid = '$Guid',
                    @ServiceId = '0',
                    @ServiceUrl = '',
                    @ServiceStatus = 'END'"
            Invoke-SqlCmd -Query $Query -ServerInstance $Config.SqlInstance -Username $Config.User -Password $Config.Password -Database $Config.Database 
        }
    }
    End {
        if ($ErrorCount -gt 0) {
            <#
        Invoke-WebRequest -Headers @{} `
                  -Method POST `
                  -Body (@{}|ConvertTo-Json) `
                  -Uri url `
                  -ContentType application/json
    #>
            $Uri = $Config.AlertUrl + "?jGuid=$Guid"
    
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
    Invoke-ProcessSpecialCase -GroupType $GroupType -Url $Url -ServiceId $ServiceId
}
