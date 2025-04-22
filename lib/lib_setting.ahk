#Requires AutoHotkey v2.0
#Include lib_functions.ahk

initSetting() {
    /** 判断配置文件是否存在 */
    ; 如果没有检测到settings.ini则认为是首次启动
    if (!FileExist('settings.ini')) {
        ; 首次启动写入配置文件
        ; 剪贴板等待时长
        IniWrite(0.05, 'settings.ini', "General", 'ClipWaitTime')
        showToolTips('首次启动~')
    } else {
        showToolTips('已读取配置')
    }
}
