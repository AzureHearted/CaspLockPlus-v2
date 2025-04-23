#Requires AutoHotkey v2.0

#Include <lib_functions>
#Include <lib_keysFunLogic>
#Include <lib_bindingWindow>
#Include <lib_keysMap>
#Include <lib_keysFunction>
#Include gui\ui_setting.ahk
#Include gui\ui_webview.ahk

; 编译前必需开启这段代码
if (!A_IsAdmin) {
    try
    {
        showToolTips('检测到脚本并未以管理员身份启动，现重新已管理员身份启动')
        Run('*RunAs "' A_ScriptFullPath '"')
        ExitApp
    }
    catch Error {
        MsgBox "无法以管理员身份运行脚本。错误：" Error
        ExitApp
    }
}

/** 脚本图标 */
CapsLockPlusIcon := './res/CapsLockPlusIcon.ico'
if FileExist(CapsLockPlusIcon) {
    TraySetIcon(CapsLockPlusIcon, 1)
}

/** CapsLock 状态控制 */

; CapsLock状态
CapsLockOpen := GetKeyState('CapsLock', 'T') ; 记录初始CapsLock按键状态

#Include gui\ui_tips.ahk
ui_Tips := UITips('test')

; 屏蔽CapsLock原始事件
CapsLockHold := false


CapsLock:: {
    ; global ui_Tips, CapsLockHold
    ; if (CapsLockHold)
    ;     return
    ; CapsLockHold := true
    ; holdCapsLock()
}

holdCapsLock(time := 1000) {
    global ui_Tips, CapsLockHold
    OutputDebug('开始计时')
    SetTimer(handle, -time)

    handle() {
        if (GetKeyState('CapsLock', 'P'))
            ; 如果⌛️计时器结束时候还检测到
            OutputDebug('识别到按住CapsLock')
        ui_Tips.Show()
        KeyWait('CapsLock')
        CapsLockHold := false
        ui_Tips.Close()
    }
}

; CapsLock Up:: {
;     ui_Tips.Close()
; }

; 通过 Shift + CapsLock 触发切换CapsLock
+CapsLock:: {
    funcLogic_capsLockOpen()
}

/**
 * CapsLock 开关切换
 */
funcLogic_capsLockOpen() {
    global CapsLockOpen
    CapsLockOpen := !CapsLockOpen
    SetCapsLockState(CapsLockOpen)
    showToolTips("CapsLock键(已" (CapsLockOpen ? '开启' : '关闭') ")")
    return
}

/** 导入用户自定义按键设置(位置尽量靠前) */
#Include user_keysSet.ahk

/** CapsLock 热键 */
#HotIf GetKeyState('CapsLock', 'P')

/** 当按下CapsLock键时防止按下alt键 */
; RAlt::
; LAlt::
; {
;     if (GetKeyState('CapsLock', 'p')) {
;         OutputDebug('不触发alt')
;     }
; }

; ================= CapsLock + Key ... 开始 =================
; =========   A ~ Z ... 开始
a::
b::
c::
d::
e::
f::
g::
h::
i::
j::
k::
l::
m::
n::
o::
p::
q::
r::
s::
t::
u::
v::
w::
x::
y::
z::
; =========   F1 ~ F12 ... 开始
f1::
f2::
f3::
f4::
f5::
f6::
f7::
f8::
f9::
f10::
f11::
f12::
; =========   0 ~ 9 ... 开始
0::
1::
2::
3::
4::
5::
6::
7::
8::
9::
{
    funName := keysMap['caps_' A_ThisHotkey]
    %funName%()
}

; =========   其他符号 ... 开始
`:: %keysMap['caps_backquote']%()
-:: %keysMap['caps_minus']%()
=:: %keysMap['caps_equal']%()
BackSpace:: %keysMap['caps_backspace']%()
Tab:: %keysMap['caps_tab']%()
[:: %keysMap['caps_leftSquareBracket']%()
]:: %keysMap['caps_rightSquareBracket']%()
\:: %keysMap['caps_backslash']%()
`;:: %keysMap['caps_semicolon']%()
':: %keysMap['caps_quote']%()
Enter:: %keysMap['caps_enter']%()
,:: %keysMap['caps_comma']%()
.:: %keysMap['caps_dot']%()
/:: %keysMap['caps_slash']%()
Space:: %keysMap['caps_space']%()

; =========   鼠标操作 ... 开始
WheelUp:: %keysMap['caps_wheelUp']%()
WheelDown:: %keysMap['caps_wheelDown']%()
MButton:: %keysMap['caps_midButton']%()
LButton:: %keysMap['caps_leftButton']%()
RButton:: %keysMap['caps_rightButton']%()

; ================= CapsLock + Alt + Key ... 开始 =================
; =========   A ~ Z ... 开始
$!a::
$!b::
$!c::
$!d::
$!e::
$!f::
$!g::
$!h::
$!i::
$!j::
$!k::
$!l::
$!m::
$!n::
$!o::
$!p::
$!q::
$!r::
$!s::
$!t::
$!u::
$!v::
$!w::
$!x::
$!y::
$!z::
; =========   F1 ~ F12 ... 开始
!f1::
!f2::
!f3::
!f4::
!f5::
!f6::
!f7::
!f8::
!f9::
!f10::
!f11::
!f12::
; =========   0 ~ 9 ... 开始
!0::
!1::
!2::
!3::
!4::
!5::
!6::
!7::
!8::
!9::
{
    RegExMatch(A_ThisHotkey, '(?<=\!)[^!]+?$', &hotKey)
    funName := keysMap['caps_alt_' hotKey[]]
    %funName%()
}

