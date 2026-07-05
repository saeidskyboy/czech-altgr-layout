# Windows 11 scripts

This folder contains the Windows 11 current-user installer.

## Important testing note

This Windows 11 script has **not** been end-to-end tested on Windows 11 from this development machine.

The only end-to-end tested installer/environment so far is:

```text
Ubuntu 22.04 / GNOME / X11 / IBus / XKB
```

The Windows implementation is provided as a best-effort script using AutoHotkey v2 because a native Windows keyboard layout normally requires MSKLC-generated DLLs and installer registration.

## Run

One-command clone and install from the private GitHub repo, run in PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command '$ErrorActionPreference="Stop"; $repo="saeidskyboy/czech-altgr-layout"; $dir=Join-Path $env:LOCALAPPDATA "czech-altgr-layout"; if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { winget install --id GitHub.cli --exact --source winget --accept-package-agreements --accept-source-agreements; $env:Path += ";" + (Join-Path $env:ProgramFiles "GitHub CLI") }; if (-not (Get-Command git -ErrorAction SilentlyContinue)) { winget install --id Git.Git --exact --source winget --accept-package-agreements --accept-source-agreements; $env:Path += ";" + (Join-Path $env:ProgramFiles "Git\cmd") }; gh auth status --hostname github.com *> $null; if ($LASTEXITCODE -ne 0) { throw "Run first: gh auth login --hostname github.com" }; Remove-Item -LiteralPath $dir -Recurse -Force -ErrorAction SilentlyContinue; gh repo clone $repo $dir; Set-Location $dir; .\install.ps1'
```

From PowerShell in the repository root:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
.\install.ps1
```

Or directly:

```powershell
.\scripts\windows11\install.ps1
```

## Uninstall

```powershell
.\scripts\windows11\uninstall.ps1
```

## What it touches

Current-user files only:

```text
%LOCALAPPDATA%\CzechAltGrLayout\CzechAltGr.ahk
%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Czech AltGr Layout.lnk
```

## Prerequisites

The bootstrap command installs `GitHub CLI` and `Git` with `winget` if they are
missing. The Windows installer itself installs or locates AutoHotkey v2 before
creating and running the current-user layout script.
