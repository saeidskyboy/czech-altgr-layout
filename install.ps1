#requires -Version 5.1
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
& (Join-Path $Root 'scripts\windows\install.ps1') @args
