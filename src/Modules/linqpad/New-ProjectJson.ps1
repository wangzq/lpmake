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

        [string] $Framework='net45',
        [string] $Runtimes='win'
        )
    begin {
        '{'
        '  "dependencies": {'
        $items = @()
    }
    process {
        if (!$Version) { $Version = '*' }
        $items += "    ""$Id"": ""$Version"""
    }
    end {
        $items -join ",`n"
        '  },'
        '  "frameworks": { "net45": { } },'
        '  "runtimes": { "win": { } }'
        '}'
    }
}
