#Requires AutoHotkey v2.0

#Include <lib_initialize>
#Include <lib_functions>
; #Include <lib_keysFunLogic>
; #Include <lib_bindingWindow>
#Include <lib_keysMap>
#Include user_keysSet.ahk ;* 导入用户自定义按键设置(位置尽量靠前)

;todo 初始化
Init()

; 按下 CapsLock 后触发 CapsLock 按下事件
Hotkey('CapsLock', (*) => funcLogic_capsHold())

; 通过 Shift + CapsLock 触发切换CapsLock
Hotkey('+CapsLock', (*) => funcLogic_capsSwitch())

;* 按键列表
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


;* 进行热键绑定
BindingHotkey()

;! CapsLock 热键绑定
BindingHotkey() {
    global allKeys, keysMap
    HotIf((*) => GetKeyState('CapsLock', 'P'))
    for key in allKeys {
        ;! CapsLock + Key ... 绑定
        Hotkey("$" key, callbackA)
        callbackA(HotkeyName) {
            try {
                RegExMatch(HotkeyName, '[^$]+?$', &hotKey)
                fn := keysMap.Get(StrLower('caps_' hotKey[]), Any)
                OutputDebug(hotKey[] ':触发' fn.Name)
                fn()
            } catch as e {
                OutputDebug(e.Message)
                ShowToolTips(hotKey[] ':触发' fn.Name ' 执行错误！')
            }
        }

        ;! CapsLock + Alt + Key ... 绑定
        Hotkey('$!' key, callbackB)
        callbackB(HotkeyName) {
            try {
                RegExMatch(HotkeyName, '(?<=\!)[^!]+?$', &hotKey)
                fn := keysMap.Get(StrLower('caps_alt_' hotKey[]), Any)
                OutputDebug(hotKey[] ':触发(alt)' fn.Name)
                fn()
            } catch as e {
                OutputDebug(e.Message)
                ShowToolTips(hotKey[] ':触发(alt)' fn.Name ' 执行错误！')
            }
        }

        ;! CapsLock + Shift + Key ... 绑定
        Hotkey('$+' key, callbackC)
        callbackC(HotkeyName) {
            try {
                RegExMatch(HotkeyName, '(?<=\+)[^+]+?$', &hotKey)
                fn := keysMap.Get(StrLower('caps_shift_' hotKey[]), Any)
                OutputDebug(hotKey[] ':触发(shift)' fn.Name)
                fn()
            } catch as e {
                OutputDebug(e.Message)
                ShowToolTips(hotKey[] ':触发(shift)' fn.Name ' 执行错误！')
            }
        }

        ;! CapsLock + Win + Key ... 绑定
        Hotkey('$#' key, callbackD)
        callbackD(HotkeyName) {
            try {
                RegExMatch(HotkeyName, '(?<=\#)[^#]+?$', &hotKey)
                fn := keysMap.Get(StrLower('caps_win_' hotKey[]), Any)
                OutputDebug(hotKey[] ':触发(win)' fn.Name)
                fn()
            } catch as e {
                OutputDebug(e.Message)
                ShowToolTips(hotKey[] ':触发(win)' fn.Name ' 执行错误！')
            }
        }
    }
    HotIf()
}