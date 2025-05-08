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


CapsCondition(*) => GetKeyState("CapsLock", "P")

; 按下 CapsLock 后触发 CapsLock 按下事件
Hotkey('CapsLock', (*) => funcLogic_capsHold())

; 通过 Shift + CapsLock 触发切换CapsLock
Hotkey('+CapsLock', (*) => funcLogic_capsSwitch())

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
    HoldCapsLockShowTipsDelay: 2000, ; 提示窗口显示延时（ms,100 ~ 5000）
    HotTipsTransparent: 200 ; 提示窗口的透明度（0 ~ 255）
}

;* UI集合
UISets := {
    setting: UISetting('settings.ini'), ; 设置窗口
    hotTips: UITips(, '已绑定的窗口`t', ["按键", "进程"]), ; Caps按住一段时间后的提示窗口及内容
    webview: UIWebView(),
}


;! 初始化
Init() {
    global UserHotStr
    ;* 装载图标
    LoadIcon()

    ;* 初始化配置
    InitSetting()

    ;* 检测并修复配置生效状态
    CheckAndFixSettingsStatus()

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
        ; 提示窗透明度
        IniWrite(200, SettingIniPath, "General", 'HotTipsTransparent')
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

;* 检测并修复配置生效状态
CheckAndFixSettingsStatus() {
    global SettingIniPath, UserConfig
    ;? 判断是否开机自启动
    isAutoStart := IniRead(SettingIniPath, 'General', 'AutoStart', false)
    autostartLnk := A_StartupCommon . "\CapsLockPlus v2.lnk"
    if (isAutoStart) {
        ; 如果开启开机自启动
        if (FileExist(autostartLnk))
        {
            FileGetShortcut(autostartLnk, &lnkTarget)
            if (lnkTarget != A_ScriptFullPath)
                FileCreateShortcut(A_ScriptFullPath, autostartLnk, A_WorkingDir)
        } else {
            FileCreateShortcut(A_ScriptFullPath, autostartLnk, A_WorkingDir)
        }
    } else {
        if (FileExist(autostartLnk))
        {
            FileDelete(autostartLnk)
        }
    }

    ;? 从settings.ini中更新 HoldCapsLockShowTipsDelay
    UserConfig.HoldCapsLockShowTipsDelay := IniRead(SettingIniPath, 'General', 'HoldCapsLockShowTipsDelay', 1500)
    UserConfig.HotTipsTransparent := IniRead(SettingIniPath, 'General', 'HotTipsTransparent', 200)
    UISets.hotTips.transparent := UserConfig.HotTipsTransparent
}