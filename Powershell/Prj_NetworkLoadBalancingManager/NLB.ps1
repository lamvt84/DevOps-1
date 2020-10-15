@{

    RootModule        = ''

    ModuleVersion     = '1.0'

    GUID              = '4d0ba268-c91c-4749-9ce4-245ff80d989e'

    Author            = 'Louis Vu'

    CompanyName       = '1FINTECH'

    Copyright         = '(c) 2020 Louis Vu. All rights reserved.'

    Description       = 'Windows Network Load Balancing Management'

    PowerShellVersion = '5.1.18362.752'

    FunctionsToExport = ''

    PrivateData       = @{

        PSData = @{

            Tags       = 'Network Load Balancing', 'Troubleshooting', 'NLB'

            ProjectUri = ''

        } # End of PSData hashtable

    } # End of PrivateData hashtable

} | Out-Null

$Nodename1 = "mbfhn-partner01.paymobi.internal"
$Nodename2 = "mbfhn-partner02.paymobi.internal"

$MyCluster = Get-NlbCluster "mbfhn-partner01.paymobi.internal"

$MyNode1 = $MyCluster | Get-NlbClusterNode -NodeName $Nodename1
$MyNode2 = $MyCluster | Get-NlbClusterNode -NodeName $Nodename2

# Process Node
if ($MyNode1.State -match "converged") {
    $MyNode1 | Stop-NlbClusterNode -Drain
}
if ($MyNode1.State -match "stopped") {		
    $MyNode1 | Start-NlbClusterNode
}