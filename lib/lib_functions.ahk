#Requires AutoHotkey v2.0

/**
 * 显示ToolTips消息
 * @param msg 消息内容
 * @param duration 持续时间
 */
ShowToolTips(msg, duration := 1000) {
    ToolTip(msg)
    SetTimer(() => ToolTip(), duration)
}

/**
 * 获取选中的文本(支持无污染剪贴板)
 * @param {Integer} endDelay 获取完成后延时多少ms再返回结果
 * @returns {String} 获取到的文本内容
 */
GetSelText(endDelay := 0) {
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
            Console.Debug('获取文本成功:' . selText . '`n')
            Sleep(endDelay)
            return selText
        } else {
            Console.Debug('未选中文本:' . '`n')
            Sleep(endDelay)
            return
        }
    } else {
        Console.Debug("剪贴板等待超时")
        ; 还原剪贴板📋
        A_Clipboard := ClipboardOld
        Sleep(endDelay)
        return ""
    }
}


;! 获取活动的资源管理器路径
GetActiveExplorerPath() {
    hwndActive := WinActive("A")
    shellApp := ComObject("Shell.Application")
    for (window in shellApp.Windows) {
        try {
            if InStr(window.FullName, "explorer.exe") && window.HWND = hwndActive {
                return window.Document.Folder.Self.Path
            }
        }
    }
    return ""
}

;! 获取选中的项(文件资源管理器中)的路径列表
GetSelectedExplorerItemsPaths() {
    hwndActive := WinActive("A") ; 获取当前活动窗口句柄
    shellApp := ComObject("Shell.Application")
    paths := []

    for (window in shellApp.Windows) {
        try {
            ; 只处理 explorer.exe 相关窗口
            if InStr(window.FullName, "explorer.exe") {
                ; 对比窗口句柄
                if (window.HWND = hwndActive) {
                    for (item in window.Document.SelectedItems) {
                        ; Console.Debug(item.Path)
                        paths.Push(item.Path)
                    }
                    return paths
                }
            }
        }
    }
    return paths
}

/**
 * ! 居中显示窗口
 * @param {String} WinTitle 'ahk_exe '|'ahk_class '|'ahk_id '|'ahk_pid '|'ahk_group '
 */
CenterWindow(WinTitle := 'A') {
    ; 获取窗口位置和大小
    if (!WinExist(WinTitle))
        return

    WinGetPos(&x, &y, &w, &h, WinTitle)
    ; 计算屏幕中心位置
    cx := (A_ScreenWidth - w) / 2
    cy := (A_ScreenHeight - y) / 2
    ; 移动窗口
    return WinMove(cx, cy, , , WinTitle)
}

/**
 * ! 判断一个字符串中是否包含数组中的任意一项
 * @param {String} targetStr 测试字符串
 * @param {Array} patterns 字符串数组
 * @param {Integer} CaseSense 是否区分大小写 (默认不区分大小写)
 * @returns {Integer} 测试结果
 */
StrIncludesAny(targetStr, patterns, CaseSense := 0) {
    for (item in patterns) {
        if InStr(StrLower(targetStr), StrLower(item), CaseSense)
            return true
    }
    return false
}


/**
 * ! 判断窗口是否置顶
 * @param {Integer} hwnd 窗口id
 */
IsAlwaysOnTop(hwnd := 0) {
    try {
        exStyle := WinGetExStyle(hwnd > 0 ? ('ahk_id ' hwnd) : 'A')   ;获取扩展样式
        return exStyle & 0x8
    } catch as e {
        Console.Debug('IsAlwaysOnTop错误消息:' e.Message)
        return false
    }
}