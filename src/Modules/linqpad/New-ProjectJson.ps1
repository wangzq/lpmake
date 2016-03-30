function New-ProjectJson
{
    <#
    .Synopsis
        Creates a new project.json file from nuget packages used in a Linqpad query.
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias('Name')]
        [string] $Id,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string] $Version,
		
		[Parameter(ValueFromPipelineByPropertyName=$true)]
		[bool] $Prerelease,

        [string] $Framework='net45',
        [string] $Runtimes='win',

		[string[]] $NugetSources
        )
    begin {
        '{'
        '  "dependencies": {'
        $items = @()

		function Get-LatestPrereleaseVersion($id) {
			$nugetArgs = @('list', $id, '-pre')
			if ($NugetSources) {
				$NugetSources | % {
					$nugetArgs += ('-source', $_)
				}
			}
			$result = & nuget @nugetArgs
			if ($result -match 'No packages found') {
				throw "Unable to find nuget package '$id' -pre"
			}
			if ($result -match "^$([regex]::Escape($id)) (.*)$") {
				return $matches[1]
			}
			throw "Unexpected result when listing package '$id' -pre: $result"
		}
    }
    process {
        if (!$Version) { 
			if (!$Prerelease) {	
				$Version = '*' 
			} else {
				$Version = Get-LatestPrereleaseVersion $Id
			}
		}
        $items += "    ""$Id"": ""$Version"""
    }
    end {
        $items -join ",`n"
        '  },'
        '  "frameworks": { "net452": { } },'
        '  "runtimes": { "win": { } }'
        '}'
    }
}
