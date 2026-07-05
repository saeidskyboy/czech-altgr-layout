#requires -Version 5.1
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
& (Join-Path $Root 'scripts\windows11\install.ps1') @args
