Param(   
    [string] $Type
)
$Type
$set = "F,D,L"
$possibleValues = $set
$set | ForEach-Object { $_.Contains($Type) }

$User = "lamvt"
$Password = ConvertTo-SecureString "hh010898" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($User, $Password)
$Query = "USE [master]
GO
CREATE LOGIN [LOUISVU\administrator] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [LOUISVU\administrator]
GO
"

Invoke-Sqlcmd -ServerInstance LabEDW\SQL2019DW -Credential $Credential -Query $Query