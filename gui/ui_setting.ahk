#Requires AutoHotkey v2.0
; #Include <WebView2/WebView2>
#Include <lib_functions>

u:=UISetting('')




class UISetting {
    gui := Gui('-DPIScale AlwaysOnTop', '用户设置')
    
    iniFilePath := ''

    ; 配置对象
    config := {
        clipWaitTime: 0.05
    }

    uiObj := {}

    ; 构造函数
    __New(iniFilePath) {
        this.iniFilePath := iniFilePath
        this.open := false
        ; 构建界面

        ; general:=this.gui.AddGroupBox('w','常规')

        ; 剪贴板等待时长Edit
        this.gui.AddText('', '剪贴板超时')
        this.gui.AddEdit('+x+10 +y3')
        this.clipWaitEdit := this.gui.AddUpDown("")
        this.gui.AddText('+x+10 +y5', 'ms')

        ; 按钮
        this.gui.AddButton('', '保存').OnEvent('Click', (*) => this.Save())
        this.gui.AddButton('+x+5', '关闭').OnEvent('Click', (*) => this.Save())

        ; 绑定事件
        this.RegisterEvent()
    }

    __Delete() {

    }

    ; 注册事件
    RegisterEvent() {
        this.clipWaitEdit.OnEvent('Change', (GuiCtrlObj, Info) => (this.ClipWaitTimeEditChange(GuiCtrlObj, Info)))
    }

    ; 剪贴板等待时长的Edit值变化事件
    ClipWaitTimeEditChange(GuiCtrlObj, Info) {
        value := GuiCtrlObj.Value
        showToolTips(value . 'ms' . "`t" . Round(value / 1000, 3))

        this.config.clipWaitTime := value
    }

    ; 加载配置
    Load() {
        ; 从ini中读取变量
        this.config.clipWaitTime := IniRead(this.iniFilePath, 'General', 'ClipWaitTime', 0.05)
    }

    ; 保存配置
    Save() {
        ; showToolTips('保存')
        this.config.clipWaitTime := this.clipWaitEdit.Value
        IniWrite(Round(this.config.clipWaitTime / 1000, 3), this.iniFilePath, 'General', 'ClipWaitTime')
        this.Close()
    }

    ; 更新UI
    UpdateUI() {
        this.clipWaitEdit.Value := Round(this.config.clipWaitTime * 1000)
    }

    ; 关闭窗口
    Close() {
        WinClose(this.gui)
    }

    ; 显示窗口
    Show() {
        if (this.open)
            return
        this.open := true

        ; 加载配置
        this.Load()
        this.UpdateUI()

        ; 显示窗口
        this.gui.Show('')
        this.gui.OnEvent('Close', (*) => (this.open := false))
    }

}
