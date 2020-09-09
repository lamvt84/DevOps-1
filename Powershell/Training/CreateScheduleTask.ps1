$user = "Admin"
$pass = "hh010898"
$xmlPath = "D:\Repo\Personal\Github\DevOps\Powershell\Training\API Health Check.xml"
$taskName = "Daily Service Monitor"
$cmd = "Register-ScheduledTask -Xml (get-content '$xmlPath' | out-string) -TaskName '$taskName' -User $user -Password $pass –Force"

Invoke-Expression $cmd

