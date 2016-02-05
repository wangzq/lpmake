Set-StrictMode -Version 1

Get-ChildItem (Join-Path $PSScriptRoot "*-*.ps1") | where { $_.FullName -notmatch '\.tests\.ps1$' } | foreach {. $_.FullName}
Export-ModuleMember -Alias * -Function '*-*'
