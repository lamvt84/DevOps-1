<#
    Database connection settings
#>
# Config
$SqlInstance = "LAMVT1FINTECH,6699"
$Database = "SMDB"
$User = "sa"
$Password = "lamvt84"

$AlertUrl = "http://192.168.1.136:8123/api/SendAlert"


Import-Module ./Modules/HealthCheck

$jGuid = New-Guid
$Query = "SELECT * FROM dbo.[Services] s JOIN dbo.Groups g ON s.GroupId = g.Id WHERE g.GroupTypeId = 1 AND Enable = 1"
$QueryResult = Invoke-SqlCmd -Query $Query -ServerInstance $SqlInstance -Username $User -Password $Password -Database SMDB |
                SELECT Id, Url
$count = 0

foreach ($item in $QueryResult ) {
    
    $Id = $item.Id
    $Url = $item.Url
    $IpAddress = ($Url.Split("/")[2]).Split(":")[0]
    $Port = ($Url.Split("/")[2]).Split(":")[1]
    
    $HealthCheckResult = Invoke-HealthCheck -DnsName $IpAddress -Port $Port -Type 1

    $status = if ($HealthCheckResult -eq $true)  { "1" } else { "0" }
    if ($status -eq 0) { $count += 1 }

    $Query = "EXEC [dbo].[usp_Services_UpdateStatus] @Id = $Id, @Status = $status"
    Invoke-SqlCmd -Query $Query -ServerInstance $SqlInstance -Username $User -Password $Password -Database SMDB
}

if ($count -gt 0)
{
    <#
        Invoke-WebRequest -Headers @{} `
                  -Method POST `
                  -Body (@{}|ConvertTo-Json) `
                  -Uri url `
                  -ContentType application/json
    #>
    Invoke-WebRequest -Method POST `
                  -Body (@{"jGiud" = $jGuid;} | ConvertTo-Json) `
                  -Uri $AlertUrl`
                  -ContentType application/json
}
