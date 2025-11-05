#Requires AutoHotkey v2.0

;! 在系统temp文件夹下创建依赖目录，并释放依赖文件
DirCreate(A_Temp '\CapsLockPlus v2')
try {
    FileInstall('lib/WebView2/32bit/WebView2Loader.dll', A_Temp '\CapsLockPlus v2\WebView2Loader_32bit.dll', 1)
    FileInstall('lib/WebView2/64bit/WebView2Loader.dll', A_Temp '\CapsLockPlus v2\WebView2Loader_64bit.dll', 1)
    FileInstall('lib/WindowSpy.exe', A_Temp '\CapsLockPlus v2\WindowSpy.exe', 1)
    FileInstall('res/keysMap.html', A_Temp '\CapsLockPlus v2\keysMap.html', 1)
    FileInstall('res/CapsLockPlusIcon.ico', A_Temp '\CapsLockPlus v2\CapsLockPlusIcon.ico', 1)
    FileInstall('res/cancelAlwaysOnTop.png', A_Temp '\CapsLockPlus v2\cancelAlwaysOnTop.png', 1)
} catch as ex {
    Console.Debug('释放依赖过程中发生意外错误`n' . ex.Message)
}


#Include <lib_functions>
#Include <lib_userHotString>
#Include <lib_userTips>
#Include <Console>
#Include ../gui/ui_setting.ahk
#Include ../gui/ui_webview.ahk
#Include ../gui/ui_batchRename.ahk


; Console.Debug("测试", "文本")

; A_MaxHotkeysPerInterval和A_HotkeyInterval变量控制热键激活的速率, 超过此速率将显示警告对话框.
A_MaxHotkeysPerInterval := 500
A_HotkeyInterval := 0

;! 确保以管理员身份运行
full_command_line := DllCall("GetCommandLine", "str")
; if (A_IsCompiled && !A_IsAdmin) {
if ( not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))) {
    Console.Debug(full_command_line)
    try
    {

        msg := '检测到脚本并未以管理员身份启动，即将以管理员身份重新启动~'
        Console.Debug(msg)
        ShowToolTips(msg)
        ; Run('*RunAs "' A_ScriptFullPath '"')
        if A_IsCompiled
            Run '*RunAs "' A_ScriptFullPath '" /restart'
        else
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
        ExitApp()
    }
    catch as e {
        MsgBox ("无法以管理员身份运行脚本。错误信息：" e.Message)
        ExitApp()
    }
}
; MsgBox "A_IsAdmin: " A_IsAdmin "`nCommand line: " full_command_line

;! 全局变量
; 用户设置的ini路径
global SettingIniPath := 'settings.ini'
; Caps 开关标识符
global CapsLockOpen := GetKeyState('CapsLock', 'T') ; 记录初始CapsLock按键状态
; Caps 按住时候的标识符
global CapsLockHold := false
; 用户热字符串控制器
global UserHotStr := UserHotString(SettingIniPath)
; 用户配置
global UserConfig := {
    HoldCapsLockShowTipsDelay: 2000, ; 提示窗口显示延时（ms,100 ~ 5000）
    HotTipsTransparent: 200, ; 提示窗口的透明度（0 ~ 255）
    URLDefault: 'http://wdxt.taibiao.com.cn/'
}

;* UI集合
global UISets := {
    setting: UISetting('settings.ini'), ; 设置窗口
    ; hotTips: UITips('已绑定的窗口`t', ["进程", "按键"]), ; Caps按住一段时间后的提示窗口及内容
    hotTips: UserTips(), ; Caps按住一段时间后的提示窗口及内容
    keysMap: UIWebView('键盘映射', A_IsCompiled ? A_Temp '\CapsLockPlus v2\keysMap.html' : 'http://localhost:5173/', 1160, 380, {
        debug: (res) => Console.Debug(res)
    }),
    batchRename: UIBatchReName()
}

;* 托盘菜单
TrayMenu := A_TrayMenu
; TrayMenu.Delete()
; TrayMenu.Add("暂停热键",handle)
; handled(*){

; }

;! 初始化
Init() {
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
        ; 实验性功能
        IniWrite(false, SettingIniPath, "General", 'OpenExperimentalFunction')
        ShowToolTips('首次启动~')
    }

    ;* 读取配置
    LoadConfig()
}

;! 装载图标
LoadIcon() {
    CapsLockPlusIcon := A_Temp '\CapsLockPlus v2\CapsLockPlusIcon.ico'
    if FileExist(CapsLockPlusIcon) {
        TraySetIcon(CapsLockPlusIcon, 1)
    }
}

;! 读取配置
LoadConfig() {
    UserConfig.HoldCapsLockShowTipsDelay := IniRead(SettingIniPath, 'General', 'HoldCapsLockShowTipsDelay', 1500)
}

;* 检测并修复配置生效状态
CheckAndFixSettingsStatus() {
    ;? 判断是否开机自启动
    isAutoStart := IniRead(SettingIniPath, 'General', 'AutoStart', false)
    ;? 设置当前用户开机启动
    autostartLnk := A_Startup . "\CapsLockPlus v2.lnk"
    ;? 这是整个计算机开机启动
    ; autostartLnk := A_StartupCommon . "\CapsLockPlus v2.lnk"

    ;? 判断是否开机启动
    if (isAutoStart) {
        ; 设置开机启动
        if (FileExist(autostartLnk))
        {
            FileGetShortcut(autostartLnk, &lnkTarget)
            if (lnkTarget != A_ScriptFullPath)
                FileCreateShortcut(A_ScriptFullPath, autostartLnk, A_WorkingDir)
        } else {
            FileCreateShortcut(A_ScriptFullPath, autostartLnk, A_WorkingDir)
        }
    } else {
        ; 如果不设置则删除开机启动的快捷方式
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

;! 全局热键
CapsCondition(*) => GetKeyState("CapsLock", "P")

/** 阻止默认CapsLock事件 */
Hotkey('*CapsLock', (*) => false)

; 按下 CapsLock 后触发 CapsLock 按下事件
Hotkey('CapsLock', (*) => funcLogic_capsHold())

; 通过 Shift + CapsLock 触发切换CapsLock
Hotkey('+CapsLock', (*) => funcLogic_capsSwitch())

;! 鼠标事件绑定
Hotkey('WheelDown', MouseWheelHandle)
Hotkey('WheelUp', MouseWheelHandle)

/**
 * 鼠标滚动事件执行器
 * @param {'WheelDown'|'WheelUp'} HotkeyName 触发的热键
 */
MouseWheelHandle(HotkeyName) {
    try {
        MouseGetPos(&mx, &my)
        hwnd := WinActive('A')
        if (!hwnd)
            return
        WinGetPos(&wx, &wy, &ww, &wh, 'ahk_id' hwnd)
        ;? 计算当前鼠标相对窗口的位置
        mxc := mx + wx
        myc := my + wy

        ; Console.Debug('mx:' mx ',my:' my '`twx:' wx ',wy:' wy ',ww:' ww ',wh:' wh '`tmxc:' mxc ',myc:' myc '`thWnd:' hWnd)

        ;? 判断鼠标是否处于窗口顶部
        if (myc <= 0) {
            switch (HotkeyName) {
                case 'WheelUp': funcLogic_volumeUp()
                case 'WheelDown': funcLogic_volumeDown()
            }
        } else {
            ; 判断鼠标是否在窗口的前 20 像素内（窗口区域顶部）
            SendInput(Format('{{1}}', HotkeyName))
        }
    } catch as e {
        Console.Error(e)
        SendInput(Format('{{1}}', HotkeyName))
    }
}