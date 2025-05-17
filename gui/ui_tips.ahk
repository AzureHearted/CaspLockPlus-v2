#Requires AutoHotkey v2.0

;! 提示窗口
class UITips {
    gui := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption +Border')
    scale := A_ScreenDPI / 96
    ; 窗口是否显示
    isShow := false
    ; 窗口透明度
    transparent := 200

    __New(title := "提示") {
        ; 基础样式
        this.gui.MarginX := 10
        this.gui.MarginY := 10
        this.gui.SetFont('s' 10 * this.scale, 'Segoe UI')
        this.titleControl := this.gui.AddText('r1.2 Center', title)
        this.titleControl.SetFont('s' 10 * this.scale * 1.2 ' bold')

        ; 事件绑定
        this.gui.OnEvent('Close', (*) => (this.isShow := false))
    }


    ; 改变标题
    ChangeTitle(newTitle) {
        this.titleControl.Value := newTitle
        if (this.isShow) {
            this.titleControl.Redraw()
        }
    }

    ; 显示窗口
    Show() {
        if (this.isShow) ;* 防止重复显示
            return
        this.isShow := true

        this.gui.Show('NoActivate AutoSize')

        ; 设置窗口样式
        hwnd := this.gui.Hwnd
        WinSetTransparent(this.transparent, 'ahk_id' hwnd)
    }

    ; 隐藏窗口
    Hidden() {
        WinClose(this.gui)
    }

    OnClose(callback) {
        this.gui.OnEvent('Close', callback)
    }

    __Delete() {
        this.gui.Destroy()
    }
}