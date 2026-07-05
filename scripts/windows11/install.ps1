#requires -Version 5.1
$ErrorActionPreference = 'Stop'
function Find-AutoHotkey {
    $cmd = Get-Command AutoHotkey.exe -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $candidates = @(
        "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey64.exe",
        "$env:ProgramFiles\AutoHotkey\AutoHotkey64.exe",
        "${env:ProgramFiles(x86)}\AutoHotkey\v2\AutoHotkey64.exe",
        "${env:ProgramFiles(x86)}\AutoHotkey\AutoHotkey64.exe",
        "$env:LOCALAPPDATA\Programs\AutoHotkey\v2\AutoHotkey64.exe"
    ) | Where-Object { $_ -and (Test-Path $_) }
    if ($candidates.Count -gt 0) { return $candidates[0] }
    return $null
}
function Install-AutoHotkeyWithWinget {
    $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
    if (-not $winget) {
        throw 'AutoHotkey v2 was not found and winget is not available. Install AutoHotkey v2 from https://www.autohotkey.com/ and rerun this script.'
    }
    Write-Host 'AutoHotkey was not found. Installing AutoHotkey via winget...'
    & winget install --id AutoHotkey.AutoHotkey --exact --source winget --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        throw "winget failed to install AutoHotkey. Exit code: $LASTEXITCODE"
    }
}
if (-not $IsWindows -and $PSVersionTable.PSEdition -eq 'Core') {
    throw 'This installer must be run on Windows.'
}
$InstallDir = Join-Path $env:LOCALAPPDATA 'CzechAltGrLayout'
$AhkScript = Join-Path $InstallDir 'CzechAltGr.ahk'
$StartupDir = [Environment]::GetFolderPath('Startup')
$ShortcutPath = Join-Path $StartupDir 'Czech AltGr Layout.lnk'
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
$AhkExe = Find-AutoHotkey
if (-not $AhkExe) {
    Install-AutoHotkeyWithWinget
    $AhkExe = Find-AutoHotkey
}
if (-not $AhkExe) {
    throw 'AutoHotkey v2 installation could not be located after install.'
}
$ScriptContent = @'
#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"
; Czech AltGr layer for an English-US keyboard.
; AutoHotkey represents Windows AltGr as <^>! (Left Ctrl + Right Alt).
<^>!e::SendText "ě"
<^>!+e::SendText "Ě"
<^>!s::SendText "š"
<^>!+s::SendText "Š"
<^>!c::SendText "č"
<^>!+c::SendText "Č"
<^>!r::SendText "ř"
<^>!+r::SendText "Ř"
<^>!t::SendText "ť"
<^>!+t::SendText "Ť"
<^>!d::SendText "ď"
<^>!+d::SendText "Ď"
<^>!n::SendText "ň"
<^>!+n::SendText "Ň"
<^>!o::SendText "ó"
<^>!+o::SendText "Ó"
<^>!z::SendText "ž"
<^>!+z::SendText "Ž"
<^>!y::SendText "ý"
<^>!+y::SendText "Ý"
<^>!a::SendText "á"
<^>!+a::SendText "Á"
<^>!i::SendText "í"
<^>!+i::SendText "Í"
<^>!u::SendText "ú"
<^>!+u::SendText "Ú"
<^>!j::SendText "ů"
<^>!+j::SendText "Ů"
<^>!SC028::SendText "é"     ; apostrophe key on US keyboards
<^>!+SC028::SendText "É"
'@
Set-Content -LiteralPath $AhkScript -Value $ScriptContent -Encoding UTF8
$Shell = New-Object -ComObject WScript.Shell
$Shortcut = $Shell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = $AhkExe
$Shortcut.Arguments = '"' + $AhkScript + '"'
$Shortcut.WorkingDirectory = $InstallDir
$Shortcut.Description = 'Czech AltGr layout for English-US keyboard'
$Shortcut.Save()
Get-Process -Name AutoHotkey64,AutoHotkey32,AutoHotkey -ErrorAction SilentlyContinue |
    Where-Object { $_.Path -eq $AhkExe } |
    Stop-Process -Force -ErrorAction SilentlyContinue
Start-Process -FilePath $AhkExe -ArgumentList ('"' + $AhkScript + '"')
Write-Host 'Installed Czech AltGr AutoHotkey layout.'
Write-Host "Script: $AhkScript"
Write-Host "Startup shortcut: $ShortcutPath"
Write-Host 'Test: AltGr+E -> ě, Shift+AltGr+E -> Ě, AltGr+D -> ď.'
