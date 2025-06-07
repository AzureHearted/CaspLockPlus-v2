#Requires AutoHotkey v2.0

#Include <lib_keysFunction>


keysMap := Map()

{
    ; 定义需要的基本组合键前缀
    bootKey := 'caps'
    prefixes := ['', 'alt', 'shift']
    letters := 'abcdefghijklmnopqrstuvwxyz'
    nums := '0123456789'
    funcMap := (k, prefix) => 'keyFunc_' (prefix ? prefix "_" : "") k

    ; 字母
    for prefix in prefixes {
        for k in StrSplit(letters) {
            keyName := bootKey "_" (prefix ? prefix "_" : "") k
            keysMap[keyName] := %funcMap(k, prefix)%
        }
    }

    ; 数字(主键盘区域)
    for prefix in prefixes {
        for k in StrSplit(nums) {
            keyName := bootKey "_" (prefix ? prefix "_" : "") k
            keysMap[keyName] := %funcMap(k, prefix)%
        }
    }

    ; 功能键 F1 ~ F12
    for prefix in prefixes {
        loop 12 {
            k := "f" A_Index
            keyName := bootKey "_" (prefix ? prefix "_" : "") k
            keysMap[keyName] := %funcMap(k, prefix)%
        }
    }

    ; 特殊符号键（按原来的命名习惯手动枚举）
    symbolMap := Map(
        '``', 'backquote',
        '-', 'minus',
        '=', 'equal',
        '[', 'leftSquareBracket',
        ']', 'rightSquareBracket',
        '\', 'backslash',
        ';', 'semicolon',
        "'", 'quote',
        ',', 'comma',
        '.', 'dot',
        '/', 'slash',
        'backspace', 'backspace',
        'tab', 'tab',
        'enter', 'enter',
        'space', 'space'
    )

    for prefix in prefixes {
        prefix := prefix ? "_" prefix "_" : "_"
        for rawKey, alias in symbolMap {
            keyName := bootKey prefix rawKey
            ; Console.Debug(keyName)
            keysMap[keyName] := %"keyFunc" prefix alias%
        }
    }

    ; 小键盘区域
    numpadKeys := Map(
        'numlock', 'numlock',
        'numpad0', '0',
        'numpad1', '1',
        'numpad2', '2',
        'numpad3', '3',
        'numpad4', '4',
        'numpad5', '5',
        'numpad6', '6',
        'numpad7', '7',
        'numpad8', '8',
        'numpad9', '9',
        'numpadadd', 'equal',
        'numpadsub', 'minus',
        'numpadmult', 'mult',
        'numpaddiv', 'slash',
        'numpadenter', 'enter',
        'numpaddot', 'dot',
    )

    for prefix in prefixes {
        prefix := prefix ? "_" prefix "_" : "_"
        for rawKey, alias in numpadKeys {
            keyName := bootKey prefix rawKey
            ; Console.Debug(keyName)
            ; Console.Debug("keyFunc" prefix alias)
            keysMap[keyName] := %("keyFunc" prefix alias)%
        }
    }

    ; 鼠标操作
    mouseKeys := Map(
        'wheelup', 'wheelUp',
        'wheeldown', 'wheelDown',
        'mbutton', 'midButton',
        'lbutton', 'leftButton',
        'rbutton', 'rightButton'
    )

    for prefix in prefixes {
        prefix := prefix ? "_" prefix "_" : "_"
        for rawKey, alias in mouseKeys {
            keyName := bootKey prefix rawKey
            keysMap[keyName] := %"keyFunc" prefix alias%
        }
    }
}