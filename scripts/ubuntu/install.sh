#!/usr/bin/env bash
set -euo pipefail
LAYOUT_ID="xr_us_cz_altgr"
LAYOUT_NAME="Czech"
IBUS_ENGINE="xkb:${LAYOUT_ID}::ces"
SYMBOLS_FILE="/usr/share/X11/xkb/symbols/${LAYOUT_ID}"
RULE_FILES=("/usr/share/X11/xkb/rules/evdev.xml" "/usr/share/X11/xkb/rules/base.xml")
IBUS_SIMPLE_XML="/usr/share/ibus/component/simple.xml"
BACKUP_SUFFIX="$(date +%Y%m%d-%H%M%S)"
SET_GSETTINGS=1
RESTART_IBUS=1
usage() {
  cat <<USAGE
Usage: $0 [--no-gsettings] [--no-ibus-restart] [--verify-only]
Installs an English-US-based Czech AltGr keyboard layout for Ubuntu/GNOME.
Options:
  --no-gsettings      Do not change GNOME input-source settings.
  --no-ibus-restart   Do not restart IBus after registration.
  --verify-only       Only verify current installation state.
USAGE
}
VERIFY_ONLY=0
while [ $# -gt 0 ]; do
  case "$1" in
    --no-gsettings) SET_GSETTINGS=0 ;;
    --no-ibus-restart) RESTART_IBUS=0 ;;
    --verify-only) VERIFY_ONLY=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done
require_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "Missing required command: $1" >&2; exit 1; }
}
verify() {
  echo "== Verifying ${LAYOUT_NAME} AltGr layout =="
  test -f "$SYMBOLS_FILE" && echo "symbols: OK ($SYMBOLS_FILE)" || echo "symbols: MISSING ($SYMBOLS_FILE)"
  grep -q "<name>${LAYOUT_ID}</name>" /usr/share/X11/xkb/rules/evdev.xml && echo "evdev.xml: OK" || echo "evdev.xml: MISSING"
  grep -q "<name>${LAYOUT_ID}</name>" /usr/share/X11/xkb/rules/base.xml && echo "base.xml: OK" || echo "base.xml: MISSING"
  grep -q "<name>${IBUS_ENGINE}</name>" "$IBUS_SIMPLE_XML" && echo "IBus engine: OK" || echo "IBus engine: MISSING"
  setxkbmap -layout "$LAYOUT_ID" -print | xkbcomp -w 10 - /tmp/${LAYOUT_ID}.xkb >/dev/null
  rm -f /tmp/${LAYOUT_ID}.xkb
  echo "XKB compile: OK"
  gsettings get org.gnome.desktop.input-sources sources 2>/dev/null || true
  ibus list-engine 2>/dev/null | grep -E "xkb:us::eng|${IBUS_ENGINE}" || true
}
require_cmd sudo
require_cmd python3
require_cmd grep
require_cmd setxkbmap
require_cmd xkbcomp
if [ "$VERIFY_ONLY" -eq 1 ]; then
  verify
  exit 0
fi
if ! command -v gsettings >/dev/null 2>&1; then
  echo "Warning: gsettings not found; GNOME source configuration will be skipped." >&2
  SET_GSETTINGS=0
fi
if ! command -v ibus >/dev/null 2>&1; then
  echo "Warning: ibus not found; IBus registration restart/check will be skipped." >&2
  RESTART_IBUS=0
fi
echo "== Installing ${LAYOUT_NAME} AltGr layout on Ubuntu/GNOME =="
for file in "$SYMBOLS_FILE" "${RULE_FILES[@]}" "$IBUS_SIMPLE_XML"; do
  if [ -e "$file" ]; then
    sudo cp -a "$file" "${file}.bak.${BACKUP_SUFFIX}"
  fi
