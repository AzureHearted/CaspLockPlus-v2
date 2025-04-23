#Requires AutoHotkey v2.0
#Include lib_functions.ahk

;! 初始化设置
InitSetting() {
    /** 判断配置文件是否存在 */
    ; 如果没有检测到settings.ini则认为是首次启动
    if (!FileExist('settings.ini')) {
        ; 首次启动写入配置文件
        ; 开机自启
        IniWrite(0, 'settings.ini', "General", 'AutoStart')
        ; Everything相关
        IniWrite("C:\Program Files\Everything\Everything.exe", 'settings.ini', "Everything", 'path')
        ShowToolTips('首次启动~')
    } else {
        ShowToolTips('已读取配置~')
    }
}