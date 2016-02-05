# Linqpad Make
Scripts written in PowerShell to generate a msbuild project file from a Linqpad
Query, then you can build with msbuild. Supports Nuget packages by creating
[project.json](http://docs.nuget.org/consume/ProjectJson-Intro), which you can
restore using [Nuget 3](http://dist.nuget.org/win-x86-commandline/latest/nuget.exe)
and build with [Build Tools
2015](https://www.microsoft.com/en-us/download/details.aspx?id=48159)(included
in Visual Studio 2015).

Currently only supports C# and F# program type queries, and only generates
Library or Exe type projects.

## Setup
 1. Ensure latest
    [nuget.exe](http://dist.nuget.org/win-x86-commandline/latest/nuget.exe) is
    in your PATH.
 1. Install [Build Tools
    2015](https://www.microsoft.com/en-us/download/details.aspx?id=48159) if
    you haven't installed Visual Studio 2015.
 1. Either copy the folders in `src\Modules` to your PowerShell Modules path or
	execute `src\Use-Lpmake.ps1` to load the modules for you.
 1. If you want to publish nuget packages using `lpmake -Publish` switch, then
    you need to define an environment variable named `mynuget` to point to a
    location when you want to publish the packages, such as `c:\nuget`. You
    need to ensure it is configured in nuget:

		nuget sources add -Name MyPackages -Source c:\nuget

 1. For LinqPad queries using `Dump` extension method, you will need to have a
	custom Nuget package named `ObjectDumperLib` which contains extension
	method `Dump` for any object. You can change this by `lpmake -ObjectDumper
	<nuget_package_name>`. I have included a LinqPad query
	`src\Extra\ObjectDumperLib.linq` which can be built with `lpmake` and
	publish as a Nuget package:

        lpmake .\src\Extra\ObjectDumperLib.linq -Publish

## Usage
 1. Ensure your Linqpad query has a special comment line that will be used by
	this script to differentiate between "program" code and "library" code: the
	`Main` method and any other methods not in a class are considered as
	"program" code and should occur before the special comment line. This
	script will use either the default comment line when you create a new C#
	Program type query: `// Define other methods and classes here`, or use
	`//////////` to separate the program and library code.
 1. Run `Import-Module linqpad` if you have added the modules in your
	PowerShell module paths, or run `src\Use-Lpmake.ps1`.
 1. Run `lpmake <full_path_to_your_linqpad_query_file>` to generate a msbuild
	project file in a temporary folder and build it by calling msbuild. By
	default it generates a Library type project, which means only code after
	the special comment line will be used; to generate an Exe type project (and
	include the "program" code before the special comment line), use
	`-OutputType Exe`.
 1. You can use `-Load` to immediately load the compiled assemby into PowerShell.
