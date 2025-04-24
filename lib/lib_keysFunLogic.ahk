#Requires AutoHotkey v2.0
#Include <lib_functions>

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
    static timer := A_TickCount

    if (CapsLockHold) {
        ; 如果按住了就退出
        return
    }
    else {
        ; 如果是首次按住则重置时间戳
        timer := A_TickCount
    }
    CapsLockHold := true
    ; OutputDebug('-----开始计时-----' A_TickCount - timer)
    SetTimer(handle, 10)
    handle(*) {
        ; OutputDebug('CapsLock的按下状态：' GetKeyState('CapsLock', 'P') '`nA_ThisHotkey：' A_ThisHotkey '`nA_PriorHotkey：' A_PriorHotkey)
        if (GetKeyState('CapsLock', 'P') && A_ThisHotkey == "CapsLock") {
            ; OutputDebug('时间差：' A_TickCount - timer)
            if (A_TickCount - timer >= UserConfig.HoldCapsLockShowTipsDelay) {
                if (!UISets.hotTips.open) {
                    ; OutputDebug('-----显示提示-----' A_TickCount - timer)
                    ; 展示前现先读取绑定的窗口信息
                    bindingKeys := StrSplit(IniRead('winsInfosRecorder.ini'), '`n')
                    UISets.hotTips.ClearTips()
                    for (key in bindingKeys) {
                        ahk_exe := IniRead('winsInfosRecorder.ini', key, 'ahk_exe', '未知程序名')
                        tipsMsg .= key ":`t" ahk_exe "`n"
                        UISets.hotTips.AddTipItem(key, ahk_exe)
                    }
                    OutputDebug(tipsMsg)
                    UISets.hotTips.ChangeContent(tipsMsg)
                }
                UISets.hotTips.Show()
            }
        } else {
            SetTimer(handle, 0)
            ; OutputDebug('计时器已经移除')
            CapsLockHold := false
            UISets.hotTips.Close()
            ; OutputDebug('-----隐藏提示-----')
            timer := A_TickCount
        }

    }
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
    _id := WinExist('A')                      ;获取当前窗口的ID
    ; _id := WinGetID("A")                      ;获取当前窗口的句柄(ID)
    WinSetAlwaysOnTop(-1)
    exStyle := WinGetExStyle('A')   ;获取扩展样式
    ; showMsg((exStyle & 0x8 ? '已置顶' : '已解除置顶') . '当前窗口：' . _id)
    if (exStyle & 0x8) {
        ShowToolTips('已置顶当前窗口🔝')
    } else {
        ShowToolTips('已解除当前窗口的置顶状态')
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