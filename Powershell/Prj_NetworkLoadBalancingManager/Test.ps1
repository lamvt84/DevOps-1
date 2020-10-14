$Nodename1 = "mbfhn-partner01.paymobi.internal"
$Nodename2 = "mbfhn-partner02.paymobi.internal"

$MyCluster = Get-NlbCluster "mbfhn-partner01.paymobi.internal"

$MyNode1 = $MyCluster | Get-NlbClusterNode -Hostname $Nodename1
$MyNode2 = $MyCluster | Get-NlbClusterNode -Hostname $Nodename2

$MyNode1
$MyNode2