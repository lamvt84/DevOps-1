Param(
    [Parameter(Mandatory = $True)]    
    [System.String]
    $GroupType # 1: api, 2: tcp
)

<#
    Database connection settings
#>
# Config
$SqlInstance = "LAMVT1FINTECH\SQL2019"
$Database = "SMDB"
$User = "sqlmonitor"
$Password = "**M00nj$--Hto##"

$AlertUrl = "https://localhost:44358/api/SendAlert"
$jGuid = New-Guid

$rootPath = (Split-Path $MyInvocation.MyCommand.Path)
Import-Module $rootPath/Modules/HealthCheck


$Query = "SELECT s.Id, s.Url FROM dbo.[Services] s JOIN dbo.Groups g ON s.GroupId = g.Id WHERE g.GroupTypeId = $GroupType AND Enable = 1"
$QueryResult = Invoke-SqlCmd -Query $Query -ServerInstance $SqlInstance -Username $User -Password $Password -Database $Database |
                SELECT Id, Url
$count = 0

$Query = "EXEC [dbo].[usp_ServicesLog_Add]
                    @JournalGuid = '$jGuid',
                    @ServiceId = '0',
                    @ServiceUrl = '',
                    @ServiceStatus = 'START'"
Invoke-SqlCmd -Query $Query -ServerInstance $SqlInstance -Username $User -Password $Password -Database $Database

foreach ($item in $QueryResult ) {
    
    $Id = $item.Id
    $Url = $item.Url
    $IpAddress = ($Url.Split("/")[2]).Split(":")[0]
    $Port = ($Url.Split("/")[2]).Split(":")[1]

    try {
        #Write-Warning $Url
        if ($GroupType -eq 1) { $HealthCheckResult = Invoke-HealthCheck -DnsName $IpAddress -Port $Port -Type $GroupType -Url $Url }
        else { $HealthCheckResult = Invoke-HealthCheck -DnsName $IpAddress -Port $Port -Type $GroupType }

        $status = if ($HealthCheckResult -eq $true)  { "1" } else { "0" }
        if ($status -eq 0) { $count += 1 }

        $Query = "EXEC [dbo].[usp_ServicesLog_Add] 
                    @JournalGuid = '$jGuid',
                    @ServiceId = $($item.Id),
                    @ServiceUrl = '$Url',
                    @ServiceStatus = 'OK'"
        Invoke-SqlCmd -Query $Query -ServerInstance $SqlInstance -Username $User -Password $Password -Database $Database

        $Query = "EXEC [dbo].[usp_Services_UpdateStatus] 
                    @Id = $Id, 
                    @Status = $status"
        Invoke-SqlCmd -Query $Query -ServerInstance $SqlInstance -Username $User -Password $Password -Database $Database        
    }
    catch
    {
        #Write-Warning $Error[0]
        $count += 1
        $Query = "EXEC [dbo].[usp_ServicesLog_Add] 
                    @JournalGuid = '$jGuid',
                    @ServiceId = $($item.Id),
                    @ServiceUrl = '$Url',
                    @ServiceStatus = 'ERROR'"
        Invoke-SqlCmd -Query $Query -ServerInstance $SqlInstance -Username $User -Password $Password -Database $Database
        $Query = "EXEC [dbo].[usp_Services_UpdateStatus] 
                    @Id = $Id, 
                    @Status = 0"
        Invoke-SqlCmd -Query $Query -ServerInstance $SqlInstance -Username $User -Password $Password -Database $Database   
    }        
}
$Query = "EXEC [dbo].[usp_ServicesLog_Add] 
                    @JournalGuid = '$jGuid',
                    @ServiceId = '0',
                    @ServiceUrl = '',
                    @ServiceStatus = 'END'"
Invoke-SqlCmd -Query $Query -ServerInstance $SqlInstance -Username $User -Password $Password -Database $Database

$Query = "INSERT dbo.TaskSchedulerLog([Source],[Name],[Duration])
            SELECT $jGuid, 
            FROM dbo.GroupType gt
            OUTER APPLY (SELECT "

if ($count -gt 0)
{
    <#
        Invoke-WebRequest -Headers @{} `
                  -Method POST `
                  -Body (@{}|ConvertTo-Json) `
                  -Uri url `
                  -ContentType application/json
    #>
    $Uri = $AlertUrl + "?jGuid=$jGuid"
    
    try {
        $Result = Invoke-WebRequest -Method POST -Uri $Uri -ContentType "application/json"
    }
    catch {
        Write-Warning $Error[0]   
    }    
}