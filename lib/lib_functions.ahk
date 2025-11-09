#Requires AutoHotkey v2.0

/**
 * 显示ToolTips消息
 * @param {String} msg 消息内容
 * @param {Integer} duration 持续时间ms
 * @param {Integer} id 如果省略, 默认为 1(第一个工具提示). 否则, 请指定一个介于 1 和 20 之间的数字, 在同时使用了多个工具提示时, 用来表示要操作的工具提示窗口.
 */
ShowToolTips(msg, duration := 1000, id := 1) {
    static channelMap := Map()  ; 用来保存每个 id 的定时器

    ; --- 先显示消息 ---
    ToolTip(msg, , , id)

    ; --- 如果该 id 已经存在定时器，则先删除它（防止重复定时） ---
    if channelMap.Has(id) {
        SetTimer(channelMap[id], 0)
    }

    ; --- 定义一个新的定时器，用于隐藏该 ToolTip ---
    timerFunc := (*) => (
        ToolTip(, , , id),  ; 清除对应 id 的 ToolTip
        channelMap.Delete(id)  ; 从 map 移除（释放资源）
    )

    ; --- 保存并启动定时器 ---
    channelMap[id] := timerFunc
    SetTimer(timerFunc, -duration)
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
    try {
        for (window in shellApp.Windows) {
            if InStr(window.FullName, "explorer.exe") && window.HWND = hwndActive {
                return window.Document.Folder.Self.Path
            }
        }
    } catch as ex {
        Console.Debug("GetActiveExplorerPath 执行出错：" ex.Message)
    }
    return ""
}

;! 获取选中的项(文件资源管理器中)的路径列表
GetSelectedExplorerItemsPaths() {
    hwndActive := WinActive("A") ; 获取当前活动窗口句柄
    shellApp := ComObject("Shell.Application")
    paths := []

    try {
        for (window in shellApp.Windows) {
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
    } catch as ex {
        Console.Debug("GetSelectedExplorerItemsPaths 执行出错：" ex.Message)
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

/**
 * 获取 Windows 版本函数
 * @returns {{Major:Integer,Minor:Integer,Build:Integer,Full:String}} 
 * - Major 主版本号（例如：Windows 10 为 10）
 * - Minor 次版本号
 * - Build 内部构建号
 * - Full 完整版本号
 */
GetWindowsVersion() {
    ; 获取系统版本号的经典方法，兼容所有 Windows。
    ver := DllCall("GetVersion", "UInt")
    major := ver & 0xFF
    minor := (ver >> 8) & 0xFF
    build := (ver >> 16) & 0xFFFF
    return {
        Major: major,
        Minor: minor,
        Build: build,
        Full: major "." minor "." build
    }
}