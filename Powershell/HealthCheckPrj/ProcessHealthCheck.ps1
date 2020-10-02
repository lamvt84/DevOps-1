[CmdletBinding()]
Param(    
    [Parameter(Mandatory = $False, ValueFromPipeline = $True)]    
    [array]
    $Object
)
$rootPath = (Split-Path $MyInvocation.MyCommand.Path)
. $rootPath/Libs.ps1

function Invoke-ProcessSpecialCase {
    [CmdletBinding()]
    Param(       
        [Parameter(
            Mandatory = $True,
            ValueFromPipeline = $True)]    
        [array]
        $Object # ServiceId list
    )
    
    Begin {
        $config = Get-Content $rootPath\config.json | ConvertFrom-Json
        $guid = New-Guid
        Write-Host "Guid: $guid"
        
        $ErrorActionPreference = "SilentlyContinue"
        
        $errorCount = 0          
        $initScript = [scriptblock]::Create(". $PSScriptRoot/Libs.ps1")

        $apiUrl = "$($config.RootUrl)/api_service/GetList"        
        try {
            $list = Invoke-WebRequest -Method GET -Uri $apiUrl -ContentType "application/json" | ConvertFrom-Json 
        }
        catch {        
            Write-Verbose $Error[0]
        }       
        $dataSet = $list.data | Where-Object { $Object -contains $_.id -AND $_.specialCase -eq 1 -AND $_.enable -eq 1 } `
                    | Select-Object Id, Url, groupTag, @{Name = 'IpAddress'; Expression = { ($_.Url.Split("/")[2]).Split(":")[0] } }`
                                            , @{Name='Port';Expression={($_.Url.Split("/")[2]).Split(":")[1]}}
        $dtStart = [datetime]::UtcNow
    }
    Process {
        if ($dataSet.Count -gt 0)
        {            
            $scriptBlock = [scriptblock] `
            {                    
                param($data, $config, $guid)
                $temp = "" | Select-Object Id, Object, Port, CheckType, Status, Notes 
                try {   
                    $response = switch ($data.groupTag) {
                        "API" {
                            Test-HealthCheck -Object $data.url -GroupTag $data.groupTag
                            break
                        }
                        default {                    
                            Test-HealthCheck -Object $data.IpAddress -Port $data.Port -GroupTag $data.groupTag
                            break
                        }
                    }                    
                    
                    $temp.Id = $data.Id
                    $temp.Object = $response[0].Object
                    $temp.Port = $response[0].Port    
                    $temp.CheckType = $data.groupTag
                    $temp.Status = $response[0].Status
                    $temp.Notes = $response[0].Notes   
                }
                catch {
                    Write-Verbose "$($Error[0]) = $($data.Url)"                    
                }                
                $temp
            }
            
            $jobs = $dataSet | ForEach-Object {
                $params = ($_, $config, $guid)
                Start-ThreadJob -ThrottleLimit $($dataSet.Count) -ArgumentList $params -ScriptBlock $scriptBlock `
                    -InitializationScript $initScript
            }

            Write-Verbose "Waiting for $($jobs.Count) jobs to complete..."
            
            $report = Receive-Job -Job $jobs -Wait -AutoRemoveJob
            Write-Verbose "RESULT..." 
            $report | Select-Object | Format-Table  | Out-String | Write-Verbose
        }
    }
    End {
        if ($dataSet.Count -gt 0) 
        {
            Write-Host "Total time elapsed: $([datetime]::UtcNow - $dtStart)"
            $uri = "{0}/api/UpdateHealthCheckSpecialCase?serviceId={1}&jGuid={2}&status=START&url=N" -f $config.RootUrl,$_.Id,$guid
            Invoke-WebRequest -Method POST -Uri $uri -ContentType "application/json" | Out-Null  
            
            $report | ForEach-Object {
                try {
                    $uri = "{0}/api/UpdateHealthCheckSpecialCase?serviceId={1}&jGuid={2}&status={3}&url={4}" `
                            -f $config.RootUrl,$_.Id,$guid,$(if ($_.Status) { "OK" } else { "ERROR" }),`
                            $(if ($_.CheckType -eq "API") { $_.Object } else { $_.Object + ":" + $_.Port })
                
                    Invoke-WebRequest -Method POST -Uri $uri -ContentType "application/json" | Out-Null           
                }
                catch {
                    Write-Verbose $Error[0]        
                }
                if ($_.Status -eq $False) { $errorCount += 1}
            }
            $uri = "{0}/api/UpdateHealthCheckSpecialCase?serviceId={1}&jGuid={2}&status=START&url=N" -f $config.RootUrl,$_.Id,$guid
            Invoke-WebRequest -Method POST -Uri $uri -ContentType "application/json" | Out-Null 

            if ($errorCount -gt 0) {
                try {
                    $uri = "{0}/api/SendAlert?jGuid={1}" -f $config.RootUrl,$guid
                    Invoke-WebRequest -Method POST -Uri $uri -ContentType "application/json" | Out-Null
                }
                catch {
                    Write-Verbose $Error[0]   
                }    
            }
        }
    }
}

