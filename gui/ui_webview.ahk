#Requires AutoHotkey v2.0
#Include <WebView2/WebView2>

class UIWebView {
    gui := Gui('', '浏览器')
    ; 窗口显示标识符
    isShow := false
    ; 历史路径
    history := ''

    ; 构造函数
    __New() {

        ; WebView2加载器的路径
        ; this.WebView2LoaderPath := A_IsCompiled ? A_Temp '\WebView2Loader_' (A_PtrSize * 8) 'bit.dll' : A_LineFile '\..\lib\WebView2\' (A_PtrSize * 8) 'bit\WebView2Loader.dll'
        this.WebView2LoaderPath := A_Temp '\CapsLockPlus v2\WebView2Loader_' (A_PtrSize * 8) 'bit.dll'

        ; WebView2相关对象
        this.wvc := {}
        this.wv := {}

        ; 绑定事件
        this.gui.OnEvent('Close', (*) => this.Close())
        this.gui.OnEvent('Close', (*) => (this.isShow := false, this.wvc := this.wv := 0))
    }

    ; 显示窗口
    Show(url := '') {
        try {
            if (this.isShow)
                return
            this.isShow := true
            this.gui.Show(Format('w{} h{}', A_ScreenWidth * 0.5, A_ScreenHeight * 0.6) ' Center')
            wvc := WebView2.CreateControllerAsync(this.gui.Hwnd, , , , this.WebView2LoaderPath).await2()
            this.wvc := wvc
            ; wvc := WebView2.CreateControllerAsync(this.gui.Hwnd, , , , this.WebView2LoaderPath).await2()
            wv := wvc.CoreWebView2
            this.wv := wv
            


            OutputDebug(url ? url : this.history '`t' this.history)
            this.ToNavigate(url ? url : this.history)
        } catch as e {
            MsgBox(e.Message "`n" this.WebView2LoaderPath, 'WebView出错')
        }

    }

    ; 导航到指定url
    ToNavigate(url := '') {
        if (!url)
            return
        this.wv.Navigate(url)
        this.history := url
    }

    ; 隐藏窗口
    Hidden() {
        WinClose(this.gui)
    }

    Close() {
        this.isShow := false
    }

    __Delete() {
        this.gui.Destroy()
    }
}