$rootPath = (Split-Path $MyInvocation.MyCommand.Path)
. $rootPath/Libs.ps1
$config = Get-Content $rootPath\config.json | ConvertFrom-Json

<#
$username = 'Admin'
$password = 'hh010898'

$computer = $env:COMPUTERNAME
$env:COMPUTERNAME
Add-Type -AssemblyName System.DirectoryServices.AccountManagement
$obj = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('machine',
    $computer)
$obj.ValidateCredentials($username, $password) 
#>
# Evaluate UsedSpace details
$User = "LAMVT1FINTECH\lamvt"
$Password = ConvertTo-SecureString "hh010898" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($User, $Password)
$Credential | Export-CliXml -Path 'D:\Repo\Personal\Github\DevOps\Powershell\cred_lamvt.xml'
#$Credential = Get-Credential LAMVT1FINTECH\Admin
#$Credential | Test-Cred

#$Credential = Get-Credential

$params = @{
        SqlInstance     = $config.SqlInstance
        Database        = $config.DbName
        Verbose         = $true
    }
Get-DbaDbSpace @params | ForEach-Object {
    $Total += $_.FileSize
}

"{0:N}" -f $Total 

# if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) 

#Test-DbaConnection @params
#EXIT


