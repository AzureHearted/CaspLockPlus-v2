#Requires AutoHotkey v2.0
#Include lib_functions.ahk
;~ 初始化段，也就是自动运行段，所有需要自动运行的代码放这里，然后放到程序最开头
; SetTimer(initAll, -400) ;等个100毫秒，等待其他文件的include都完成

; 初始化
initAll() {
    Suspend(1)  ;挂起所有热键

    Suspend(0)
    return
}
