#Requires AutoHotkey v2.0

;! 提示窗口
class UITips {
    /** @type {Gui} */
    gui := ''

    ; 窗口是否显示
    isShow := false
    ; 窗口透明度
    transparent := 200
    ; 缩放率
    ; scale := A_ScreenDPI / 96
    scale := A_ScreenDPI / 96

    __New(title := "提示") {

        this.gui := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption +Border')
        ; 基础样式
        this.gui.MarginX := 6
        this.gui.MarginY := 6
        ; this.gui.MarginX := 4
        ; this.gui.MarginY := 4
        this.gui.SetFont('q5 s' (12), 'Microsoft YaHei UI')
        ; 标题
        this.title := this.gui.AddText('r1.4 Center', title)
        this.title.SetFont('q5 s' (16 * 1) ' W600', 'Microsoft YaHei UI')

        ; 事件绑定
        this.gui.OnEvent('Size', (guiObj, MinMax, wClientWidth, wClientHeight) => this.OnWindowResize(guiObj, MinMax, wClientWidth, wClientHeight))
        this.gui.OnEvent('Close', (*) => (this.isShow := false))

        this.CallAlwaysOnTopHandle := ObjBindMethod(this, 'AlwaysOnTopHandle')

    }

    /**
     * * 回调窗口尺寸
     * @param {Gui} GuiObj 窗口Gui对象
     * @param {Integer} MinMax 窗口状态
     * @param {Integer} Width 窗口宽度
     * @param {Integer} Height 窗口高度
     */
    OnWindowResize(guiObj, MinMax, wClientWidth, wClientHeight) {


        this.title.GetPos(&tX, &tY, &tW, &tH)
        this.title.Move(, , wClientWidth - this.gui.MarginX * 2)
        ; Console.Debug("wClientW:" wClientW " ,wMarginX:" wMarginX " `ttX:" tX " ,tW:" tW)
        ; Console.Debug("wClientW:" wClientW * this.scale " ,wMarginX:" wMarginX * this.scale " `ttX:" tX * this.scale " ,tW:" tW * this.scale " (scale)")
    }


    ; 改变标题
    ChangeTitle(newTitle) {
        this.title.Value := newTitle
        if (this.isShow) {
            this.title.Redraw()
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