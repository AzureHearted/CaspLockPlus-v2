#Requires AutoHotkey v2.0
; #Include <WebView2/WebView2>
#Include <lib_functions>

class UISetting {
    gui := Gui('+AlwaysOnTop +ToolWindow', '用户设置')
    open := false   ;窗口开启标识符
    iniPath := ''

    ; 构造函数
    __New(iniPath) {
        this.iniPath := iniPath
        ; 构建界面

        ; 开机自启
        this.autoStartCheckBox := this.gui.AddCheckbox('r1.5 vAutoStart', '开机启动')
        ; 按钮
        this.gui.AddButton('r1', '保存(&S)').OnEvent('Click', (*) => this.Save())
        this.gui.AddButton('+x+5', '关闭').OnEvent('Click', (*) => this.Close())

        ; 绑定事件
    }

    ; 加载配置
    Load() {
        ; 从ini中读取变量
        this.autoStartCheckBox.Value := IniRead(this.iniPath, 'General', 'AutoStart', 0)
    }

    ; 显示窗口
    Show() {
        if (this.open)
            return
        this.open := true

        ; 加载配置
        this.Load()

        ; 显示窗口
        this.gui.Show('AutoSize Center')
        ; WinGetPos(&x, &y, &w, &y, this.gui)
        ; 计算屏幕中心位置
        ; cx := (A_ScreenWidth - w) / 2
        ; cy := (A_ScreenHeight - y) / 2
        ; this.gui.Move(cx, cy)
        this.gui.OnEvent('Close', (*) => (this.open := false))
    }

    ; 保存配置
    Save() {
        OutputDebug('设置保存')
        IniWrite(this.autoStartCheckBox.Value, this.iniPath, 'General', 'AutoStart')
        ;! 检测并修复配置生效状态
        CheckAndFixSettingsStatus()
        this.Close()
    }

    ; 关闭窗口
    Close() {
        WinClose(this.gui)
    }

    ; 析构函数
    __Delete() {
        this.gui := ''
    }
}