#Requires AutoHotkey v2.0

;! 提示窗口
class UITips {
    gui := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption +Border')

    ; 窗口是否显示
    isShow := false
    ; 窗口透明度
    transparent := 200
    ; 缩放率
    scale := A_ScreenDPI / 96

    __New(title := "提示") {
        ; 基础样式
        this.gui.MarginX := 10 * this.scale
        this.gui.MarginY := 10 * this.scale
        this.gui.SetFont('s' (10 * this.scale), 'Segoe UI')
        ; 标题
        this.titleControl := this.gui.AddText('r1.2 Center', title)
        this.titleControl.SetFont('s' (10 * 1.2 * this.scale) ' bold')

        ; 事件绑定
        this.gui.OnEvent('Close', (*) => (this.isShow := false))

        this.CallAlwaysOnTopHandle := ObjBindMethod(this, 'AlwaysOnTopHandle')
    }


    ; 改变标题
    ChangeTitle(newTitle) {
        this.titleControl.Value := newTitle
        if (this.isShow) {
            this.titleControl.Redraw()
        }
    }

    ; 执行窗口置顶
    AlwaysOnTopHandle() {
        ; Console.Debug(this.gui.Hwnd "`t" WinExist('ahk_id' this.gui.Hwnd))
        if (WinExist('ahk_id' this.gui.Hwnd)) {
            WinSetAlwaysOnTop(true, 'ahk_id' this.gui.Hwnd)
        }
    }

    ; 显示窗口
    Show() {
        if (this.isShow) ;* 防止重复显示
            return
        this.isShow := true

        this.gui.Show('NoActivate AutoSize')

        ; 轮询设置置顶
        SetTimer(this.CallAlwaysOnTopHandle, 100)

        ; 设置窗口样式
        hwnd := this.gui.Hwnd
        WinSetTransparent(this.transparent, 'ahk_id' hwnd)
    }

    ; 隐藏窗口
    Hidden() {
        ; 取消轮询设置置顶
        SetTimer(this.CallAlwaysOnTopHandle, 0)
        WinClose(this.gui)
    }

    OnClose(callback) {
        this.gui.OnEvent('Close', callback)
    }

    __Delete() {
        this.gui.Destroy()
    }
}