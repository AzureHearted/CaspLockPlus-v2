#Requires AutoHotkey v2.0

;! 提示窗口
class UITips {
    gui := Gui('+AlwaysOnTop -Caption +ToolWindow -DPIScale')
    open := false
    /**
     * @param content 要展示的内容
     */
    __New(content := "", title := "提示", defColumns := ['提示']) {
        this.content := content
        this.title := title
        ; SetTransparentWindow(this.gui.Hwnd, 0.2)
        scale := A_ScreenDPI / 96
        this.gui.SetFont('s' 10 * scale, 'Segoe UI')
        this.titleControl := this.gui.AddText('r1.2 Center', this.title)
        this.titleControl.SetFont('s' 10 * scale * 1.2 ' bold')
        this.listViewControl := this.gui.AddListView("r8 w320 ReadOnly",defColumns)

        ; 事件绑定
        this.gui.OnEvent('Close', (*) => (this.open := false))
    }

    ; 显示窗口
    Show() {
        if (this.open) ;* 防止重复显示
            return
        this.open := true

        this.gui.Show('NoActivate AutoSize')
        ; this.gui.Show('w' A_ScreenWidth * 0.5 'h' A_ScreenHeight * 0.5 'NoActivate')
        ; this.gui.Show('NoActivate AutoSize')

        ; 设置窗口样式
        hwnd := this.gui.Hwnd
        WinSetTransparent(200, 'ahk_id' hwnd)
    }

    ; 关闭窗口
    Close() {
        this.open := false
        WinClose(this.gui)
        this.ClearTips()
    }
    ; 改变标题
    ChangeTitle(newTitle) {
        this.titleControl.Value := newTitle
        this.titleControl.Redraw()
    }

    ; 改变内容
    ChangeContent(newContent) {
        ; this.contentControl.Value := newContent
        ; this.contentControl.Redraw()
    }

    ; 添加tip项
    AddTipItem(arg*) {
        this.listViewControl.Add(, arg*)
        this.listViewControl.Opt('Sort')
    }

    ; 清空所有tip项
    ClearTips() {
        this.listViewControl.Delete()
    }

    OnClose(callback) {
        this.gui.OnEvent('Close', callback)
    }
}