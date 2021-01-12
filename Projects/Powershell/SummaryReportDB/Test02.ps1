$RootPath = (Split-Path $MyInvocation.MyCommand.Path)
(Split-Path $MyInvocation.MyCommand.Path)
$Config = Get-Content "$(Split-Path $MyInvocation.MyCommand.Path)\Config.json" | ConvertFrom-Json
$Config