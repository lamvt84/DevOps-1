$user = ""
$pass = ""
$xmlPath = "TaskTemplate.xml"
$taskName = ""
$cmd = "Register-ScheduledTask -Xml (get-content '$xmlPath' | out-string) -TaskName '$taskName' -User $user -Password $pass –Force"

Invoke-Expression $cmd