; =========   其他符号 ... 开始
!`:: %keysMap['caps_alt_backquote']%()
!-:: %keysMap['caps_alt_minus']%()
!=:: %keysMap['caps_alt_equal']%()
!BackSpace:: %keysMap['caps_alt_backspace']%()
!Tab:: %keysMap['caps_alt_tab']%()
![:: %keysMap['caps_alt_leftSquareBracket']%()
!]:: %keysMap['caps_alt_rightSquareBracket']%()
!\:: %keysMap['caps_alt_backslash']%()
!`;:: %keysMap['caps_alt_semicolon']%()
!':: %keysMap['caps_alt_quote']%()
!Enter:: %keysMap['caps_alt_enter']%()
!,:: %keysMap['caps_alt_comma']%()
!.:: %keysMap['caps_alt_dot']%()
!/:: %keysMap['caps_alt_slash']%()
!Space:: %keysMap['caps_alt_space']%()

; =========   鼠标操作 ... 开始
!WheelUp:: %keysMap['caps_alt_wheelUp']%()
!WheelDown:: %keysMap['caps_alt_wheelDown']%()
!MButton:: %keysMap['caps_alt_midButton']%()
!LButton:: %keysMap['caps_alt_leftButton']%()
!RButton:: %keysMap['caps_alt_rightButton']%()

; ================= CapsLock + Shift + Key ... 开始 =================
; =========   A ~ Z ... 开始
+a::
+b::
+c::
+d::
+e::
+f::
+g::
+h::
+i::
+j::
+k::
+l::
+m::
+n::
+o::
+p::
+q::
+r::
+s::
+t::
+u::
+v::
+w::
+x::
+y::
+z::
; =========   F1 ~ F12 ... 开始
+f1::
+f2::
+f3::
+f4::
+f5::
+f6::
+f7::
+f8::
+f9::
+f10::
+f11::
+f12::
; =========   0 ~ 9 ... 开始
+0::
+1::
+2::
+3::
+4::
+5::
+6::
+7::
+8::
+9::
{
    RegExMatch(A_ThisHotkey, '(?<=\+)[^+]+?$', &hotKey)
    funName := keysMap['caps_shift_' hotKey[]]
    %funName%()
}

; =========   其他符号 ... 开始
+`:: %keysMap['caps_shift_backquote']%()
+-:: %keysMap['caps_shift_minus']%()
+=:: %keysMap['caps_shift_equal']%()
+BackSpace:: %keysMap['caps_shift_backspace']%()
+Tab:: %keysMap['caps_shift_tab']%()
+[:: %keysMap['caps_shift_leftSquareBracket']%()
+]:: %keysMap['caps_shift_rightSquareBracket']%()
+\:: %keysMap['caps_shift_backslash']%()
+`;:: %keysMap['caps_shift_semicolon']%()
+':: %keysMap['caps_shift_quote']%()
+Enter:: %keysMap['caps_shift_enter']%()
+,:: %keysMap['caps_shift_comma']%()
+.:: %keysMap['caps_shift_dot']%()
+/:: %keysMap['caps_shift_slash']%()
+Space:: %keysMap['caps_shift_space']%()

; =========   鼠标操作 ... 开始
+WheelUp:: %keysMap['caps_shift_wheelUp']%()
+WheelDown:: %keysMap['caps_shift_wheelDown']%()
+MButton:: %keysMap['caps_shift_midButton']%()
+LButton:: %keysMap['caps_shift_leftButton']%()
+RButton:: %keysMap['caps_shift_rightButton']%()

; ================= CapsLock + Win + Key ... 开始 =================
; =========   A ~ Z ... 开始
#a::
#b::
#c::
#d::
#e::
#f::
#g::
#h::
#i::
#j::
#k::
#l::
#m::
#n::
#o::
#p::
#q::
#r::
#s::
#t::
#u::
#v::
#w::
#x::
#y::
#z::
; =========   F1 ~ F12 ... 开始
#f1::
#f2::
#f3::
#f4::
#f5::
#f6::
#f7::
#f8::
#f9::
#f10::
#f11::
#f12::
; =========   0 ~ 9 ... 开始
#0::
#1::
#2::
#3::
#4::
#5::
#6::
#7::
#8::
#9::
{
    hotKey := StrReplace(A_ThisHotkey, '#')
    RegExMatch(A_ThisHotkey, '(?<=\#)[^#]+?$', &hotKey)
    funName := keysMap['caps_win_' hotKey[]]
    %funName%()
}

; =========   其他符号 ... 开始
#`:: %keysMap['caps_win_backquote']%()
#-:: %keysMap['caps_win_minus']%()
#=:: %keysMap['caps_win_equal']%()
#BackSpace:: %keysMap['caps_win_backspace']%()
#Tab:: %keysMap['caps_win_tab']%()
#[:: %keysMap['caps_win_leftSquareBracket']%()
#]:: %keysMap['caps_win_rightSquareBracket']%()
#\:: %keysMap['caps_win_backslash']%()
#`;:: %keysMap['caps_win_semicolon']%()
#':: %keysMap['caps_win_quote']%()
#Enter:: %keysMap['caps_win_enter']%()
#,:: %keysMap['caps_win_comma']%()
#.:: %keysMap['caps_win_dot']%()
#/:: %keysMap['caps_win_slash']%()
#Space:: %keysMap['caps_win_space']%()

; =========   鼠标操作 ... 开始
#WheelUp:: %keysMap['caps_win_wheelUp']%()
#WheelDown:: %keysMap['caps_win_wheelDown']%()
#MButton:: %keysMap['caps_win_midButton']%()
#LButton:: %keysMap['caps_win_leftButton']%()
#RButton:: %keysMap['caps_win_rightButton']%()

#HotIf