@{

    RootModule        = ''

    ModuleVersion     = '1.0'

    GUID              = '4d0ba268-c91c-4749-9ce4-245ff80d989e'

    Author            = 'Louis Vu'

    CompanyName       = '1FINTECH'

    Copyright         = '(c) 2020 Louis Vu. All rights reserved.'

    Description       = 'Services Health Check'

    PowerShellVersion = '5.1.18362.752'

    FunctionsToExport = ''

    PrivateData       = @{

        PSData = @{

            Tags       = 'HealthCheck', 'Troubleshooting', 'Testing'

            ProjectUri = ''

        } # End of PSData hashtable

    } # End of PrivateData hashtable

} | Out-Null

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
        Sets a timeout for UDP port query. (In milliseconds, Default is 1000)   
        
    .PARAMETER TCPTimeOut  
        Sets a timeout for TCP port query. (In milliseconds, Default is 1000)
           
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
            [int]$TCPtimeout=1000,   
        [Parameter(   
            Mandatory = $False,   
            ParameterSetName = '')]   
            [int]$UDPtimeout=1000,
        [Parameter(   
            Mandatory = $False,   
            ParameterSetName = '')]   
            [int]$APITimeOut=3
    )
    Begin {
        If (!$Tcp -AND !$Udp -AND !$Api) {$Tcp = $True}
        # As any errors will be noted in the output of the report     
        
        $ErrorActionPreference = "SilentlyContinue"   
        $report = @()   
    }   
    Process {       
        ForEach ($obj in $Object) { 
            If ($Api) {
                #Create temporary holder    
                $temp = "" | Select Object, Port, CheckType, Status, Notes
                try {
                    Write-Verbose "Get web request http status"
                    $Response = Test-Api -Url $obj -TimeoutSec $APITimeOut

                    $temp.Object = $obj  
                    $temp.Port = ""
                    $temp.CheckType = "API"   
                    $temp.Status = ($Response.StatusCode -eq 200)
                    $temp.Notes = $Response.StatusDescription
                }
                catch
                {
                    Write-Verbose "Exception: $($Error[0].ToString())"
                    $temp.Object = $obj  
                    $temp.Port = ""
                    $temp.CheckType = "API"   
                    $temp.Status = $False
                    $temp.Notes = "Exception: $($Error[0].ToString())"
                }
                finally {
                    #Merge temp array with report
                    $report += $temp
                }
            }
            Else {
                ForEach ($p in $port) {
                    If ($tcp) {     
                        #Create temporary holder    
                        $temp = "" | Select Object, Port, CheckType, Status, Notes
                        #Create object for connecting to port on computer   
                        $tcpobject = new-Object system.Net.Sockets.TcpClient   
                        #Connect to remote machine's port                 
                        $connect = $tcpobject.BeginConnect($obj,$p,$null,$null)   
                        #Configure a timeout before quitting   
                        $wait = $connect.AsyncWaitHandle.WaitOne($TCPtimeout,$False)   
                        #If timeout   
                        If(!$wait) {   
                            #Close connection   
                            $tcpobject.Close()   
                            Write-Verbose "Connection Timeout"   
                            #Build report   
                            $temp.Object = $obj   
                            $temp.Port = $p   
                            $temp.CheckType = "TCP"   
                            $temp.Status = $False   
                            $temp.Notes = "Connection to Port Timed Out"   
                        } Else {   
                            $error.Clear()   
                            $tcpobject.EndConnect($connect) | out-Null   
                            #If error   
                            If($error[0]){   
                                #Begin making error more readable in report   
                                [string]$string = ($error[0].exception).message   
                                $message = (($string.split(":")[1]).replace('"',"")).TrimStart()   
                                $failed = $True   
                            }   
                            #Close connection       
                            $tcpobject.Close()   
                            #If unable to query port to due failure   
                            If($failed){   
                                #Build report   
                                $temp.Object = $obj   
                                $temp.Port = $p   
                                $temp.CheckType = "TCP"   
                                $temp.Status = $False   
                                $temp.Notes = "$message"   
                            } Else{   
                                #Build report   
                                $temp.Object = $obj   
                                $temp.Port = $p   
                                $temp.CheckType = "TCP"   
                                $temp.Status = $True
                                $temp.Notes = ""   
                            }   
                        }      
                        #Reset failed value   
                        $failed = $Null       
                        #Merge temp array with report               
                        $report += $temp   
                    }       
                    If ($udp) {   
                        #Create temporary holder    
                        $temp = "" | Select Object, Port, CheckType, Status, Notes
                        #Create object for connecting to port on computer   
                        $udpobject = new-Object system.Net.Sockets.Udpclient 
                        #Set a timeout on receiving message  
                        $udpobject.client.ReceiveTimeout = $UDPTimeout  
                        #Connect to remote machine's port                 
                        Write-Verbose "Making UDP connection to remote server"  
                        $udpobject.Connect("$obj",$p)  
                        #Sends a message to the host to which you have connected.  
                        Write-Verbose "Sending message to remote host"  
                        $a = new-object system.text.asciiencoding  
                        $byte = $a.GetBytes("$(Get-Date)")  
                        [void]$udpobject.Send($byte,$byte.length)  
                        #IPEndPoint object will allow us to read datagrams sent from any source.   
                        Write-Verbose "Creating remote endpoint"  
                        $remoteendpoint = New-Object system.net.ipendpoint([system.net.ipaddress]::Any,0)  
                        Try {  
                            Write-Verbose "Waiting for message return"  
                            $receivebytes = $udpobject.Receive([ref]$remoteendpoint)  
                            [string]$returndata = $a.GetString($receivebytes) 
                            If ($returndata) { 
                            Write-Verbose "Connection Successful"   
                                #Build report   
                                $temp.Object = $obj  
                                $temp.Port = $p   
                                $temp.CheckType = "UDP"   
                                $temp.Status = "True"   
                                $temp.Notes = $returndata    
                                $udpobject.close()    
                            }                        
                        } Catch {  
                            Write-Host $Error[0]
                            If ($Error[0].ToString() -match "\bRespond after a period of time\b") {  
                                #Close connection   
                                $udpobject.Close()   
                                #Make sure that the host is online and not a False positive that it is open  
                                If (Test-Connection -comp $obj -count 1 -quiet) {  
                                    Write-Verbose "Connection Open"   
                                    #Build report   
                                    $temp.Object = $obj   
                                    $temp.Port = $p   
                                    $temp.CheckType = "UDP"
                                    $temp.Status = $True   
                                    $temp.Notes = ""  
                                } Else {  
                                    <#  
                                    It is possible that the host is not online or that the host is online,   
                                    but ICMP is blocked by a firewall and this port is actually open.  
                                    #>  
                                    Write-Verbose "Host maybe unavailable"   
                                    #Build report   
                                    $temp.Object = $obj
                                    $temp.Port = $p   
                                    $temp.CheckType = "UDP"   
                                    $temp.Status = $False   
                                    $temp.Notes = "Unable to verify if port is open or if host is unavailable."                                  
                                }                          
                            } ElseIf ($Error[0].ToString() -match "forcibly closed by the remote host" ) {  
                                #Close connection   
                                $udpobject.Close()   
                                Write-Verbose "Connection Timeout"   
                                #Build report 
                                $temp.Object = $obj
                                $temp.Port = $p   
                                $temp.CheckType = "UDP"   
                                $temp.Status = $False   
                                $temp.Notes = "Connection to Port Timed Out"
                            } Else {                                
                                $udpobject.close()  
                            }  
                        }      
                        Write-Host "End"
                        #Merge temp array with report               
                        $report += $temp   
                    }                                   
                } 
            }  
        }                   
    }   
    End {   
        #Generate Report   
        $report  
    } 
}

function Test-Api{   
        [CmdletBinding()]
        param(
            [parameter(Mandatory = $true)]
            [System.String]            
            $Url
            ,
            [parameter(Mandatory = $false)]
            [System.Int32]
            $TimeoutSec = 3
        )
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
        
        Invoke-WebRequest -Uri $Url -Method GET -TimeoutSec $APITimeOut
        }

function Test-HealthCheck {
    [CmdletBinding()]
    Param(       
        [Parameter(Mandatory = $true)]    
        [System.String]
        $Object,
        [Parameter(Mandatory = $false)]    
        [System.String]
        $Port,
        [Parameter(Mandatory = $true)]    
        [System.string]        
        $GroupTag
    )

    $result = switch ($GroupTag) {
        "TCP"   { 
                Invoke-HealthCheck -Object $Object -Port $Port -TCP
                break
        }
        "UDP"   { 
                Invoke-HealthCheck -Object $Object -Port $Port -UDP
                break
        }
        "API"   { 
                Invoke-HealthCheck -Object $Object -API
                break
        }
        default { 
                Write-Host "Nothing to do"
                break
        }
    }
    $result
}