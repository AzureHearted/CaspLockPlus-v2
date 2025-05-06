#Requires AutoHotkey v2.0

#Include <lib_initialize>
#Include <lib_functions>
#Include <lib_keysFunLogic>
#Include <lib_bindingWindow>
#Include <lib_keysMap>
#Include <lib_keysFunction>
#Include user_keysSet.ahk ;* 导入用户自定义按键设置(位置尽量靠前)

;todo 初始化
Init()

CapsLock:: {
    funcLogic_capsHold()
}

; 通过 Shift + CapsLock 触发切换CapsLock
+CapsLock:: {
    funcLogic_capsSwitch()
}

;* 所有热键
allKeys := [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
    "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12",
    "``", "-", "=", "[", "]", "\", ";", "'", "<", ">", ",", ".", "/",
    "Escape", "Tab", "Enter", "Space", "Backspace",
    "MButton", "LButton", "RButton", "WheelUp", "WheelDown",
    "NumLock", "Numpad0", "Numpad1", "Numpad2", "Numpad3", "Numpad4", "Numpad5", "Numpad6", "Numpad7", "Numpad8", "Numpad9",
    "NumpadAdd", "NumpadSub", "NumpadMult", "NumpadDiv", "NumpadEnter", "NumpadDot"
    ; "Home", "End", "PgUp", "PgDn", "Up", "Down", "Left", "Right", "Delete", "Insert", "PrintScreen", "ScrollLock", "Pause", "AppsKey",
    ; "LShift", "RShift", "LControl", "RControl", "LAlt", "RAlt",
]

;! CapsLock 热键绑定
HotIf((*) => GetKeyState('CapsLock', 'P'))
for key in allKeys {
    ; ; ================= CapsLock + Key ... 绑定 =================
    Hotkey("$" key, callbackA)
    callbackA(HotkeyName) {
        RegExMatch(HotkeyName, '[^$]+?$', &hotKey)
        funName := keysMap.Get(StrLower('caps_' hotKey[]), '')
        OutputDebug(hotKey[] ':触发' funName)
        try {
            %funName%()
        } catch as e {
            OutputDebug(e.Message)
        }
    }

    ; ================= CapsLock + Alt + Key ... 绑定 =================
    Hotkey('$!' key, callbackB)
    callbackB(HotkeyName) {
        RegExMatch(HotkeyName, '(?<=\!)[^!]+?$', &hotKey)
        funName := keysMap.Get(StrLower('caps_alt_' hotKey[]), '')
        OutputDebug(hotKey[] ':触发(alt)' funName)
        try {
            %funName%()
        } catch as e {
            OutputDebug(e.Message)
        }
    }

    ; ================= CapsLock + Shift + Key ... 绑定 =================
    Hotkey('$+' key, callbackC)
    callbackC(HotkeyName) {
        RegExMatch(HotkeyName, '(?<=\+)[^+]+?$', &hotKey)
        funName := keysMap.Get(StrLower('caps_shift_' hotKey[]), '')
        OutputDebug(hotKey[] ':触发(shift)' funName)
        try {
            %funName%()
        } catch as e {
            OutputDebug(e.Message)
        }
    }

    ; ================= CapsLock + Win + Key ... 绑定 =================
    Hotkey('$#' key, callbackD)
    callbackD(HotkeyName) {
        RegExMatch(HotkeyName, '(?<=\#)[^#]+?$', &hotKey)
        funName := keysMap.Get(StrLower('caps_win_' hotKey[]), '')
        OutputDebug(hotKey[] ':触发(win)' funName)
        try {
            %funName%()
        } catch as e {
            OutputDebug(e.Message)
        }
    }
}
HotIf()