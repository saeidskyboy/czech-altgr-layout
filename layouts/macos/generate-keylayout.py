#!/usr/bin/env python3
from __future__ import annotations
from pathlib import Path
OUT = Path(__file__).with_name('Czech AltGr.keylayout')
NORMAL = {
    0: 'a', 1: 's', 2: 'd', 3: 'f', 4: 'h', 5: 'g', 6: 'z', 7: 'x', 8: 'c', 9: 'v',
    10: '', 11: 'b', 12: 'q', 13: 'w', 14: 'e', 15: 'r', 16: 'y', 17: 't',
    18: '1', 19: '2', 20: '3', 21: '4', 22: '6', 23: '5', 24: '=', 25: '9',
    26: '7', 27: '-', 28: '8', 29: '0', 30: ']', 31: 'o', 32: 'u', 33: '[',
    34: 'i', 35: 'p', 36: '\r', 37: 'l', 38: 'j', 39: "'", 40: 'k', 41: ';',
    42: '\\', 43: ',', 44: '/', 45: 'n', 46: 'm', 47: '.', 48: '\t', 49: ' ',
    50: '`', 51: '',
}
SHIFT = {
    0: 'A', 1: 'S', 2: 'D', 3: 'F', 4: 'H', 5: 'G', 6: 'Z', 7: 'X', 8: 'C', 9: 'V',
    10: '', 11: 'B', 12: 'Q', 13: 'W', 14: 'E', 15: 'R', 16: 'Y', 17: 'T',
    18: '!', 19: '@', 20: '#', 21: '$', 22: '^', 23: '%', 24: '+', 25: '(',
    26: '&', 27: '_', 28: '*', 29: ')', 30: '}', 31: 'O', 32: 'U', 33: '{',
    34: 'I', 35: 'P', 36: '\r', 37: 'L', 38: 'J', 39: '"', 40: 'K', 41: ':',
    42: '|', 43: '<', 44: '?', 45: 'N', 46: 'M', 47: '>', 48: '\t', 49: ' ',
    50: '~', 51: '',
}
LOWER_CZECH = {
    14: 'ě', 1: 'š', 8: 'č', 15: 'ř', 17: 'ť', 2: 'ď', 45: 'ň', 31: 'ó',
    6: 'ž', 16: 'ý', 0: 'á', 34: 'í', 32: 'ú', 38: 'ů', 39: 'é',
}
UPPER_CZECH = {
    14: 'Ě', 1: 'Š', 8: 'Č', 15: 'Ř', 17: 'Ť', 2: 'Ď', 45: 'Ň', 31: 'Ó',
    6: 'Ž', 16: 'Ý', 0: 'Á', 34: 'Í', 32: 'Ú', 38: 'Ů', 39: 'É',
}
def xml_attr(value: str) -> str:
    parts: list[str] = []
    for ch in value:
        if ch == '\r':
            parts.append('&#x000D;')
        elif ch == '\t':
            parts.append('&#x0009;')
        elif ch == '&':
            parts.append('&amp;')
        elif ch == '<':
            parts.append('&lt;')
        elif ch == '>':
            parts.append('&gt;')
        elif ch == '"':
            parts.append('&quot;')
        else:
            parts.append(ch)
    return ''.join(parts)
def keymap(index: int, mapping: dict[int, str]) -> str:
    lines = [f'    <keyMap index="{index}">']
    for code in range(0, 52):
        output = mapping.get(code, '')
        if output == '':
            lines.append(f'      <key code="{code}" output=""/>')
        else:
            lines.append(f'      <key code="{code}" output="{xml_attr(output)}"/>')
    lines.append('    </keyMap>')
    return '\n'.join(lines)
def main() -> None:
    option = dict(NORMAL)
    option.update(LOWER_CZECH)
    option_shift = dict(SHIFT)
    option_shift.update(UPPER_CZECH)
    content = f'''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE keyboard SYSTEM "file://localhost/System/Library/DTDs/KeyboardLayout.dtd">
<keyboard group="0" id="19501" name="Czech AltGr" maxout="1">
  <layouts>
    <layout first="0" last="0" mapSet="ANSI" modifiers="Modifiers"/>
  </layouts>
  <modifierMap id="Modifiers" defaultIndex="0">
    <keyMapSelect mapIndex="0">
      <modifier keys=""/>
    </keyMapSelect>
    <keyMapSelect mapIndex="1">
      <modifier keys="shift"/>
    </keyMapSelect>
    <keyMapSelect mapIndex="2">
      <modifier keys="anyOption"/>
    </keyMapSelect>
    <keyMapSelect mapIndex="3">
      <modifier keys="shift anyOption"/>
    </keyMapSelect>
  </modifierMap>
  <keyMapSet id="ANSI">
{keymap(0, NORMAL)}
{keymap(1, SHIFT)}
{keymap(2, option)}
{keymap(3, option_shift)}
  </keyMapSet>
</keyboard>
'''
    OUT.write_text(content, encoding='utf-8')
    print(OUT)
if __name__ == '__main__':
    main()
