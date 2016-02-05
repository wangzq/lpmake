function New-NugetSpec
{
    <#
    .Synopsis
        Creates a new nuget spec file for publishing the package.
    .Example
        PS> $dependencies | New-NugetSpec
        $dependencies is an array of custom object with properties 'Name' (or 'Id') and 'Version'.
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias('Name')]
        [string] $Id,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string] $Version
        )
    
    begin {
        @'
<?xml version="1.0"?>
<package >
  <metadata>
    <id>$Id$</id>
    <version>$version$</version>
    <title>$Id$</title>
    <authors>user</authors>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <description>$Id$</description>
    <dependencies>
'@
    }
    process {
        if ($Id) {
            "      <dependency id=""$Id"" version=""$Version"" />"
        }
    }
    end {
        @'
    </dependencies>
  </metadata>
</package>
'@
    }
}
