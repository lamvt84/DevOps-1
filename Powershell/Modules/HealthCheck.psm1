function Invoke-HealthCheck {
    <#     
    .SYNOPSIS     
        Test port from server. 
        Call Api with GET method.
        
    .DESCRIPTION   
        Test port from server. 
        Call Api with GET method.
      
    .PARAMETER Object   
        Name, ipaddress of server to test the port connection on. 
        Api url    
        
    .PARAMETER Port   
        Port to test
    
    .PARAMETER Tcp   
        Use tcp port  
       
    .PARAMETER Udp   
        Use udp port   
    
    .PARAMETER Api   
        Use Api
    
    .PARAMETER UDPTimeOut  
        Sets a timeout for UDP port query. (In milliseconds, Default is 10000)   
        
    .PARAMETER TCPTimeOut  
        Sets a timeout for TCP port query. (In milliseconds, Default is 10000)
           
    .PARAMETER APITimeOut  
        Sets a timeout for Api query. (In seconds, Default is 3)      
    
    .NOTES
        https://gallery.technet.microsoft.com/scriptcenter/97119ed6-6fb2-446d-98d8-32d823867131

    .LINK 
        https://gallery.technet.microsoft.com/scriptcenter/97119ed6-6fb2-446d-98d8-32d823867131

    .EXAMPLE     
        Invoke-HealthCheck -Object 'server' -Port 80
        Checks port 80 on server 'server' to see if it is listening
        
    .EXAMPLE     
        'server' | Invoke-HealthCheck -port 80
        Checks port 80 on server 'server' to see if it is listening  
        
    .EXAMPLE     
        Invoke-HealthCheck -Object @("server1","server2") -port 80   
        Checks port 80 on server1 and server2 to see if it is listening   
    
    .EXAMPLE     
        Invoke-HealthCheck -Object 'http://api/' -Api
        Call api with GET method return http status 
        
    .EXAMPLE 
        Invoke-HealthCheck -Object dc1 -Port 17 -udp -UDPtimeout 10000 
        
        Server   : dc1 
        Port     : 17 
        TypePort : UDP 
        Open     : True 
        Notes    : "My spelling is Wobbly.  It's good spelling but it Wobbles, and the letters 
                get in the wrong places." A. A. Milne (1882-1958) 
        
        Description 
        ----------- 
        Queries port 17 (qotd) on the UDP port and returns whether port is open or not 
        
    .EXAMPLE     
        (Get-Content hosts.txt) | Invoke-HealthCheck -port 80   
        Checks port 80 on servers in host file to see if it is listening  
        
    .EXAMPLE     
        Invoke-HealthCheck -Object (Get-Content hosts.txt) -Port 80   
        Checks port 80 on servers in host file to see if it is listening  
            
    .EXAMPLE     
        Invoke-HealthCheck -computer (Get-Content hosts.txt) -Port @(1..59)   
        Checks a range of ports from 1-59 on all servers in the hosts.txt file       
                
    #>   
    [cmdletbinding(   
        DefaultParameterSetName = '',   
        ConfirmImpact = 'low'   
    )]   
    Param(
        [Parameter(   
            Mandatory = $True,   
            Position = 0,
            ParameterSetName = '',   
            ValueFromPipeline = $True)]   
        [array]$Object,   
        [Parameter(
            Mandatory = $False,   
            ParameterSetName = '')]   
        [array]$Port,
        [Parameter(               
            Mandatory = $False,   
            ParameterSetName = '')]   
        [switch]$Tcp,
        [Parameter(   
            Mandatory = $False,   
            ParameterSetName = '')]   
        [switch]$Udp,
        [Parameter(   
            Mandatory = $False,   
            ParameterSetName = '')]   
        [switch]$Api,
        [Parameter(   
            Mandatory = $False,   
            ParameterSetName = '')]   
        [int]$TCPtimeout = 10000,   
        [Parameter(   
            Mandatory = $False,   
            ParameterSetName = '')]   
        [int]$UDPtimeout = 10000,
        [Parameter(   
            Mandatory = $False,   
            ParameterSetName = '')]   
        [int]$APITimeOut = 3
    )
    Begin {
        If (!$Tcp -AND !$Udp -AND !$Api) { $Tcp = $True }
        
        $ErrorActionPreference = "SilentlyContinue"   
        $Result = @()   
    }   
    Process {       
        ForEach ($obj in $Object) { 
            If ($Api) {
                #Create temporary holder
                $Result += (Test-Api $obj $APITimeOut)
            }
            Else {
                ForEach ($p in $port) {
                    If ($tcp) {     
                        $Result += (Test-Tcp $obj $p $TCPtimeout)
                    }       
                    If ($udp) {   
                        $Result += (Test-Udp $obj $p $UDPtimeout)
                    }
                } 
            }  
        }                   
    }   
    End {
        $Result  
    } 
}

