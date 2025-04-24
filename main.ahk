#Requires AutoHotkey v2.0

#Include <lib_initialize>
#Include <lib_functions>
#Include <lib_keysFunLogic>
#Include <lib_bindingWindow>
#Include <lib_keysMap>
#Include <lib_keysFunction>
#Include user_keysSet.ahk ;* 导入用户自定义按键设置(位置尽量靠前)

;todo 初始化
Init()

CapsLock:: {
    funcLogic_capsHold()
}

; 通过 Shift + CapsLock 触发切换CapsLock
+CapsLock:: {
    funcLogic_capsSwitch()
}

/** CapsLock 热键 */
#HotIf GetKeyState('CapsLock', 'P')

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