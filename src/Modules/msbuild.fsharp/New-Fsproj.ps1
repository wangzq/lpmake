function New-Fsproj
{
	<#
	.Synopsis
		New-Fsproj
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)]
		[string] $Name,	

		[string] $Id,

		[string[]] $References,
		[string[]] $Sources,
		[string[]] $Contents,
		[string] $OutputType = 'Library',

		# conditional compilations
		[string] $Conditions
		)
	function GetList($name, $items) {
		foreach($item in $items) {
			"<$name Include=""$item"" />"
		}
	}
	
	if (!$Id) { $id = [guid]::NewGuid().ToString() }
	[IO.File]::ReadAllText("$PsScriptRoot\fsproj.template").Replace(
		'$guid$', $Id).Replace(
		'$name$', $Name).Replace(
		'$references$', ((GetList 'Reference' $References) -join "`n")).Replace(
		'$compiles$', ((GetList 'Compile' $Sources) -join "`n")).Replace(
		'$conditions$', $Conditions).Replace(
		'$contents$', ((GetList 'Content' $Contents) -join "`n")).Replace(
		'$outputType$', $OutputType)
}
