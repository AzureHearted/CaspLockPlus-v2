# WebView2 中文说明

Microsoft Edge WebView2 控件允许你在应用程序中使用 Microsoft Edge (Chromium) 作为渲染引擎来嵌入网页内容。更多信息请参见 [Microsoft Edge WebView2 简介](https://docs.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/) 和 WebView2 入门指南。

WebView2 运行时已内置于 Win10（最新版）和 Win11 中，可在 AHK 中轻松使用。

## API 转换说明
- 异步方法会带有 `Async` 后缀，例如 `ExecuteScriptAsync`，调用后返回一个 [Promise](https://github.com/thqby/ahk2_lib/blob/master/Promise.ahk)。
- `add_event` 方法接受一个 AHK 可调用对象，最少包含两个参数；它拥有一个名为 `event` 的方法，当对象销毁时取消事件注册。

## 示例 1：AddHostObjectToEdge，多窗口打开
```autohotkey
#Include <WebView2\WebView2>

main := Gui()
main.OnEvent('Close', (*) => (wvc := wv := 0)) ; 关闭 GUI 时清除变量
main.Show(Format('w{} h{}', A_ScreenWidth * 0.6, A_ScreenHeight * 0.6))

wvc := WebView2.CreateControllerAsync(main.Hwnd).await2() ; 创建 WebView 控件
wv := wvc.CoreWebView2
wv.Navigate('https://autohotkey.com') ; 导航到网页
wv.AddHostObjectToScript('ahk', {str:'来自 ahk 的字符串',func:MsgBox}) ; 添加宿主对象
wv.OpenDevToolsWindow() ; 打开开发者工具窗口
```

在 Edge 开发者工具中运行以下代码：
```javascript
obj = await window.chrome.webview.hostObjects.ahk;
obj.func('来自 Edge 的调用\n' + (await obj.str));
obj = window.chrome.webview.hostObjects.sync.ahk;
obj.func('来自 Edge 的调用\n' + obj.str);
```

## 示例 2：仅开启一个标签页
```autohotkey
#Include <WebView2\WebView2>

main := Gui()
main.OnEvent('Close', (*) => ExitApp()) ; 关闭 GUI 时退出应用
main.Show(Format('w{} h{}', A_ScreenWidth * 0.6, A_ScreenHeight * 0.6))

wvc := WebView2.CreateControllerAsync(main.Hwnd).await2()
wv := wvc.CoreWebView2
nwr := wv.NewWindowRequested(NewWindowRequestedHandler) ; 拦截新窗口请求
wv.Navigate('https://autohotkey.com')

NewWindowRequestedHandler(wv2, arg) {
    deferral := arg.GetDeferral()
    arg.NewWindow := wv2 ; 将新窗口绑定为当前 WebView
    deferral.Complete()
}
```

## 示例 3：单窗口多标签页
```autohotkey
#Include <WebView2\WebView2>

main := Gui('+Resize'), main.MarginX := main.MarginY := 0
main.OnEvent('Close', _exit_)
main.OnEvent('Size', gui_size)
tab := main.AddTab2(Format('w{} h{}', A_ScreenWidth * 0.6, A_ScreenHeight * 0.6), ['tab1'])
tab.UseTab(1), tabs := []
tabs.Push(ctl := main.AddText('x0 y25 w' (A_ScreenWidth * 0.6) ' h' (A_ScreenHeight * 0.6)))
tab.UseTab()
main.Show()
ctl.wvc := wvc := WebView2.CreateControllerAsync(ctl.Hwnd).await2()
wv := wvc.CoreWebView2
ctl.nwr := wv.NewWindowRequested(NewWindowRequestedHandler)
wv.Navigate('https://autohotkey.com')

gui_size(GuiObj, MinMax, Width, Height) {
    if (MinMax != -1) {
        tab.Move(, , Width, Height)
        for t in tabs {
            t.move(, , Width, Height - 23)
            try t.wvc.Fill()
        }
    }
}

NewWindowRequestedHandler(wv2, arg) {
    deferral := arg.GetDeferral()
    tab.Add(['tab' (i := tabs.Length + 1)])
    tab.UseTab(i), tab.Choose(i)
    main.GetClientPos(, , &w, &h)
    tabs.Push(ctl := main.AddText('x0 y25 w' w ' h' (h - 25)))
    tab.UseTab()
    wv2.Environment.CreateCoreWebView2ControllerAsync(ctl.Hwnd).then(ControllerCompleted)
    ControllerCompleted(wvc) {
        ctl.wvc := wvc
        arg.NewWindow := wv := wvc.CoreWebView2
        ctl.nwr := wv.NewWindowRequested(NewWindowRequestedHandler)
        deferral.Complete()
    }
}

_exit_(*) {
    for t in tabs
        t.wvc := t.nwr := 0
    ExitApp()
}
```

## 示例 4：保存为 PDF
```autohotkey
#Include <WebView2\WebView2>

main := Gui()
main.Show('w800 h600')
wvc := WebView2.CreateControllerAsync(main.Hwnd).await2()
wv := wvc.CoreWebView2
wv.Navigate('https://autohotkey.com')
MsgBox('等待页面加载完成')
PrintToPdf(wv, A_ScriptDir '\11.pdf')

PrintToPdf(wv, path) {
    set := wv.Environment.CreatePrintSettings()
    set.Orientation := WebView2.PRINT_ORIENTATION.LANDSCAPE ; 设置横向打印
    waitting := true, t := A_TickCount
    try {
        wv.PrintToPdfAsync(A_ScriptDir '\11.pdf', set).await2(5000)
        Run(A_ScriptDir '\11.pdf')
        MsgBox('打印完成')
    } catch TimeoutError
        MsgBox('打印超时')
}
```