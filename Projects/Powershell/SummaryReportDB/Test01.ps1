#$ScriptPath = "D:\Repo\Personal\Github\DevOps\Powershell\SummaryReportDB\Test.ps1"
#Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`"" -Verb RunAs;

#$cred = Get-Credential "$env:COMPUTERNAME\Admin"

#$cred = Get-Credential "admin"
#Get-DbaDiskSpace -ComputerName $env:COMPUTERNAME -Credential $cred
$UserName = "sqlmonitor" 
$Password = ConvertTo-SecureString "**M00nj$--Hto##" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName , $Password 

#Test-DbaConnection -SqlInstance $env:COMPUTERNAME\SQL2019 -Credential $Credential
$credential = Import-CliXml -Path "D:\cred_lamvt.xml"
$Sb = [ScriptBlock]`
{
    #Get-DbaDbSpace -SqlInstance $env:COMPUTERNAME\SQL2019
    Test-DbaConnection -SqlInstance $env:COMPUTERNAME\SQL2019
}

Invoke-Command -ComputerName $env:COMPUTERNAME -Credential $Credential -ScriptBlock $Sb -ErrorAction Stop

$credential = Get-Credential "sqlmonitor"

$credential | Export-CliXml -Path 'D:\\Repo\\Personal\\Github\\DevOps\\Powershell\\cred_sqlmonitor.xml'

#$credential = Import-CliXml -Path "D:\cred.xml"

$credential = Import-CliXml -Path "D:\cred_tuongtm.xml"
$Sb = [ScriptBlock]`
{
    #Get-DbaDbSpace -SqlInstance $env:COMPUTERNAME\SQL2019
    Get-Service
}

Invoke-Command -ComputerName MobiPay -Credential $Credential -ScriptBlock $Sb -ErrorAction Stop