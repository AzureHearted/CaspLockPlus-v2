#Requires AutoHotkey v2.0
#Include <WebView2/WebView2>

class UIWebView {
    gui := Gui('', '浏览器')
    ; 窗口显示标识符
    isShow := false
    ; 构造函数
    __New() {
        ; 绑定事件
        this.gui.OnEvent('Close', (*) => (this.isShow := false))
    }

    ; 显示窗口
    Show() {
        if (this.isShow)
            return
        this.isShow := true
        this.gui.Show(Format('w{} h{}', A_ScreenWidth * 0.5, A_ScreenHeight * 0.6) ' Center')
        this.gui.OnEvent('Close', (*) => (this.isShow := false, wvc := wv := 0))
        wvc := WebView2.CreateControllerAsync(this.gui.Hwnd).await2()
        wv := wvc.CoreWebView2
        wv.Navigate('http://localhost:9999/')
    }

    ; 隐藏窗口
    Hidden() {
        WinClose(this.gui)
    }

    __Delete() {
        this.gui.Destroy()
    }
}