function Invoke-ServiceControl {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [System.String]
        # ServerName
        $ServerName
        ,
        [parameter(Mandatory = $true)]
        [ValidateRange(1, 2)]
        [System.Int32]
        # ServerName
        $Type
        ,
        [parameter(Mandatory = $false)]
        [System.String]
        # ServiceName
        $ServiceName
        ,
        [parameter(Mandatory = $false)]
        [System.String]
        # SiteName
        $SiteName
        ,
        [parameter(Mandatory = $false)]       
        [System.String]
        # SiteName
        $AppPoolName
        ,
        [parameter(Mandatory = $true)]
        [ValidateRange("START", "STOP")]
        [System.String]
        # Type of health check process (1: tcp, 2: api)
        $Action
        ,
        [parameter(Mandatory = $false)]
        [ValidateRange(1, 10)]
        [System.Int32]
        $Delay = 5        
    )
    function Invoke-UpdateServiceStatus {
        Param([string]$ServerName, [string]$ServiceName, [string]$Action)
        if ($null -eq $ServiceName) { return }
        #Initialize variables:
        $WaitForIt = ""
        $Verb = ""
        $Result = "FAILED"
        $Svc = (Get-Service -ComputerName $ServerName -Name $ServiceName)

        Write-Host "===================================================="
        Write-Host "SERVER: $ServerName"
        Write-Host "SERVICE: $ServiceName"
        Write-host "STATUS: $($Svc.status)"

        Switch ($Svc.status) {
            "Stopped" {
                if ($Action -eq "START") {
                    Write-host "STARTING ..."
                    $Verb = "start"
                    $WaitForIt = 'Running'
                    $Svc.Start()
                }
            }
            "Running" {
                if ($Action -eq "STOP") {
                    Write-host "STOPPING ..."
                    $Verb = "stop"
                    $WaitForIt = 'Stopped'
                    $Svc.Stop()
                }
            }
            Default {
                Write-host "$ServiceName is $($Svc.status).  Taking no action."
            }
        }
        if ($WaitForIt -ne "") {
            Try {
                # For some reason, we cannot use -ErrorAction after the next statement:
                $Svc.WaitForStatus($WaitForIt, '00:02:00')
            }
            Catch {
                Write-Host "After waiting for 2 minutes, $ServiceName failed to $Verb."
            }
            $Svc = (Get-Service -ComputerName $ServerName -Name $ServiceName)
            if ($Svc.status -eq $WaitForIt) { $Result = 'SUCCESS' }
            Write-host "$Result"            
        }
        Write-Host "===================================================="
        Write-Host "`n"
        Return 
    }
    function Invoke-UpdateIISWebsiteStatus {        
        Param([string]$ServerName, [string]$AppPoolName, [string]$SiteName, [string]$Action)
        if ($null -eq $AppPoolName) { return }
        if ($null -eq $SiteName) { return  }
        $WaitForIt = ""
       
        $State = Invoke-Command -ComputerName $ServerName -ScriptBlock {
            Import-Module WebAdministration   
            $ResultSet = @{
                WebState     = (Get-WebsiteState $using:SiteName).Value
                AppPoolState = (Get-WebAppPoolState $using:AppPoolName).Value
            }
            Write-Output ($ResultSet | ConvertTo-Json | ConvertFrom-Json)
        }

        Write-Host "===================================================="
        Write-Host "SERVER: $ServerName"
        Write-Host "SITE: $SiteName"
        Write-host "WEB STATUS: $($State.WebState)"
        Write-host "APP POOL STATUS: $($State.AppPoolState)"

        Switch ($State.WebState) {
            "Stopped" {
                if ($Action -eq "START") {
                    Write-host "STARTING ..."
                    $WaitForIt = "Started"               
                    Invoke-Command -ComputerName $ServerName -ScriptBlock {
                        Import-Module WebAdministration                        
                        Start-WebSite $using:SiteName
                        if ($using:State.AppPoolState -eq "Stopped") { Start-WebAppPool $using:AppPoolName }
                    }
                }
            }
            "Started" {
                if ($Action -eq "STOP") {
                    Write-host "STOPPING ..."
                    $WaitForIt = "Stopped"
                    Invoke-Command -ComputerName $ServerName -ScriptBlock {
                        Import-Module WebAdministration
                        Stop-WebSite $using:SiteName
                        if ($using:State.AppPoolState -eq "Started") { Stop-WebAppPool $using:AppPoolName }
                    }
                }
            }
            Default {
                Write-host "$SiteName is $($State.WebState).  Taking no action."
            }
        }

        if ($WaitForIt -ne "") {
            Start-Sleep -s $Delay

            $State = Invoke-Command -ComputerName $ServerName -ScriptBlock {
                Import-Module WebAdministration   
                $ResultSet = @{
                    WebState     = (Get-WebsiteState $using:SiteName).Value
                    AppPoolState = (Get-WebAppPoolState $using:AppPoolName).Value
                }
                Write-Output ($ResultSet | ConvertTo-Json | ConvertFrom-Json)
            }
            
            if ($State.WebState -eq $WaitForIt -AND $State.AppPoolState -eq $WaitForIt) { $Result = "SUCCESS" }
            else { $Result = "FAILED" }
            Write-host "$Result"
        }
        Write-Host "===================================================="
        Write-Host "`n"
        Return
    }

    switch ($Type) {
        1 { Invoke-UpdateServiceStatus -ServerName $ServerName -ServiceName $ServiceName -Action $Action }
        2 { Invoke-UpdateIISWebsiteStatus -ServerName $ServerName -SiteName $SiteName -AppPoolName $AppPoolName -Action $Action }
        Default { Write-Host "Do nothing" }
    }   
}