function Test-Api{
    [cmdletbinding(   
        DefaultParameterSetName = '',   
        ConfirmImpact = 'low'   
    )]
    Param(
        [Parameter(   
            Mandatory = $true,   
            ParameterSetName = '')]   
        [string]$Url
        ,
        [Parameter(   
            Mandatory = $False,   
            ParameterSetName = '')]   
        [int]$ApiTimeOut = 3
    )
    # For untrusted SSL
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

    $Result = "" | Select-Object Object, Port, CheckType, Status, Notes

    try {
        Write-Verbose "Get web request http status"
        $Response = Invoke-WebRequest -Uri $Url -Method GET -TimeoutSec $ApiTimeOut
		
        $Result.Object = $Url  
        $Result.Port = ""
        $Result.CheckType = "API"   
        $Result.Status = ($Response.StatusCode -eq 200)
        $Result.Notes = $Response.StatusDescription
    }
    catch [System.Net.WebException]{
        Write-Verbose "Exception: Bad HTTP response"
        $Result.Object = $Url  
        $Result.Port = ""
        $Result.CheckType = "API"   
        $Result.Status = $False
        $Result.Notes = "Exception: Bad HTTP response"
    }
    finally{
		$Result
	}
}
function Test-Tcp {
    [cmdletbinding(   
        DefaultParameterSetName = '',   
        ConfirmImpact = 'low'   
    )]
    Param(
        [Parameter(   
            Mandatory = $true,   
            ParameterSetName = '')]   
        [string]$Address
        ,
        [Parameter(   
            Mandatory = $true,   
            ParameterSetName = '')]   
        [string]$Port
        ,
        [Parameter(   
            Mandatory = $False,   
            ParameterSetName = '')]   
        [int]$TcpTimeOut = 10000
    )
    $Result = "" | Select-Object Object, Port, CheckType, Status, Notes
    
    $TcpObject = new-Object System.Net.Sockets.TcpClient    
    $Connect = $tcpobject.BeginConnect($Address, $Port, $null, $null)   
    $Wait = $connect.AsyncWaitHandle.WaitOne($TcpTimeOut, $False)   
    #If timeout   
    If (!$Wait) {   
        #Close connection   
        $TcpObject.Close()   
        Write-Verbose "Connection Timeout"   
        #Build report   
        $Result.Object = $Address   
        $Result.Port = $Port   
        $Result.CheckType = "TCP"   
        $Result.Status = $False   
        $Result.Notes = "Connection to port $($Port) Timed Out"   
    }
    Else {   
        $Error.Clear()   
        $TcpObject.EndConnect($Connect) | out-Null   
        #If error   
        If ($Error[0]) {
            [string]$ErrorString = ($Error[0].exception).message   
            $Message = (($ErrorString.Split(":")[1]).Replace('"', "")).TrimStart()   
            $IsError = $True   
        }
        $TcpObject.Close()   
      
        If ($IsError) {
            $Result.Object = $Address   
            $Result.Port = $Port
            $Result.CheckType = "TCP"   
            $Result.Status = $False   
            $Result.Notes = "$message"   
        }
        Else {
            $Result.Object = $obj   
            $Result.Port = $p   
            $Result.CheckType = "TCP"   
            $Result.Status = $True
            $Result.Notes = "OK"   
        }   
    }      
    $Result  
}
function Test-Udp {
    [cmdletbinding(   
        DefaultParameterSetName = '',   
        ConfirmImpact = 'low'   
    )]
    Param(
        [Parameter(   
            Mandatory = $true,   
            ParameterSetName = '')]   
        [string]$Address
        ,
        [Parameter(   
            Mandatory = $true,   
            ParameterSetName = '')]   
        [string]$Port
        ,
        [Parameter(   
            Mandatory = $False,   
            ParameterSetName = '')]   
        [int]$UdpTimeOut = 10000
    )
    $Result = "" | Select-Object Object, Port, CheckType, Status, Notes
   
    $UdpObject = new-Object System.Net.Sockets.Udpclient     
    $UdpObject.Client.ReceiveTimeout = $UdpTimeOut  
                  
    Write-Verbose "Making UDP connection to remote server"  
    $UdpObject.Connect("$Address", $Port)  
    
    Write-Verbose "Sending message to remote host"  
    $Obj = new-object System.text.AsciiEncoding  
    $ByteForSent = $Obj.GetBytes("$(Get-Date)")  
    [void]$UdpObject.Send($ByteForSent, $ByteForSent.Length)  
 
    Write-Verbose "Creating remote endpoint"  
    $RemoteEndPoint = New-Object System.Net.IpEndPoint([System.Net.IpAddress]::Any, 0)  
    Try {  
        Write-Verbose "Waiting for message return"  
        $ReceiveBytes = $UdpObject.Receive([ref]$RemoteEndPoint)  
        [string]$ReturnData = $Obj.GetString($ReceiveBytes) 
        If ($ReturnData) { 
            Write-Verbose "Connection Successful"   
            
            $Result.Object = $Address  
            $Result.Port = $Port   
            $Result.CheckType = "UDP"  
            $Result.Status = $True
            $Result.Notes = "Connection Successful"
            $UdpObject.Close()    
        }                        
    }
    Catch {
        If ($Error[0].ToString() -match "\bRespond after a period of time\b") {
            $UdpObject.Close()   
            
            If (Test-Connection -comp $Address -count 1 -quiet) {  
                Write-Verbose "Connection Open"   
                
                $Result.Object = $Address   
                $Result.Port = $Port
                $Result.CheckType = "UDP"
                $Result.Status = $True   
                $Result.Notes = "Respond after a period of time"  
            }
            Else {                  
                Write-Verbose "Host maybe unavailable"   
                
                $Result.Object = $Address   
                $Result.Port = $Port
                $Result.CheckType = "UDP"
                $Result.Status = $False   
                $Result.Notes = "Unable to verify if port is open or if host is unavailable."                                  
            }                          
        }
        ElseIf ($Error[0].ToString() -match "forcibly closed by the remote host" ) {              
            $UdpObject.Close()   
            Write-Verbose "Connection Timeout"   
           
            $Result.Object = $Address   
            $Result.Port = $Port
            $Result.CheckType = "UDP"
            $Result.Status = $False   
            $Result.Notes = "Connection to Port Timed Out"
        }
        Else {                                
            $UdpObject.close()  
        }  
    }      
    finally {
        $Result
    }
}
