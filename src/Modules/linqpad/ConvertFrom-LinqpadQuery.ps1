function ConvertFrom-LinqpadQuery
{
	<#
	.Synopsis
		Parses a linqpad query file.
	.Example
		PS> ConvertFrom-LinqpadQuery 
	#>
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
		[alias('FullName')]
		[string] $Path	
		)
	begin{
		function ParseNugetReferences($elements) {
			foreach($element in $elements) {
				if ($element.Version -OR $element.Prerelease) {
					$name = $element.'#text'
				} else {
					$name = $element
				}
				if ($element.Prerelease -eq 'true') {
					$prerelease = $true
				} else {
					$prerelease = $false
				}
				[PsCustomObject] @{
					Name = $name
					Version = $element.Version
					Prerelease = $prerelease
				}
			}
		}
		function ParseReferences($basedir, $elements) {
			foreach($element in $elements) {
				if ($element.Relative) {
					[IO.Path]::Combine($basedir, ($element.Relative))
				} else {
					$element.Replace('<RuntimeDirectory>', [System.Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()).Replace('<ProgramFilesX86>', [Environment]::GetFolderPath('ProgramFilesX86'))
				}
			}
		}
		function ParseGacReferences($elements) {
			foreach($element in $elements) {
				New-Object System.Reflection.AssemblyName($element)
			}
			@(
				'System.Drawing'
				'System.Windows.Forms'
			) | % { New-Object System.Reflection.AssemblyName($_) }
		}

        [Environment]::CurrentDirectory = (Get-Location -PSProvider FileSystem).ProviderPath
	}
	process {
		$Path = [IO.Path]::GetFullPath($Path)
		$xmlLines = @()
		$codeLines = @()
		$xmlEndingFound = $false
		Get-Content $Path | % {
			if ($_.Trim().StartsWith('<')) {
				if ($xmlEndingFound) {
					$codeLines += $_
				} else {
					$xmlLines += $_
				}
			} else {
				$codeLines += $_
			}
		}

		[xml] $doc = $xmlLines -join "`n"
		$basedir = [IO.Path]::GetDirectoryName($Path)

		[PsCustomObject] @{
			Kind = $doc.Query.Kind
			References = [array] (ParseReferences $basedir $doc.Query.Reference)
			GacReferences = [array] (ParseGacReferences $doc.Query.GacReference)
			NugetReferences = [array] (ParseNugetReferences $doc.Query.NugetReference)
			Namespaces = [array] ($doc.Query.Namespace)
			Code = [array] ($codeLines)
		}
	}
}
