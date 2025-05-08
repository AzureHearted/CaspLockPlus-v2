#Requires AutoHotkey v2.0
; #Include <WebView2/WebView2>
#Include <lib_functions>

class UISetting {
    gui := Gui('+AlwaysOnTop +ToolWindow', '用户设置')
    ;窗口显示标识符
    isShow := false
    iniPath := ''

    ; 构造函数
    __New(iniPath) {
        this.iniPath := iniPath
        ; 构建界面

        ; 开机自启
        this.autoStartCheckBox := this.gui.AddCheckbox('r1.5 vAutoStart', '开机启动')

        ; 按住CapsLock显示提示窗口的触发延时
        this.groupHotTips := this.gui.AddGroupBox('r2.5 xm w210 Section', '提示窗口')

        this.gui.AddText('r1 xs+8 yp+20', '长按Caps键')
        this.gui.AddEdit('r1 w50 x+2 yp-4')
        this.holdCapsLockShowTipsDelayUpDown := this.gui.AddUpDown("Range100-5000 0x80 vHoldCapsLockShowTipsDelay", 1500)
        this.gui.AddText('r1 x+4 yp+4', 'ms后回显提示')

        this.gui.AddText('r1 xs+8 yp+24', '不透明度')
        this.hotTipsTransparentSlider := this.gui.AddSlider('x+4 yp-4 Range0-255 ToolTip', 200)

        ; 按钮
        this.gui.AddButton('r1 xs', '保存(&S)').OnEvent('Click', (*) => this.Save())
        this.gui.AddButton('x+5', '关闭').OnEvent('Click', (*) => this.Hidden())

        ; 绑定事件
        this.gui.OnEvent('Close', (*) => (this.isShow := false))
    }

    ; 加载配置
    Load() {
        ; 从ini中读取变量
        this.autoStartCheckBox.Value := IniRead(this.iniPath, 'General', 'AutoStart', 0)
        this.holdCapsLockShowTipsDelayUpDown.Value := IniRead(this.iniPath, 'General', 'HoldCapsLockShowTipsDelay', 1500)
        this.hotTipsTransparentSlider.Value := IniRead(this.iniPath, 'General', 'HotTipsTransparent', 200)
    }

    ; 显示窗口
    Show() {
        if (this.isShow)
            return
        this.isShow := true

        ; 加载配置
        this.Load()

        ; 显示窗口
        this.gui.Show('AutoSize Center')
    }

    ; 保存配置
    Save() {
        OutputDebug('设置保存')
        IniWrite(this.autoStartCheckBox.Value, this.iniPath, 'General', 'AutoStart')
        IniWrite(this.holdCapsLockShowTipsDelayUpDown.Value, this.iniPath, 'General', 'HoldCapsLockShowTipsDelay')
        IniWrite(this.hotTipsTransparentSlider.Value, this.iniPath, 'General', 'HotTipsTransparent')
        ;! 检测并修复配置生效状态
        CheckAndFixSettingsStatus()
        this.Hidden()
    }

    ; 隐藏窗口
    Hidden() {
        WinClose(this.gui)
    }


    ; 析构函数
    __Delete() {
        this.gui.Destroy()
    }
}