function Invoke-HealthCheck() {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [System.String]
        # DNS name of target health check
        $DnsName
        ,
        [parameter(Mandatory = $true)]
        [System.String]
        # DNS port of target health check
        $Port
        ,
        [parameter(Mandatory = $false)]       
        [System.String]
        # url of health check api
        $Url
        ,
        [parameter(Mandatory = $false)]
        [ValidateRange(1, 2)]
        [System.Int32]
        # Type of health check process (1: tcp, 2: api)
        $Type = 1
        ,
        [parameter(Mandatory = $false)]
        [ValidateRange(1, 10)]
        [System.Int32]
        $Delay = 10
        ,
        [parameter(Mandatory = $false)]
        [ValidateRange(1, 5)]
        [System.Int32]
        $Count = 3
    )

    function Test-TcpClient ($IpAddress, $Port) {

        $TcpClient = New-Object Net.Sockets.TcpClient
        Try { $TcpClient.Connect($IpAddress, $Port) } Catch {}

        If ($TcpClient.Connected) { $TcpClient.Close(); Return $True }
        Return $False
    }

    function Invoke-Test ($DnsName, $Port) {

        Try { [array]$IpAddress = [System.Net.Dns]::GetHostAddresses($DnsName) | Select-Object -Expand IPAddressToString } 
        Catch { Return $False }

        [array]$Results = $IPAddress | % { Test-TcpClient -IPAddress $_ -Port $Port }
        If ($Results -contains $True) { Return $True } Else { Return $False }

    }

    function Invoke-ScriptTcpClient($DnsName, $Port) {        
        for ($i = 1; $i -le $Count; $i++) {
            $test = Invoke-Test -DnsName $DnsName -Port $Port
            if ($test -eq $true) {
                return $test
            }
            else {
                Write-Warning "Port $Port not open, retrying..."
                Start-Sleep $Delay
            }
        }
        Write-Warning "Timed out while waiting for port $Port to be open on $DnsName!"
        Return $false
    }

    function Invoke-ScriptApi($Url){   
        
        add-type @"
            using System.Net;
            using System.Security.Cryptography.X509Certificates;
            public class TrustAllCertsPolicy : ICertificatePolicy {
                public bool CheckValidationResult(
                    ServicePoint srvPoint, X509Certificate certificate,
                    WebRequest request, int certificateProblem) {
                    return true;
                }
            }
"@
        $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
        [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
        [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
        
        $status = Invoke-WebRequest -Uri $Url -Method GET

        if ($status.StatusCode -ne 200) { Return $false}
        Return $true
    }

    if ($Type -eq 2){
        $result = Invoke-ScriptTcpClient -DnsName $DnsName -Port $Port        
        Return $result
    }
    else {
        $result = Invoke-ScriptApi -Url $Url
        Return $result
    }

    Return $true
}