$jGuid = New-Guid
$AlertUrl = "https://localhost:44358/api/SendAlert"

$AlertUri = $AlertUrl + "?jGuid=$jGuid"
$AlertUri
try {
        Invoke-WebRequest -Method POST `
                        -Uri $AlertUri `
                        -ContentType "application/json"                       
    }
    catch {
        Write-Warning $Error[0]   
    }    