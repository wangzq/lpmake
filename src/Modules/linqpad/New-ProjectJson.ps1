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
        [string] $Runtimes='win'
        )
    begin {
        '{'
        '  "dependencies": {'
        $items = @()

		function Get-LatestPrereleaseVersion($id) {
			$result = & nuget list $id -pre
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
