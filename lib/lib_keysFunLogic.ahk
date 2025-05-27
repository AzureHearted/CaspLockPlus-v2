#Requires AutoHotkey v2.0
#Include <lib_functions>
#Include <lib_controlAlwaysOnTop>

;! CapsLock 开关逻辑
funcLogic_capsSwitch() {
    global CapsLockOpen
    CapsLockOpen := !CapsLockOpen
    SetCapsLockState(CapsLockOpen)
    ShowToolTips("CapsLock键(已" (CapsLockOpen ? '开启' : '关闭') ")")
    return
}

;! CapsLock 按住逻辑
funcLogic_capsHold() {
    global CapsLockHold, UserConfig, UISets

    if (CapsLockHold || UISets.hotTips.isShow) {
        return
    }

    CapsLockHold := true
    mouseButtons := ["MButton", "LButton", "RButton", "WheelUp", "WheelDown"]
    ; OutputDebug('-----开始计时-----' A_TickCount - timer)
    while (GetKeyState('CapsLock', 'P') && (A_ThisHotkey == "CapsLock" || StrIncludesAny(A_ThisHotkey, mouseButtons))) {
        if (UISets.hotTips.isShow) {
            Sleep(50)
            continue
        }

        ; OutputDebug('时间差：' A_TimeSinceThisHotkey '`tA_ThisHotkey:' A_ThisHotkey '`t' A_TimeSincePriorHotkey '`t' A_TimeSinceThisHotkey ' >=? ' UserConfig.HoldCapsLockShowTipsDelay)
        if (A_TimeSinceThisHotkey >= UserConfig.HoldCapsLockShowTipsDelay) {
            if (!UISets.hotTips.isShow) {
                ; OutputDebug('-----显示提示-----' A_TickCount - timer)
                ; 读取绑定的窗口信息
                bindingKeys := StrSplit(IniRead('winsInfosRecorder.ini', , , ''), '`n')
                ; OutputDebug(bindingKeys.Length)
                ; 清空原本展示的内容
                UISets.hotTips.ClearTips()
                tipsMsg := ''
                ; 添加新的内容
                for (key in bindingKeys) {
                    ahk_exe := IniRead('winsInfosRecorder.ini', key, 'ahk_exe', '未知程序名')
                    path := IniRead('winsInfosRecorder.ini', key, 'path', '')
                    tipsMsg .= key ":`t" ahk_exe "`n"
                    iconNumber := UISets.hotTips.LoadIcon(path)
                    UISets.hotTips.AddTipItem(iconNumber, ahk_exe, key)
                }
                OutputDebug(tipsMsg)
                UISets.hotTips.Show()
            }
            ; OutputDebug('-----显示提示-----')
        }
        Sleep(50)
    }

    UISets.hotTips.Hidden()
    KeyWait('CapsLock')
    OutputDebug('-----隐藏提示-----')
    ; 等到CapsLock被松开才切换CapsLock键的按下标识符
    CapsLockHold := false
}

; 删除当前行
funcLogic_deleteLine() {
    ClipboardOld := ClipboardAll()
    loop (3) {
        A_Clipboard := ""
        SendInput('^c')
        ClipWait(0.05)
        selText := A_Clipboard
        tmp := Ord(selText)
        ; tmp := selText
        if (selText && tmp != 13) {
            SendInput('{Backspace}')
        }
        SendInput('{End}+{Home}')
    }
    SendInput('{Backspace}')
    A_Clipboard := ClipboardOld
}

; 复制当前行到下一行
funcLogic_copyLineDown() {
    ShowToolTips('复制当前行到下一行')
    tmpClipboard := ClipboardAll()
    A_Clipboard := ""
    SendInput('{home}+{End}^c')
    ClipWait(0.05, 0)
    SendInput('{end}{enter}^v')
    Sleep(50)
    A_Clipboard := tmpClipboard
    return
}

; 复制当前行到上一行
funcLogic_CopyLineUp() {
    ShowToolTips('复制当前行到上一行')
    tmpClipboard := ClipboardAll()
    A_Clipboard := ""
    SendInput('{Home}+{End}^c')
    ClipWait(0.05, 0)
    SendInput('{up}{end}{enter}^v')
    Sleep(50)
    A_Clipboard := tmpClipboard
    return
}

; 选择的内容用括号括起来
funcLogic_doubleChar(char1, char2 := "") {
    if (char2 == "") {
        char2 := char1
    }
    charLen := StrLen(char2)
    selText := GetSelText()
    ShowToolTips("替换结果：" . char1 . selText . char2)
    ClipboardOld := ClipboardAll()
    if (selText) {
        A_Clipboard := char1 . selText . char2
        SendInput('^v')
    }
    else {
        A_Clipboard := char1 . char2
        Send('^v')
    }
    Sleep(50)
    A_Clipboard := ClipboardOld
    return
}

; 选中文字切换为小写
funcLogic_switchSelLowerCase() {
    ClipboardOld := ClipboardAll()
    resText := StrLower(GetSelText())
    if (resText) {
        A_Clipboard := resText
        SendInput('^v')
    } else {
        ShowToolTips('没有选中文本')
    }
    Sleep(50)
    A_Clipboard := ClipboardOld
    return
}

; 选中文字切换为大写
funcLogic_switchSelUpperCase() {
    ClipboardOld := ClipboardAll()
    resText := StrUpper(GetSelText())
    if (resText) {
        A_Clipboard := resText
        SendInput('^v')
    } else {
        ShowToolTips('没有选中文本')
    }
    Sleep(50)
    A_Clipboard := ClipboardOld
    return
}

; 置顶 / 解除置顶一个窗口
funcLogic_winPin() {
    hwnd := WinExist('A')                      ;获取当前窗口的HWND
    WinSetAlwaysOnTop(-1, 'ahk_id' hwnd)

    OpenExperimentalFunction := IniRead(SettingIniPath, 'General', 'OpenExperimentalFunction', false)
    if (IsAlwaysOnTop(hwnd)) {
        if (OpenExperimentalFunction) {
            AlwaysOnTopControl(hwnd)
        } else {
            ShowToolTips('已置顶当前窗口🔝')
        }
    } else {
        if (!OpenExperimentalFunction) {
            ShowToolTips('已解除当前窗口的置顶状态')
        }
    }
    return
}

; 系统音量增加
funcLogic_volumeUp() {
    SendInput('{Volume_Up}')
    return
}

; 系统音量减少
funcLogic_volumeDown() {
    SendInput('{Volume_Down}')
    return
}