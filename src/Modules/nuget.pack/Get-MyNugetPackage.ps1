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
		if ($_.BaseName -match '^(.*?)\.(\d+\.\d+\.\d+)(-preview)?$') {
			$id = $matches[1]
			$version = $matches[2]
			if ($matches[3]) {
				$prerelease = $true
			} else { 
				$prerelease = $false
			}
			[PsCustomObject] @{
				PackageId = $id
				Version = New-Object System.Version($version)
				Prerelease = $prerelease
			}
		}
	}
}

