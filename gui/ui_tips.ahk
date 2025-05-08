#Requires AutoHotkey v2.0

;! 提示窗口
class UITips {
    gui := Gui('+AlwaysOnTop -Caption +ToolWindow')
    ; 窗口是否显示
    isShow := false
    ; 窗口透明度
    transparent := 200

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
        this.listViewControl := this.gui.AddListView("r8 ReadOnly NoSort NoSortHdr", defColumns)

        ; 事件绑定
        this.gui.OnEvent('Close', (*) => (this.isShow := false))
    }

    ; 显示窗口
    Show() {
        if (this.isShow) ;* 防止重复显示
            return
        this.isShow := true

        this.gui.Show('NoActivate AutoSize')
        this.listViewControl.Redraw()

        ; 设置窗口样式
        hwnd := this.gui.Hwnd
        WinSetTransparent(this.transparent, 'ahk_id' hwnd)
    }

    ; 隐藏窗口
    Hidden() {
        WinClose(this.gui)
        this.ClearTips()
    }

    ; 改变标题
    ChangeTitle(newTitle) {
        this.titleControl.Value := newTitle
        this.titleControl.Redraw()
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

    __Delete() {
        this.gui.Destroy()
    }
}