function Invoke-ProcessCommonCaseAsync { 
    Begin
    {
        # Init
        $config = Get-Content $rootPath\config.json | ConvertFrom-Json
        $guid = New-Guid
        Write-Host "Guid: $guid"
        
        $ErrorActionPreference = "SilentlyContinue"
        $errorCount = 0
          
        $initScript = [scriptblock]::Create(". $PSScriptRoot/Libs.ps1")

        $query = "SELECT s.Id, s.Url, g.Tag
                FROM dbo.[Services] s 
                    LEFT JOIN dbo.Groups g ON s.GroupId = g.Id                     
                WHERE s.Enable = 1 AND s.SpecialCase = 0"
        $dataSet = Invoke-SqlCmd -Query $query -ServerInstance $config.SqlInstance -Username $config.User -Password $config.Password -Database $config.Database `
                    | Select-Object Id, Url, Tag, @{Name = 'IpAddress'; Expression = { ($_.Url.Split("/")[2]).Split(":")[0] } }`
                                            , @{Name='Port';Expression={($_.Url.Split("/")[2]).Split(":")[1]}}
        $dtStart = [datetime]::UtcNow
        $query = "EXEC [dbo].[usp_ServicesLog_Add]
                    @JournalGuid = '$Guid',
                    @ServiceId = '0',
                    @ServiceUrl = '',
                    @ServiceStatus = 'START'"
        Invoke-SqlCmd -Query $query -ServerInstance $config.SqlInstance -Username $config.User -Password $config.Password -Database $config.Database -ErrorAction Stop
    }
    Process
    {              
        if ($dataSet.Count -gt 0) 
        {    
            $scriptBlock = [scriptblock] `
            {    
                param($data, $config, $guid)
                $temp = "" | Select-Object Id, Object, Port, CheckType, Status, Notes 
                try {
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
                    
                    $temp.Id = $data.Id
                    $temp.Object = $response[0].Object
                    $temp.Port = $response[0].Port    
                    $temp.CheckType = $data.Tag
                    $temp.Status = $response[0].Status
                    $temp.Notes = $response[0].Notes   
                }
                catch {
                    Write-Verbose "$($Error[0]) = $($data.Url)"                    
                }                
                $temp
            }
            
            $jobs = $dataSet | ForEach-Object { 
                $params = ($_, $config, $guid)
                Start-ThreadJob -ThrottleLimit $($dataSet.Count) -ArgumentList $params -ScriptBlock $scriptBlock `
                    -InitializationScript $initScript
            }

            Write-Verbose "Waiting for $($jobs.Count) jobs to complete..."
            
            $report = Receive-Job -Job $jobs -Wait -AutoRemoveJob
            Write-Verbose "RESULT..." 
            $report | Select-Object | Format-Table  | Out-String | Write-Verbose

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
    }
    End {        
        $query = "EXEC [dbo].[usp_ServicesLog_Add] 
                @JournalGuid = '$guid',
                @ServiceId = '0',
                @ServiceUrl = '',
                @ServiceStatus = 'END'"
        Invoke-SqlCmd -Query $query -ServerInstance $config.SqlInstance -Username $config.User -Password $config.Password -Database $config.Database -ErrorAction Stop
        Write-Host "Total time elapsed: $([datetime]::UtcNow - $dtStart)"
        if ($errorCount -gt 0) {
            try {                
                $uri = "{0}/api/SendAlert?jGuid={1}" -f $config.RootUrl,$guid
                Invoke-WebRequest -Method POST -Uri $uri -ContentType "application/json" | Out-Null
            }
            catch {
                Write-Verbose $Error[0]   
            }    
        }
    }    
}

if ($Object) {    
    Invoke-ProcessSpecialCase -Object $Object
}
else {
    Invoke-ProcessCommonCaseAsync
}
