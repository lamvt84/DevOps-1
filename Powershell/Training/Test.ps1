$item = [System.DateTimeOffset]::Now;
#$item

$rootPath = (Split-Path $MyInvocation.MyCommand.Path)

$server = Get-Content $rootPath\config.json | ConvertFrom-Json
#Write-Host $server.SqlInstance


Function Test-ScriptBlock
{
    [CmdletBinding()]
    Param
    ( 
        [Parameter(ValueFromPipeline=$true, Mandatory = $true)]
        [int]$Number        
    )
    BEGIN
    {
        Write-Host "In Begin block"
        $jGuid = New-Guid
        $set = (1,2,3,4,5,6)
        $set
    }
 
    PROCESS
    {
        Write-Host "In Process block"   
        
        $item = $set | WHERE-Object { $_ -ne $number }
        $item
    }
    END
    {
        Write-Host "In End block"
    }
} 
#1,2,3 | Test-ScriptBlock
<#
@{Id = 31; Url = http://171.244.52.202:8245/health; IpAddress = 171.244.52.202; Port = 8245; GroupTypeId = 2 }
@{Id = 32; Url = http://171.244.52.202:8247/health; IpAddress = 171.244.52.202; Port = 8247; GroupTypeId = 2 }
@{Id = 33; Url = http://171.244.52.202:8248/health; IpAddress = 171.244.52.202; Port = 8248; GroupTypeId = 2 }
@{Id = 34; Url = http://171.244.52.202:8249/health; IpAddress = 171.244.52.202; Port = 8249; GroupTypeId = 2 }
@{Id = 35; Url = https://171.244.52.202:7866/health; IpAddress = 171.244.52.202; Port = 7866; GroupTypeId = 2 }
@{Id = 36; Url = http://171.244.52.202:7890/health; IpAddress = 171.244.52.202; Port = 7890; GroupTypeId = 2 }
@{Id = 37; Url = http://171.244.52.202:7881/health; IpAddress = 171.244.52.202; Port = 7881; GroupTypeId = 2 }
@{Id = 38; Url = http://171.244.52.202:7879/health; IpAddress = 171.244.52.202; Port = 7879; GroupTypeId = 2 }
@{Id = 39; Url = http://171.244.52.202:7884/health/check/ContentService; IpAddress = 171.244.52.202; Port = 7884; GroupTypeId = 2 }
@{Id = 40; Url = http://171.244.52.202:7884/health/check/MessagingService; IpAddress = 171.244.52.202; Port = 7884; GroupTypeId = 2 }
@{Id = 41; Url = http://171.244.52.202:7884/health/check/UtilityService; IpAddress = 171.244.52.202; Port = 7884; GroupTypeId=2}
#>
$rootPath = (Split-Path $MyInvocation.MyCommand.Path)
Import-Module $rootPath/Modules/HealthCheck

#$result = Invoke-HealthCheck -DnsName 171.244.52.202 -Port 7879 -Type 2
#Write-Host "Return: $result"

@{
    title       = "game result"    
    attachments = "a"
} | ConvertTo-Json -Depth 1