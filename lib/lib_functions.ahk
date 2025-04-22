#Requires AutoHotkey v2.0

#Include <lib_setting>

/**
 * 显示ToolTips消息
 * @param msg 消息内容
 * @param duration 持续时间
 */
showToolTips(msg, duration := 1000) {
    ToolTip(msg)
    SetTimer(() => ToolTip(), duration)
}

;获取选中的文本(无污染剪贴板)
getSelText() {
    ClipboardOld := ClipboardAll()
    A_Clipboard := ""
    SendInput('^{c}')
    if (ClipWait(0.05, 0)) {
        selText := A_Clipboard
        ; 还原剪贴板📋
        A_Clipboard := ClipboardOld
        lastChar := SubStr(selText, StrLen(selText), 1)
        if (Ord(lastChar) != 10) ;如果最后一个字符是换行符，就认为是在IDE那复制了整行，不要这个结果
        {
            OutputDebug('获取文本成功:' . selText . '`n')
            return selText
        } else {
            OutputDebug('未选中文本:' . '`n')
            return
        }
        ; return selText
    } else {
        OutputDebug("剪贴板等待超时")
        A_Clipboard := ClipboardOld
        return ""
    }
    A_Clipboard := ClipboardOld
    return
}
