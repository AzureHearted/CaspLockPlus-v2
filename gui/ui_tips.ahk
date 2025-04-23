#Requires AutoHotkey v2.0

; 提示窗口
class UITips {
    gui := Gui('+AlwaysOnTop -Caption -DPIScale +ToolWindow')
    open := false
    /** 要显示的内容
     * @type {String}
     */
    content := ''

    __New(content := '') {
        this.content := content
        ; SetTransparentWindow(this.gui.Hwnd, 0.2)
        this.gui.OnEvent('Close', (*) => (this.open := false))
    }

    ; 显示窗口
    Show() {
        if (this.open)
            return
        this.open := true

        this.gui.Show('w300 h200 NoActivate')

        hwnd := this.gui.Hwnd
        WinSetTransparent(150, 'ahk_id' hwnd)
    }

    ; 关闭窗口
    Close() {
        this.open := false
        WinClose(this.gui)
    }

    OnClose(callback) {
        this.gui.OnEvent('Close', callback)
    }
}
