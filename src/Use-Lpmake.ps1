function Add-ModulePath([string[]] $path) {
	function strip($s) { if ($s.EndsWith('\')) { $s.Substring(0, $s.Length-1) } else { $s } }
	$current = $env:PsModulePath
	$pathlist = $current -split ';' | % { strip $_ }
	[array] $toadd = $path | ? { $p = strip $_; ($pathlist -notcontains $p) -AND [System.IO.Directory]::Exists($p) }
	if ($toadd) {
		$env:PsModulePath = ($toadd + $pathlist) -join ';'
	}
}

Add-ModulePath "$PsScriptRoot\Modules"
Import-Module linqpad
