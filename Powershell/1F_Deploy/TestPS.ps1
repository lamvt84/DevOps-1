$ipaddress = "171.244.52.101"
$port = "6123"
#$connection = New-Object System.Net.Sockets.TcpClient($ipaddress, $port)
#if ($connection.Connected) {
#    Write-Host "Success"
#}
#else {
#    Write-Host "Failed"
#}

function Test-Port {

    [CmdletBinding()]
    Param (
        [string] $ComputerName,
        [int] $Port,
        [int] $Delay = 1,
        [int] $Count = 3
    )

    function Test-TcpClient ($IPAddress, $Port) {

        $TcpClient = New-Object Net.Sockets.TcpClient
        Try { $TcpClient.Connect($IPAddress, $Port) } Catch {}

        If ($TcpClient.Connected) { $TcpClient.Close(); Return $True }
        Return $False

    }

    function Invoke-Test ($ComputerName, $Port) {

        Try { [array]$IPAddress = [System.Net.Dns]::GetHostAddresses($ComputerName) | Select-Object -Expand IPAddressToString } 
        Catch { Return $False }

        [array]$Results = $IPAddress | % { Test-TcpClient -IPAddress $_ -Port $Port }
        If ($Results -contains $True) { Return $True } Else { Return $False }

    }

    for ($i = 1; ((Invoke-Test -ComputerName $ComputerName -Port $Port) -ne $True); $i++) {
        if ($i -ge $Count) {
            Write-Warning "Timed out while waiting for port $Port to be open on $ComputerName!"
            Return $false
        }

        Write-Warning "Port $Port not open, retrying..."
        Sleep $Delay
    }

    Return $true

}


Test-Port $ipaddress $port

#Test-NetConnection -Port 6123 -ComputerName "171.244.52.101" -InformationLevel "Detailed"