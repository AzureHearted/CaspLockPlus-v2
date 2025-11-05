#Requires AutoHotkey v2.0
#SingleInstance Force
#ErrorStdOut

#Include <lib_initialize>
#Include <lib_functions>
; #Include <lib_keysFunLogic>
; #Include <lib_bindingWindow>
#Include <lib_keysMap>
#Include user_keysSet.ahk ;* 导入用户自定义按键设置(位置尽量靠前)

;todo 初始化
Init()

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
    ; Console.Debug(Console.MapToJson(keysMap))
    ; Console.Debug(keysMap)
    HotIf(CapsCondition)
    for key in allKeys {

        ;! CapsLock + Key ... 绑定
        Hotkey("$" key, callbackA)
        callbackA(HotkeyName) {
            try {
                RegExMatch(HotkeyName, '[^$]+?$', &theHotKey)
                fn := keysMap.Get(StrLower('caps_' theHotKey[]), Any)
                ; Console.Debug(Console.PadString(theHotKey[], 16, , 'left') Console.PadString(' :触发', 5, , 'right') fn.Name)
                fn()
            } catch as e {
                Console.Debug("[错误] File:" e.File " (" e.Line "行), Message:" e.Message)
                ShowToolTips(HotkeyName ':触发 执行错误！')
            }
        }

        ;! CapsLock + Alt + Key ... 绑定

        Hotkey('$!' key, callbackB)
        callbackB(HotkeyName) {
            try {
                RegExMatch(HotkeyName, '(?<=\!)[^!]+?$', &theHotKey)
                fn := keysMap.Get(StrLower('caps_alt_' theHotKey[]), Any)
                ; Console.Debug(Console.PadString(theHotKey[], 16, ' ', 'left') Console.PadString(' :触发(alt)', 5, , 'right') fn.Name)
                fn()
            } catch as e {
                Console.Debug("[错误] File:" e.File " (" e.Line "行), Message:" e.Message)
                ShowToolTips(HotkeyName ':触发(alt) 执行错误！')
            }
        }

        ;! CapsLock + Shift + Key ... 绑定
        Hotkey('$+' key, callbackC)
        callbackC(HotkeyName) {
            try {
                RegExMatch(HotkeyName, '(?<=\+)[^+]+?$', &theHotKey)
                fn := keysMap.Get(StrLower('caps_shift_' theHotKey[]), Any)
                ; Console.Debug(Console.PadString(theHotKey[], 16, ' ', 'left') Console.PadString(' :触发(shift)', 5, , 'right') fn.Name)
                fn()
            } catch as e {
                Console.Debug("[错误] File:" e.File " (" e.Line "行), Message:" e.Message)
                ShowToolTips(HotkeyName ':触发(shift) 执行错误！')
            }
        }

        ;! CapsLock + Win + Key ... 绑定
        Hotkey('$#' key, callbackD)
        callbackD(HotkeyName) {
            try {
                RegExMatch(HotkeyName, '(?<=\#)[^#]+?$', &theHotKey)
                fn := keysMap.Get(StrLower('caps_win_' theHotKey[]), Any)
                ; Console.Debug(Console.PadString(theHotKey[], 16, ' ', 'left') Console.PadString(' :触发(win)', 5, , 'right') fn.Name)
                fn()
            } catch as e {
                Console.Debug("[错误] File:" e.File " (" e.Line "行), Message:" e.Message)
                ShowToolTips(HotkeyName ':触发(win) 执行错误！')
            }
        }
    }
    HotIf()
}