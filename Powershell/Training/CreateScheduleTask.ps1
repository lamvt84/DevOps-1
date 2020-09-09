$user = "Admin"
$pass = "hh010898"
$xmlPath = "D:\Web\PowershellCmd\API Health Check.xml"
$taskName = "Daily System Info Report"
$cmd = "Register-ScheduledTask -Xml (get-content '$xmlPath' | out-string) -TaskName '$taskName' -User $user -Password $pass –Force"

Invoke-Expression $cmd

