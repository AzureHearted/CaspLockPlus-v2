#Requires AutoHotkey v2.0

#Include <lib_functions>

; 自定义快捷键
customKeys:={

}

/** VsCode和Quicker共通的部分快捷键 */
#HotIf (WinActive('ahk_exe Code.exe') or WinActive('ahk_exe Quicker.exe')) && GetKeyState('CapsLock', 'P')

; 向⬆️移动代码
#i:: {
    SendInput('!{Up}')
}

; 向⬇️移动代码
#k:: {
    SendInput('!{Down}')
}
#HotIf

/** VsCode的部分快捷键 */
#HotIf WinActive('ahk_exe Code.exe') && GetKeyState('CapsLock', 'P')

; 删除行(Vscode 默认快捷键 Ctrl + Shift + K)
d:: {
    SendInput('^+k')
}

; 向⬆️复制行
n:: {
    ShowToolTips('向⬆️复制行')
    SendInput('+!{Up}')
}
; 向⬇️复制行
m:: {
    ShowToolTips('向⬇️复制行')
    SendInput('+!{Down}')
}

#HotIf

/** Quicker的部分快捷键 */
#HotIf WinActive('ahk_exe Quicker.exe') && GetKeyState('CapsLock', 'P')
; 向⬇️复制行
m:: {
    ShowToolTips('向⬇️复制行')
    SendInput('^{d}')
}
; 删除当前行
d:: {
    ShowToolTips('向⬇️复制行')
    SendInput('^+{d}')
}
#HotIf