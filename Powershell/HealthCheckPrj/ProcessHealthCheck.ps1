[CmdletBinding()]
Param(    
    [Parameter(Mandatory = $false)]    
    [System.Int32]
    $ServiceId = 0
)
$rootPath = (Split-Path $MyInvocation.MyCommand.Path)
. $rootPath/Libs.ps1


function Invoke-ProcessSpecialCase {
    [CmdletBinding()]
    Param(       
        [Parameter(Mandatory = $true)]    
        [System.Int32]
        $ServiceId # ServiceId
    )
    $dtStart = [datetime]::UtcNow 
    $config = Get-Content $rootPath\config.json | ConvertFrom-Json
    
    $apiUrl = $config.RootUrl + "/api_service/Get?id=$ServiceId"
    try {
        $service = Invoke-WebRequest -Method GET -Uri $apiUrl -ContentType "application/json" | ConvertFrom-Json
    }
    catch {        
        Write-Warning $Error[0]   
        return
    }    
    
    if ($service.data -eq $null) { return }
    if ($service.data.specialCase -eq 0 -OR $service.data.enable -eq 0) { return }    
    
    $ipAddress = ($service.data.url.Split("/")[2]).Split(":")[0]
    $port = ($service.data.url.Split("/")[2]).Split(":")[1]

    $guid = New-Guid
    Write-Host "Guid: $guid"   
    $response = switch ($service.data.groupTag) {
                    "API" {
                        Test-HealthCheck -Object $service.data.url -GroupTag $service.data.groupTag
                        break
                    }
                    default {                    
                        Test-HealthCheck -Object $ipAddress -Port $port -GroupTag $service.data.groupTag
                        break
                    }
                }
    try {   
            $uri = $config.RootUrl + "/api/UpdateHealthCheckSpecialCase?serviceId=$ServiceId&jGuid=$guid&status=$(if ($response[0].Status) { "OK" } else { "ERROR" })&url=$($service.data.url)"
            
            Invoke-WebRequest -Method POST -Uri $uri -ContentType "application/json" | Out-Null           
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
        $config = Get-Content $rootPath\config.json | ConvertFrom-Json
        $guid = New-Guid
        Write-Host "Guid: $guid"

        $threadCount = 0
        $errorCount = 0
          
        $initScript = [scriptblock]::Create(". $rootPath/Libs.ps1")          

        $query = "SELECT s.Id, s.Url, g.Tag
                FROM dbo.[Services] s 
                    LEFT JOIN dbo.Groups g ON s.GroupId = g.Id                     
                WHERE s.Enable = 1 AND s.SpecialCase = 0"
        $dataSet = Invoke-SqlCmd -Query $query -ServerInstance $config.SqlInstance -Username $config.User -Password $config.Password -Database $config.Database `
                    | Select-Object Id, Url, Tag, @{Name = 'IpAddress'; Expression = { ($_.Url.Split("/")[2]).Split(":")[0] } }`
                                            , @{Name='Port';Expression={($_.Url.Split("/")[2]).Split(":")[1]}}
        
        $threadCount = $dataSet.Count - 1

        $query = "EXEC [dbo].[usp_ServicesLog_Add]
                    @JournalGuid = '$Guid',
                    @ServiceId = '0',
                    @ServiceUrl = '',
                    @ServiceStatus = 'START'"
        Invoke-SqlCmd -Query $query -ServerInstance $config.SqlInstance -Username $config.User -Password $config.Password -Database $config.Database -ErrorAction Stop
    }
    Process
    {   
        $dtStart = [datetime]::UtcNow   
        if ($dataSet.Count -gt 0) 
        {    
            $scriptBlock = [scriptblock] `
            {    
                param($data, $config, $guid)
                $temp = "" | Select Id, Object, Port, CheckType, Status, Notes 
                try {                    
                    #if ($Data.GroupTypeId -eq 1) { $HealthCheckResult = Invoke-HealthCheck -DnsName $Data.IpAddress -Port $Data.Port -Type $Data.GroupTypeId -Url $Data.Url }
                    #else {                        
                    #    $HealthCheckResult = Invoke-HealthCheck -DnsName $Data.IpAddress -Port $Data.Port -Type $Data.GroupTypeId 
                    #}
                    $response = switch ($data.Tag) {
                        "API" {
                            Test-HealthCheck -Object $data.Url -GroupTag $data.Tag
                            break
                        }
                        default {                    
                            Test-HealthCheck -Object $data.IpAddress -Port $data.Port -GroupTag $data.Tag
                            break
                        }
                    }                   
                    
                    $temp.Object = $response[0].Id
                    $temp.Object = $response[0].Object
                    $temp.Port = $response[0].Port    
                    $temp.CheckType = $data.Tag
                    $temp.Status = $response[0].Status
                    $temp.Notes = $response[0].Notes   
                }
                catch {
                    Write-Host "$($Error[0]) = $($data.Url)"                    
                }                
                Write-Output $temp
            }
            
            $jobs = $dataSet | ForEach-Object { 
                $params = ($_, $Config, $Guid)
                Start-ThreadJob -ThrottleLimit $threadCount -ArgumentList $params -ScriptBlock $scriptBlock `
                    -InitializationScript $initScript
            }

            Write-Host "Waiting for $($jobs.Count) jobs to complete..."
            
            $report = Receive-Job -Job $jobs -Wait -AutoRemoveJob
            Write-Host "RESULT..."  

            try {
                $scope = New-Object -TypeName System.Transactions.TransactionScope

                $report | ForEach-Object {
                    $item = $_ | ConvertTo-Json -Depth 2 | ConvertFrom-Json

                    $query = "EXEC [dbo].[usp_ServicesLog_Add] 
                        @JournalGuid = '$guid',
                        @ServiceId = '$($item.Id)',
                        @ServiceUrl = '$(if ($item.CheckType -eq "API") { $item.Object } else { $item.Object + ":" + $item.Port })',
                        @ServiceStatus = '$(if ($item.Status) { "OK"} else { "ERROR" })'"
                    Invoke-SqlCmd -Query $query -ServerInstance $config.SqlInstance -Username $config.User -Password $config.Password -Database $config.Database -ErrorAction Stop
                    $query = "EXEC [dbo].[usp_Services_UpdateStatus] 
                        @Id = '$($item.Id)', 
                        @Status = '$(if ($item.Status) { 1 } else { 0 })'"
                    Invoke-SqlCmd -Query $query -ServerInstance $config.SqlInstance -Username $config.User -Password $config.Password -Database $config.Database -ErrorAction Stop

                    if ($item.status -eq $False) { $errorCount += 1 }
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
        $query = "EXEC [dbo].[usp_ServicesLog_Add] 
                @JournalGuid = '$guid',
                @ServiceId = '0',
                @ServiceUrl = '',
                @ServiceStatus = 'END'"
        Invoke-SqlCmd -Query $query -ServerInstance $config.SqlInstance -Username $config.User -Password $config.Password -Database $config.Database -ErrorAction Stop
    }
    End {
        if ($errorCount -gt 0) {
            #$ErrorCount 
            <#
        Invoke-WebRequest -Headers @{} `
                  -Method POST `
                  -Body (@{}|ConvertTo-Json) `
                  -Uri url `
                  -ContentType application/json
    #>
            $uri = $config.RootUrl + "/api/SendAlert?jGuid=$Guid"
    
            try {
                Invoke-WebRequest -Method POST -Uri $uri -ContentType "application/json" | Out-Null
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
