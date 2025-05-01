#Requires AutoHotkey v2.0
#Include <lib_functions>
#Include <lib_userHotString>
#Include ../gui/ui_setting.ahk
#Include ../gui/ui_webview.ahk
#Include ../gui/ui_tips.ahk

; A_MaxHotkeysPerInterval和A_HotkeyInterval变量控制热键激活的速率, 超过此速率将显示警告对话框.
A_MaxHotkeysPerInterval := 500
A_HotkeyInterval := 0


;! 确保脚本以管理员身份运行 (编译前必需开启这段代码)
if (!A_IsAdmin) {
    try
    {
        ShowToolTips('检测到脚本并未以管理员身份启动，现重新已管理员身份启动')
        Run('*RunAs "' A_ScriptFullPath '"')
        ExitApp()
    }
    catch as e {
        MsgBox ("无法以管理员身份运行脚本。错误信息：" e.Message)
        ExitApp()
    }
}

; 用户设置的ini路径
SettingIniPath := 'settings.ini'
; Caps 开关标识符
CapsLockOpen := GetKeyState('CapsLock', 'T') ; 记录初始CapsLock按键状态
; Caps 按住时候的标识符
CapsLockHold := false
; 用户热字符串控制器
UserHotStr := UserHotString(SettingIniPath)
; 用户配置
UserConfig := {
    HoldCapsLockShowTipsDelay: 2000
}

;* UI集合
UISets := {
    setting: UISetting('settings.ini'), ; 设置窗口
    hotTips: UITips(, '已绑定的窗口`t', ["按键", "进程"]), ; Caps按住一段时间后的提示窗口及内容
    webview: UIWebView(),
}


;! 初始化
Init() {
    ;* 装载图标
    LoadIcon()

    ;* 初始化设置
    InitSetting()

    ;* 开启用户则字符串
    UserHotStr.Enable()

    ShowToolTips('CapsLock Plus v2 已启动！')
}

;! 初始化设置
InitSetting() {
    global SettingIniPath
    /** 判断配置文件是否存在 */
    ; 如果没有检测到settings.ini则认为是首次启动
    if (!FileExist(SettingIniPath)) {
        ; 首次启动写入配置文件
        ; 开机自启
        IniWrite(0, SettingIniPath, "General", 'AutoStart')
        ; 按住CapsLock后多少ms显示Tips (默认1500ms)
        IniWrite(1500, SettingIniPath, "General", 'HoldCapsLockShowTipsDelay')
        ; Everything相关
        IniWrite("C:\Program Files\Everything\Everything.exe", SettingIniPath, "Everything", 'Path')
        ; 读取用户配置
        ShowToolTips('首次启动~')
    }

    ;* 读取配置
    LoadConfig()
}

;! 装载图标
LoadIcon() {
    CapsLockPlusIcon := './res/CapsLockPlusIcon.ico'
    if FileExist(CapsLockPlusIcon) {
        TraySetIcon(CapsLockPlusIcon, 1)
    }
}

;! 读取配置
LoadConfig() {
    global SettingIniPath, UserConfig
    UserConfig.HoldCapsLockShowTipsDelay := IniRead(SettingIniPath, 'General', 'HoldCapsLockShowTipsDelay', 1500)
}