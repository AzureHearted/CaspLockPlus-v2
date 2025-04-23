#Requires AutoHotkey v2.0
#Include <WebView2/WebView2>

class UIWebView {
    gui := Gui('-DPIScale', '浏览器')
    ; 窗口显示标识符
    open := false
    ; 构造函数
    __New() {

    }

    ; 显示函数
    Show() {
        if (this.open)
            return
        this.open := true
        this.gui.Show(Format('w{} h{}', A_ScreenWidth * 0.5, A_ScreenHeight * 0.6))
        this.gui.OnEvent('Close', (*) => (this.open := false, wvc := wv := 0))
        wvc := WebView2.CreateControllerAsync(this.gui.Hwnd).await2()
        wv := wvc.CoreWebView2
        wv.Navigate('http://localhost:9999/')

    }
}