done
echo "Writing XKB symbols: $SYMBOLS_FILE"
sudo tee "$SYMBOLS_FILE" >/dev/null <<'XKBEOF'
// Custom English-US-based Czech AltGr layout.
// Normal keys stay English (US). Right Alt adds Czech letters.
default partial alphanumeric_keys
xkb_symbols "basic" {
    include "us(basic)"
    include "level3(ralt_switch)"
    name[Group1] = "Czech";
    key <AD03> { [ e, E, ecaron, Ecaron ] };
    key <AC02> { [ s, S, scaron, Scaron ] };
    key <AB03> { [ c, C, ccaron, Ccaron ] };
    key <AD04> { [ r, R, rcaron, Rcaron ] };
    key <AD05> { [ t, T, tcaron, Tcaron ] };
    key <AC03> { [ d, D, dcaron, Dcaron ] };
    key <AB06> { [ n, N, ncaron, Ncaron ] };
    key <AD09> { [ o, O, oacute, Oacute ] };
    key <AB01> { [ z, Z, zcaron, Zcaron ] };
    key <AD06> { [ y, Y, yacute, Yacute ] };
    key <AC01> { [ a, A, aacute, Aacute ] };
    key <AD08> { [ i, I, iacute, Iacute ] };
    key <AD07> { [ u, U, uacute, Uacute ] };
    key <AC07> { [ j, J, uring, Uring ] };
    // Apostrophe key keeps ' and ", adds e-acute on the Right Alt layer.
    key <AC11> { [ apostrophe, quotedbl, eacute, Eacute ] };
};
XKBEOF
layout_block='''
    <layout>
      <configItem>
        <name>xr_us_cz_altgr</name>
        <shortDescription>cz</shortDescription>
        <description>Czech</description>
        <languageList>
          <iso639Id>ces</iso639Id>
          <iso639Id>cze</iso639Id>
          <iso639Id>eng</iso639Id>
        </languageList>
      </configItem>
      <variantList/>
    </layout>'''
for file in "${RULE_FILES[@]}"; do
  echo "Ensuring XKB rules registration: $file"
  sudo python3 - "$file" <<'PY'
from pathlib import Path
import sys
path = Path(sys.argv[1])
text = path.read_text(encoding='utf-8')
name = '<name>xr_us_cz_altgr</name>'
block = '''    <layout>
      <configItem>
        <name>xr_us_cz_altgr</name>
        <shortDescription>cz</shortDescription>
        <description>Czech</description>
        <languageList>
          <iso639Id>ces</iso639Id>
          <iso639Id>cze</iso639Id>
          <iso639Id>eng</iso639Id>
        </languageList>
      </configItem>
      <variantList/>
    </layout>
'''
if name in text:
    print('Already registered')
    raise SystemExit(0)
marker = '</layoutList>'
if marker not in text:
    raise SystemExit(f'{path}: cannot find {marker}')
path.write_text(text.replace(marker, block + marker, 1), encoding='utf-8')
print('Registered')
PY
done
echo "Ensuring IBus engine registration: $IBUS_SIMPLE_XML"
sudo python3 - "$IBUS_SIMPLE_XML" <<'PY'
from pathlib import Path
import sys
path = Path(sys.argv[1])
text = path.read_text(encoding='utf-8')
engine_name = '<name>xkb:xr_us_cz_altgr::ces</name>'
block = '''    <engine>
        <name>xkb:xr_us_cz_altgr::ces</name>
        <language>cs</language>
        <license>GPL</license>
        <author>xr195</author>
        <layout>xr_us_cz_altgr</layout>
        <longname>Czech</longname>
        <description>Czech</description>
        <icon>ibus-keyboard</icon>
        <rank>60</rank>
    </engine>
'''
if engine_name in text:
    print('Already registered')
    raise SystemExit(0)
marker = '</engines>'
if marker not in text:
    raise SystemExit(f'{path}: cannot find {marker}')
path.write_text(text.replace(marker, block + marker, 1), encoding='utf-8')
print('Registered')
PY
setxkbmap -layout "$LAYOUT_ID" -print | xkbcomp -w 10 - /tmp/${LAYOUT_ID}.xkb >/dev/null
rm -f /tmp/${LAYOUT_ID}.xkb
echo "XKB compile check passed."
if [ "$RESTART_IBUS" -eq 1 ]; then
  echo "Restarting IBus."
  ibus restart || true
  sleep 2
  ibus-daemon -drx || true
  sleep 1
fi
if [ "$SET_GSETTINGS" -eq 1 ]; then
  echo "Configuring GNOME input sources as xkb sources."
  gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', '${LAYOUT_ID}')]"
  gsettings set org.gnome.desktop.input-sources mru-sources "[('xkb', 'us'), ('xkb', '${LAYOUT_ID}')]"
  gsettings set org.gnome.desktop.input-sources current 0
  gsettings set org.gnome.desktop.input-sources show-all-sources true
  gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Super>space', 'XF86Keyboard']"
  gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Shift><Super>space', '<Shift>XF86Keyboard']"
fi
if command -v ibus >/dev/null 2>&1; then
  ibus engine xkb:us::eng || true
fi
verify
cat <<DONE
Installed.
If the top-bar/input menu does not refresh immediately, switch sources with
Super+Space. If it is still stale, log out and log back in once.
DONE
