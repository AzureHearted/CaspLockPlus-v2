#Requires AutoHotkey v2.0
#Include lib_functions.ahk
#Include lib_setting.ahk

; 全局锁
copyLineLock := false

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
    showToolTips('复制当前行到下一行')
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
    showToolTips('复制当前行到上一行')
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
    selText := getSelText()
    showToolTips("替换结果：" . char1 . selText . char2)
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
    resText := StrLower(getSelText())
    if (resText) {
        A_Clipboard := resText
        SendInput('^v')
    } else {
        showToolTips('没有选中文本')
    }
    Sleep(50)
    A_Clipboard := ClipboardOld
    return
}

; 选中文字切换为大写
funcLogic_switchSelUpperCase() {
    ClipboardOld := ClipboardAll()
    resText := StrUpper(getSelText())
    if (resText) {
        A_Clipboard := resText
        SendInput('^v')
    } else {
        showToolTips('没有选中文本')
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
        showToolTips('已置顶当前窗口🔝')
    } else {
        showToolTips('已解除当前窗口的置顶状态')
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
