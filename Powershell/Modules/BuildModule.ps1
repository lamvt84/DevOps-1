$manifest = @{
    Path                = 'NetworkLB.psd1'
    RootModule          = 'NetworkLB.psm1' 
    Author              = 'Louis Vu'
    CompanyName         = 'IrisTech'
    FunctionsToExport   = 'Invoke-NetworkLoadBalancing'
    CmdletsToExport     = ''
    VariablesToExport   = ''
    AliasesToExport     = ''
    PowerShellVersion   = '5.0'
    Tags                = 'NetworkLoadBalancing', 'Troubleshooting', 'Testing'

}
New-ModuleManifest @manifest


#Import-Module .\HealthCheck

#GetInfo $Env:COMPUTERNAME
