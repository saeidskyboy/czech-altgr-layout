# Windows 11 installer
Run from PowerShell in the repository root:
```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
.\install.ps1
```
## Implementation
Windows native keyboard layouts normally require Microsoft Keyboard Layout
Creator/MSKLC output, compiled DLLs, and installer registration. That is not a
portable script-only approach.
This repository therefore uses AutoHotkey v2 for Windows 11:
- installs/locates AutoHotkey v2
- writes `%LOCALAPPDATA%\CzechAltGrLayout\CzechAltGr.ahk`
- creates a Startup shortcut for the current user
- starts the script immediately
## What it touches
Current-user files only:
```text
%LOCALAPPDATA%\CzechAltGrLayout\CzechAltGr.ahk
%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Czech AltGr Layout.lnk
```
If AutoHotkey is not installed, the script attempts:
```powershell
winget install --id AutoHotkey.AutoHotkey --exact --source winget --accept-package-agreements --accept-source-agreements
```
## Uninstall
```powershell
.\scripts\windows\uninstall.ps1
```
## Notes
AutoHotkey represents Windows AltGr as `<^>!`, which means Left Ctrl + Right Alt.
The hotkeys in the generated script use this AutoHotkey AltGr representation.
