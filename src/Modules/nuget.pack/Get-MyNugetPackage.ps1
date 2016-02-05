function Get-MyNugetPackage
{
	<#
	.Synopsis
		Get-MyNugetPackage
	.Example
		PS> Get-MyNugetPackage 
	#>
	[CmdletBinding()]
	param ( )
    $ErrorActionPreference = 'Stop'

    $targetDir = $env:mynuget
    if (!$targetDir) { throw "Please define an environment varialbe `mynuget` to point to your nuget package source such as c:\nuget" }

	dir $targetDir -File | % {
		if ($_.BaseName -match '^(.*?)\.(\d+\.\d+\.\d+)$') {
			$id = $matches[1]
			$version = $matches[2]
			[PsCustomObject] @{
				PackageId = $id
				Version = New-Object System.Version($version)
			}
		}
	}
}

