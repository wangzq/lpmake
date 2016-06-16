function New-Csproj
{
	<#
	.Synopsis
		New-Csproj
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)]
		[string] $Name,	

		[string] $Id,

		[string[]] $References,
		[string[]] $Sources,
		[string[]] $Contents,
		[switch] $Unsafe,
		[string] $OutputType = 'Library',

		# conditional compilations
		[string] $Conditions,

		[string] $FrameworkVersion = '4.5.2'
		)
	function GetList($name, $items) {
		foreach($item in $items) {
			"<$name Include=""$item"" />"
		}
	}
	
	if (!$Id) { $id = [guid]::NewGuid().ToString() }
	if ($Unsafe) {
		$unsafeCode = '<AllowUnsafeBlocks>true</AllowUnsafeBlocks>'
	} else {
		$unsafeCode = $null
	}
	[IO.File]::ReadAllText("$PsScriptRoot\csproj.template").Replace(
		'$guid$', $Id).Replace(
		'$name$', $Name).Replace(
		'$fxver$', $FrameworkVersion).Replace(
		'$references$', ((GetList 'Reference' $References) -join "`n")).Replace(
		'$compiles$', ((GetList 'Compile' $Sources) -join "`n")).Replace(
		'$contents$', ((GetList 'Content' $Contents) -join "`n")).Replace(
		'$conditions$', $Conditions).Replace(
		'$unsafe$', $unsafeCode).Replace(
		'$outputType$', $OutputType)
}
