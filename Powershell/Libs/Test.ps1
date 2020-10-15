$manifest = @{
    Path                = 'D:\\Repo\\Personal\\Github\\DevOps\\Powershell\\Modules\\HealthCheck.psd1'
    RootModule          = 'D:\\Repo\\Personal\\Github\\DevOps\\Powershell\\Modules\\HealthCheck.psm1' 
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
