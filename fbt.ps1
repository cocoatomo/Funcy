<#
.SYNOPSIS
fbt - Funcy Build Tool

.DESCRIPTION
Make your build tasks for Funcy easy.

.PARAMETER NoUpdate
Do not run paket.bootstrapper.exe so as not to update paket.exe if set, otherwise do.

.PARAMETER Build
Build Funcy.sln if set, otherwise not.

.PARAMETER Test
Test Funcy.Test.dll with Persimmon.Console if set, otherwise not.
#>
Param(
    [switch]$NoUpdate,
    [switch]$Build,
    [switch]$Test
)

begin
{
    function Check-Parameter
    {
        return (-not $NoUpdate) -or $Build -or $Test
    }

    function Write-Usage
    {
        Write-Output "  Usage
      fbt.ps1 [-NoUpdate] [-Build] [-Test]
"
    }

    if (-not (Check-Parameter))
    {
        Write-Usage
        exit 0
    }
}
process
{
    if(-not $NoUpdate)
    {
        .paket/paket.bootstrapper.exe
        if (-not $?)
        {
            exit $LASTEXITCODE
        }
    }

    if ($Build)
    {
        # It may be necessary for you to add a path to MSBuild to $env:PATH.
        MSBuild.exe .\Funcy.sln /p:Configuration=Debug /p:Platform="Any CPU" /v:minimal
        if (-not $?)
        {
            exit $LASTEXITCODE
        }
    }

    if ($Test)
    {
		#TODO: Improve this...
		if (Test-Path .\packages\Persimmon.Console.1.0.0\tools\Persimmon.Console.exe)
		{
			Start-Process .\packages\Persimmon.Console.1.0.0\tools\Persimmon.Console.exe .\Funcy.Test\bin\Debug\Funcy.Test.dll -NoNewWindow -Wait
		}
		else
		{
			Start-Process .\packages\Persimmon.Console\tools\Persimmon.Console.exe .\Funcy.Test\bin\Debug\Funcy.Test.dll -NoNewWindow -Wait
		}
		if (-not $?)
        {
            exit $LASTEXITCODE
        }
    }
}
