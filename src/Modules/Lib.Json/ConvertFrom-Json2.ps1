function ConvertFrom-Json2
{
	<#
	.Synopsis
		Enhanced version to ConvertFrom-Json that is able to handle large json text.
	.Example
		PS> [io.file]::ReadAllText('file.json') | ConvertFrom-Json2
	#>
	
	# http://connect.microsoft.com/PowerShell/feedback/details/801353/convertfrom-json-doesnt-allow-you-to-modify-the-maxjsonlength-value
	[CmdletBinding()]
	param (
		[parameter(ValueFromPipeline=$true)] 
		[string] $JsonText,
	
		[int] $MaxJsonLength = 20971520, # 2097152 is the default value which is 2MB, I am increasing it to 20MB as my default value
	
		# default is 100
		[int] $RecursionLimit
	)
	
	begin {
		Add-Type -AssemblyName System.Web.Extensions
		$jsser = New-Object system.web.script.serialization.javascriptserializer
		$jsser.MaxJsonLength = $MaxJsonLength
		if ($RecursionLimit) {
			$jsser.RecursionLimit = $RecursionLimit
		}
	}
	
	process {	
		$jsser.DeserializeObject($JsonText)
	}
}
