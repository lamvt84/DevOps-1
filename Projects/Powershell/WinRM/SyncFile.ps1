$rootPath = $MyInvocation.MyCommand.Path | Split-Path | Split-Path
$serverFilePath = "{0}\Config\server.csv" -F $rootPath
$syncfilePath = "{0}\Config\synclist.csv" -F $rootPath
#$dbFilePath = "{0}\Config\db.csv" -F $rootPath

#$dbList = Get-Content -Path $dbFilePath

$serverList = Import-Csv -Path $serverFilePath -Delimiter "," -Header "server_name","ip_address","user","password","dest_path"
$syncList = Import-Csv -Path $syncfilePath -Delimiter "," -Header "root_path", "relative_path"

$serverList | Foreach-Object {
    $server = $_
    $serverCred = New-Object System.Management.Automation.PSCredential($server.user, (ConvertTo-SecureString $server.password -AsPlainText -Force))
	
    $session = New-PSSession -ComputerName $server.ip_address -Credential $serverCred    
	$syncList | ForEach-Object {
        # $source = "{0}\{1}" -F $_.root_path, $_.relative_path
        # $dest = "{0}\{1}" -F $server.dest_path, $_.relative_path
        # Copy-Item -Path $source -Destination $dest -ToSession $session

        $s = Invoke-Command -Session $session -Command { Get-Service | Where-Object { $_.Name -eq 'metricbeat' } | Select-Object "status" -First 1 }

        "{0} - {1}" -F $server.server_name, $s
    }
	$session | Remove-PSSession
}

# config firewall for WinRM
function SetFirewall {
    Invoke-Command -Session $session -Command { 
        Get-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)" | ForEach-Object {
            $fw = $_ | Get-NetFirewallAddressFilter
            if ($_.Profile -eq "Public") {
                $ip = @("LocalSubnet","172.16.13.27")					
                $fw | Set-NetFirewallAddressFilter -RemoteAddress $ip
            }
        }
        Get-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)" | Where-Object {$_.Profile -eq "Public"} | Get-NetFirewallAddressFilter
    }
}