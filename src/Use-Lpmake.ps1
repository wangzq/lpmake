function Add-ModulePath([string[]] $path) {
	function strip($s) { if ($s.EndsWith('\')) { $s.Substring(0, $s.Length-1) } else { $s } }
	$current = $env:PsModulePath
	$pathlist = $current -split ';' | % { strip $_ }
	$toadd = $path | ? { $p = strip $_; ($pathlist -notcontains $p) -AND [System.IO.Directory]::Exists($p) }
	if ($toadd) {
		$env:PsModulePath = ($toadd -join ';') + ';' + $current
	}
}

Add-ModulePath $PsScriptRoot
Import-Module linqpad
