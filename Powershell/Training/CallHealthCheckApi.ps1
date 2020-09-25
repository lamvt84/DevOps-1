#$url = "http://192.168.1.136:8123/Monitor/CollectHealthCheck"
$url = "http://171.244.52.202:8245/health"
$status = Invoke-WebRequest -Uri $url -Method GET 

$status.StatusCode