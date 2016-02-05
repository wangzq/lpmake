function ConvertFrom-JsonFile
{
    <#
    .Synopsis
        ConvertFrom-JsonFile
    .Example
        PS> ConvertFrom-JsonFile 
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [alias('FullName')]
        [string]$Path
        )

    process {
        Get-Content $Path -Raw | ConvertFrom-Json2
    }
}
