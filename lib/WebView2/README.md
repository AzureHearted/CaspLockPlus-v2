# WebView2

Microsoft Edge WebView2 控件允许您使用 Microsoft Edge (Chromium) 作为渲染引擎在应用程序中托管 Web 内容。 有关详细信息,请参阅 [Microsoft Edge WebView2] 的概述(https://docs.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/) 和 Getting Started with WebView2。

WebView2 Runtime内置于Win10(最新版本)和Win11中,可以在AHK中轻松使用。

## api 转换
- 异步方法将具有 `Async` 后缀,如 `ExecuteScriptAsync`,并在调用后返回 [Promise](https://github.com/thqby/ahk2_lib/blob/master/Promise.ahk)。
- `add_event` 方法接受具有两个最小参数的 ahk 调用对象,它有一个名为 `event` 的方法,该方法返回该对象并在对象销毁后取消注册事件。

## 示例1:AddHostObjectToEdge,使用多个窗口打开
```autohotkey
#Include <WebView2\WebView2>

main := Gui()
main.OnEvent('Close', (*) => (wvc := wv := 0))
main.Show(Format('w{} h{}', A_ScreenWidth * 0.6, A_ScreenHeight * 0.6))

wvc := WebView2.CreateControllerAsync(main.Hwnd).await2()
wv := wvc.CoreWebView2
wv.Navigate('https://autohotkey.com')
wv.AddHostObjectToScript('ahk', {str:'str from ahk',func:MsgBox})
wv.OpenDevToolsWindow()
```

在 Edge DevTools 中运行代码
```javascript
obj = await window.chrome.webview.hostObjects.ahk;
obj.func('call from edge\n' + (await obj.str));
obj = window.chrome.webview.hostObjects.sync.ahk;
obj.func('call from edge\n' + obj.str);
```

## 例2:仅使用一个选项卡打开
```autohotkey
#Include <WebView2\WebView2>

main := Gui()
main.OnEvent('Close', (*) => ExitApp())
main.Show(Format('w{} h{}', A_ScreenWidth * 0.6, A_ScreenHeight * 0.6))

wvc := WebView2.CreateControllerAsync(main.Hwnd).await2()
wv := wvc.CoreWebView2
nwr := wv.NewWindowRequested(NewWindowRequestedHandler)
wv.Navigate('https://autohotkey.com')

NewWindowRequestedHandler(wv2, arg) {
	deferral := arg.GetDeferral()
	arg.NewWindow := wv2
	deferral.Complete()
}
```

## 例3:在一个窗口中打开多个选项卡
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

## Example4: PrintToPDF
```
#Include <WebView2\WebView2>

main := Gui()
main.Show('w800 h600')
wvc := WebView2.CreateControllerAsync(main.Hwnd).await2()
wv := wvc.CoreWebView2
wv.Navigate('https://autohotkey.com')
MsgBox('Wait for loading to complete')
PrintToPdf(wv, A_ScriptDir '\11.pdf')

PrintToPdf(wv, path) {
	set := wv.Environment.CreatePrintSettings()
	set.Orientation := WebView2.PRINT_ORIENTATION.LANDSCAPE
	waitting := true, t := A_TickCount
	try {
		wv.PrintToPdfAsync(A_ScriptDir '\11.pdf', set).await2(5000)
		Run(A_ScriptDir '\11.pdf')
		MsgBox('PrintToPdf complete')
	} catch TimeoutError
		MsgBox('PrintToPdf timeout')
}
```