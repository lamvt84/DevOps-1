Param(   
    [string] $Type
)
$Type
$set = "F,D,L"
$possibleValues = $set
$set | ForEach-Object { $_.Contains($Type) }