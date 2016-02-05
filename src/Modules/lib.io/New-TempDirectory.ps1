function New-TempDirectory
{
	<#
	.Synopsis
		Creates a new temp directory.
	.Example
		PS> New-TempDirectory 
	#>
	[CmdletBinding()]
	param ( )
	$p = [IO.Path]::GetTempFileName()
	[IO.File]::Delete($p)
	[IO.Directory]::CreateDirectory($p) | Out-Null
	$p
}
