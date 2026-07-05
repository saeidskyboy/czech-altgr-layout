#requires -Version 5.1
$ErrorActionPreference = 'Stop'
$InstallDir = Join-Path $env:LOCALAPPDATA 'CzechAltGrLayout'
$StartupDir = [Environment]::GetFolderPath('Startup')
$ShortcutPath = Join-Path $StartupDir 'Czech AltGr Layout.lnk'
if (Test-Path $ShortcutPath) { Remove-Item -LiteralPath $ShortcutPath -Force }
Get-Process -Name AutoHotkey64,AutoHotkey32,AutoHotkey -ErrorAction SilentlyContinue |
    Stop-Process -Force -ErrorAction SilentlyContinue
if (Test-Path $InstallDir) { Remove-Item -LiteralPath $InstallDir -Recurse -Force }
Write-Host 'Removed Czech AltGr current-user AutoHotkey layout.'
