Import-Module SqlServer
$SQLInstance = "LAMVT1FINTECH,6699"
$SQLDatabase = "SMDB"
$SQLUsername = "sa"
$SQLPassword = "lamvt84" 
# Example of SQL Select query to pull data from a specific database table
$SQLQuery1 = "USE $SQLDatabase
SELECT * FROM dbo.ServicesLog"
$SQLQuery1Output = Invoke-Sqlcmd -query $SQLQuery1 -ServerInstance $SQLInstance -Username $SQLUsername -Password $SQLPassword
# Showing count of rows returned
$SQLQuery1Output.Count
# Selecting first 100 results
$SQLQuery1OutputTop100List = $SQLQuery1Output | select -first 100
$SQLQuery1OutputTop100List
# Selecting customer by ID
$SQLQuery1OutputCustomer = $SQLQuery1Output | Where-Object { $_.ServiceId -eq "1" }
$SQLQuery1OutputCustomer 