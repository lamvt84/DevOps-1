$manifest = @{
    Path                = 'HealthCheck.psd1'
    RootModule          = 'HealthCheck.psm1' 
    Author              = 'Louis Vu'
    CompanyName         = 'IrisTech'
    FunctionsToExport   = 'Invoke-HealthCheck'
    CmdletsToExport     = ''
    VariablesToExport   = ''
    AliasesToExport     = ''
    PowerShellVersion   = '5.0'
    Tags                = 'HealthCheck', 'Troubleshooting', 'Testing'

}
New-ModuleManifest @manifest


#Import-Module .\HealthCheck

#GetInfo $Env:COMPUTERNAME
