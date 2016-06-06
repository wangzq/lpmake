function Publish-MyNugetPackage
{
	<#
	.Synopsis
		Publishes a nuget package from a source project file.
	.Example
		PS> Publish-MyNugetPackage 
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)]
		[string] $Name,

		[string] $Version,

		[switch] $Prerelease
		)
    $ErrorActionPreference = 'Stop'

    $targetDir = $env:mynuget
    if (!$targetDir) { throw "Please define an environment varialbe `mynuget` to point to your nuget package source such as c:\nuget" }
	
	# validate the version or generate a new version based on existing published versions
	$latestVersion = Get-MyNugetPackage | ? { $_.PackageId -eq $Name } | Sort Version | Select -Last 1 | Select -Exp Version
	if ($latestVersion -AND $Version -AND ($Version -le $latestVersion)) {
		Write-Warning "Publishing to an existing version, or an older version than latest: latest is $latestVersion, currently publishing $Version"
	}
	if ($latestVersion -AND !$Version) {
		$Version = New-Object System.Version($latestVersion.Major, $latestVersion.Minor, ($latestVersion.Build + 1))
		Write-Output "Found existing latest version $latestVersion, will publish as a new version $Version"
	}
	if (!$Version) { 
		$Version = '1.0.0' 
		Write-Output "No existing versions found, will publish as first version $Version"
	}

    $projectFile = dir "$Name.*proj" | Select -First 1 | Select -Exp Name
	if ($Prerelease) { $Version = $Version + '-preview' }
	nuget pack $projectFile -Version $Version -Symbols
	# it seems publishing the symbols version package will keep the name as if no symbols, so following command
	# is actually not necessary
	nuget push -source $targetDir "$Name.$Version.nupkg"
	nuget push -source $targetDir "$Name.$Version.symbols.nupkg"
    
    $cleanupScript = "$targetDir\_Cleanup.ps1"
    if (Test-Path $cleanupScript) {
        & $cleanupScript $Name
    }
}
