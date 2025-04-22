#Requires AutoHotkey v2.0
#Include <lib_functions>
#Include <lib_keysFunLogic>
#Include <lib_bindingWindow>
#Include ../gui/ui_setting.ahk
#Include ../gui/ui_webview.ahk
#Include ../custom/custom_keysSet.ahk

/** UI集合 */
uiSets := {
    setting: UISetting('settings.ini'),
    webview: UIWebView()
}

; ================= CapsLock + Key ... 开始 =================
{
    ; =========   A ~ Z ... 开始
    {
        keyFunc_a() {
            ; ⬅️删除一个字符
            SendInput('{Backspace}')
        }
        keyFunc_b() {
            ; Win + V
            SendInput('#{v}')

        }
        keyFunc_c() {
            ; 复制
            SendInput('^c')

        }
        keyFunc_d() {
            ; 删除当前行
            funcLogic_deleteLine()
        }
        keyFunc_e() {
            ; 保存
            SendInput('^s')
        }
        keyFunc_f() {
            ; 🔍搜索
            SendInput('^{f}')

        }
        keyFunc_g() {
            ; 菜单键
            SendInput('{AppsKey}')
        }
        keyFunc_h() {
            ; ⬅️跳词
            SendInput('^{Left}')
        }
        keyFunc_i() {
            ; 方向键映射⬆️
            SendInput('{Up}')
        }
        keyFunc_j() {
            ; 方向键映射⬅️
            SendInput('{Left}')
        }
        keyFunc_k() {
            ; 方向键映射⬇️
            SendInput('{Down}')
        }
        keyFunc_l() {
            ; 方向键映射➡️
            SendInput('{Right}')
        }
        keyFunc_m() {
            ; 复制当前行到下一行
            funcLogic_copyLineDown()
            KeyWait('M')

        }
        keyFunc_n() {
            ; 复制当前行到上一行
            funcLogic_CopyLineUp()
            KeyWait('M')

        }
        keyFunc_o() {
            ; 光标定位到行尾
            SendInput('{End}')
        }
        keyFunc_p() {
            ; 映射Esc
            SendInput('{Escape}')
        }
        keyFunc_q() {
            ; 呼出Quicker搜索框
            Run("quicker:runaction:c2a16d92-c9f6-4c20-9f09-f85fb05084c2")
        }
        keyFunc_r() {
            ; 注释当前行
            SendInput('^/')
        }
        keyFunc_s() {
            ; ➡️删除一个字符
            SendInput('{Delete}')

        }
        keyFunc_t() {
        }
        keyFunc_u() {
            ; 光标定位到行首
            SendInput('{Home}')
        }
        keyFunc_v() {
            ; 粘贴
            SendInput('^v')
        }
        keyFunc_w() {
            ; 关闭标签页
            SendInput('^w')
        }
        keyFunc_x() {
            ; 剪切
            SendInput('^x')
        }
        keyFunc_y() {
            ; 还原
            SendInput('^y')
        }
        keyFunc_z() {
            ; 撤销
            SendInput('^z')
        }
    }

    ; =========   F1 ~ F12 ... 开始
    {
        keyFunc_f1() {
            ; 置顶 / 解除置顶一个窗口
            funcLogic_winPin()
        }
        keyFunc_f2() {

        }
        keyFunc_f3() {

        }
        keyFunc_f4() {

        }
        keyFunc_f5() {

        }
        keyFunc_f6() {

        }
        keyFunc_f7() {

        }
        keyFunc_f8() {

        }
        keyFunc_f9() {

        }
        keyFunc_f10() {
            /** WebView2浏览器 */
            ; showToolTips('当前热键' . A_ThisHotkey)
            global uiSets
            uiSets.webview.Show()

        }
        keyFunc_f11() {

        }
        keyFunc_f12() {
            /** 设置窗口 */
            global uiSets
            uiSets.setting.Show()

        }
    }

    ; =========   0 ~ 9 ... 开始
    {
        keyFunc_0() {

        }
        keyFunc_1() {
            BindingWindow.active('1')
        }
        keyFunc_2() {
            BindingWindow.active('2')
        }
        keyFunc_3() {
            BindingWindow.active('3')
        }
        keyFunc_4() {
            BindingWindow.active('4')
        }
        keyFunc_5() {
            BindingWindow.active('5')
        }
        keyFunc_6() {
            BindingWindow.active('6')
        }
        keyFunc_7() {
            BindingWindow.active('7')
        }
        keyFunc_8() {
            BindingWindow.active('8')
        }
        keyFunc_9() {
            ; 用()将所选内容括起来
            funcLogic_doubleChar("(", ")")
        }
    }

    ; =========   其他符号 ... 开始
    {
        ; 反引号( ` )
        keyFunc_backquote() {
            BindingWindow.active('``')
        }

        ; 减号( - )
        keyFunc_minus() {

        }

        ; 等于号（ = ）
        keyFunc_equal() {

        }

        ; ( Backspace )
        keyFunc_backspace() {

        }

        ; ( Tab )
        keyFunc_tab() {

        }

        ; 左方括号( [ )
        keyFunc_leftSquareBracket() {
            ; 用{}包裹选中内容
            funcLogic_doubleChar('{', '}')
        }

        ; 右方括号( ] )
        keyFunc_rightSquareBracket() {
            ; 用[]包裹选中内容
            funcLogic_doubleChar('[', ']')

        }

        ; 反斜杠( \ )
        keyFunc_backslash() {

        }

        ; 分号( ; )
        keyFunc_semicolon() {
            ; ➡️跳词
            SendInput('^{Right}')
        }

        ; 双引号( "" )
        keyFunc_quote() {

        }

        ; ( Enter )
        keyFunc_enter() {
            ; 向上另起一行
            SendInput('{Up}{End}{Enter}')
        }

        ; 逗号( , )
        keyFunc_comma() {
            funcLogic_doubleChar('<', '>')
        }

        ; 句号( 。 )
        keyFunc_dot() {

        }

        ; 斜杠( / )
        keyFunc_slash() {

        }

        ; 空格( Space )
        keyFunc_space() {

        }
    }

    ; =========   鼠标操作 ... 开始
    {
        ; 鼠标滚轮向前
        keyFunc_wheelUp() {
            funcLogic_volumeUp()
        }

        ; 鼠标滚轮向前
        keyFunc_wheelDown() {
            funcLogic_volumeDown()
        }

        ; 鼠标中键
        keyFunc_midButton() {

        }

        ; 鼠标左键
        keyFunc_leftButton() {

        }

        ; 鼠标右键
        keyFunc_rightButton() {

        }
    }
}

; ================= CapsLock + Alt + Key ... 开始 =================
{
    ; =========   A ~ Z ... 开始
    {
        keyFunc_alt_a() {
            ; 跳词⬅️删除
            SendInput('^{Backspace}')
        }
        keyFunc_alt_b() {
        }
        keyFunc_alt_c() {
        }
        keyFunc_alt_d() {
        }
        keyFunc_alt_e() {
        }
        keyFunc_alt_f() {
        }
        keyFunc_alt_g() {
        }
        keyFunc_alt_h() {
            ; ⬅️跳词选中
            SendInput('^+{Left}')

        }
        keyFunc_alt_i() {
            ; 向⬆️选择
            SendInput('+{Up}')
        }
        keyFunc_alt_j() {
            ; 向⬅️选择
            SendInput('+{Left}')

        }
        keyFunc_alt_k() {
            ; 向⬇️选择
            SendInput('+{Down}')

        }
        keyFunc_alt_l() {
            ; 向➡️选择
            SendInput('+{Right}')

        }
        keyFunc_alt_m() {
            ; 将选中的英文转为小写
            funcLogic_switchSelLowerCase()
        }
        keyFunc_alt_n() {
            ; 将选中的英文转为大写
            funcLogic_switchSelUpperCase()
        }
        keyFunc_alt_o() {
            ; 当前光标选至行末
            SendInput ('+{End}')
        }
        keyFunc_alt_p() {
        }
        keyFunc_alt_q() {
        }
        keyFunc_alt_r() {
        }
        keyFunc_alt_s() {
            ; 跳词➡️删除
            SendInput('^{Delete}')

        }
        keyFunc_alt_t() {
        }
        keyFunc_alt_u() {
            ; 当前光标选至行首
            SendInput('+{Home}')

        }
        keyFunc_alt_v() {
        }
        keyFunc_alt_w() {
            ; Alt + F4 关闭软件
            SendInput('!{F4}')
        }
        keyFunc_alt_x() {
        }
        keyFunc_alt_y() {
        }
        keyFunc_alt_z() {
        }
    }

    ; =========   F1 ~ F12 ... 开始
    {
        keyFunc_alt_f1() {

        }
        keyFunc_alt_f2() {

        }
        keyFunc_alt_f3() {

        }
        keyFunc_alt_f4() {

        }
        keyFunc_alt_f5() {

        }
        keyFunc_alt_f6() {

        }
        keyFunc_alt_f7() {

        }
        keyFunc_alt_f8() {

        }
        keyFunc_alt_f9() {

        }
        keyFunc_alt_f10() {

        }
        keyFunc_alt_f11() {

        }
        keyFunc_alt_f12() {

        }
    }

    ; =========   0 ~ 9 ... 开始
    {
        keyFunc_alt_0() {
        }
        keyFunc_alt_1() {
            BindingWindow.binding('1')
        }
        keyFunc_alt_2() {
            BindingWindow.binding('2')
        }
        keyFunc_alt_3() {
            BindingWindow.binding('3')
        }
        keyFunc_alt_4() {
            BindingWindow.binding('4')
        }
        keyFunc_alt_5() {
            BindingWindow.binding('5')
        }
        keyFunc_alt_6() {
            BindingWindow.binding('6')
        }
        keyFunc_alt_7() {
            BindingWindow.binding('7')
        }
        keyFunc_alt_8() {
            BindingWindow.binding('8')
        }
        keyFunc_alt_9() {
            ; 用中文圆括号包裹选中内容
            funcLogic_doubleChar('（', '）')

        }
    }

    ; =========   其他符号 ... 开始
    {
        ; 反引号( ` )
        keyFunc_alt_backquote() {
            BindingWindow.binding('``')
        }

        ; 减号( - )
        keyFunc_alt_minus() {

        }

        ; 等于号（ = ）
        keyFunc_alt_equal() {

        }

        ; ( Backspace )
        keyFunc_alt_backspace() {

        }

        ; ( Tab )
        keyFunc_alt_tab() {

        }

        ; 左方括号( [ )
        keyFunc_alt_leftSquareBracket() {

        }

        ; 右方括号( ] )
        keyFunc_alt_rightSquareBracket() {
            ; 用【】包裹选中内容
            funcLogic_doubleChar('【', '】')

        }

        ; 反斜杠( \ )
        keyFunc_alt_backslash() {

        }

        ; 分号( ; )
        keyFunc_alt_semicolon() {
            ; ➡️跳词选中
            SendInput('^+{Right}')

        }

        ; 双引号( "" )
        keyFunc_alt_quote() {

        }

        ; ( Enter )
        keyFunc_alt_enter() {
            ; 向下另起一行
            SendInput('{End}{Enter}')
        }

        ; 逗号( , )
        keyFunc_alt_comma() {
            funcLogic_doubleChar('《', '》')
        }

        ; 句号( 。 )
        keyFunc_alt_dot() {

        }

        ; 斜杠( / )
        keyFunc_alt_slash() {

        }

        ; 空格( Space )
        keyFunc_alt_space() {

        }
    }

    ; =========   鼠标操作 ... 开始
    {
        ; 鼠标滚轮向前
        keyFunc_alt_wheelUp() {

        }

        ; 鼠标滚轮向前
        keyFunc_alt_wheelDown() {

        }

        ; 鼠标中键
        keyFunc_alt_midButton() {

        }

        ; 鼠标左键
        keyFunc_alt_leftButton() {

        }

        ; 鼠标右键
        keyFunc_alt_rightButton() {

        }
    }
}

; ================= CapsLock + Shift + Key ... 开始 =================
{
    ; =========   A ~ Z ... 开始
    {
        keyFunc_shift_a() {
            ; 删除光标右边至行首
            SendInput('+{Home}{Backspace}')
        }
        keyFunc_shift_b() {
        }
        keyFunc_shift_c() {
        }
        keyFunc_shift_d() {
        }
        keyFunc_shift_e() {
            ; Ctrl + Win + Right 切换下一个虚拟窗口
            SendInput('^#{Right}')
        }
        keyFunc_shift_f() {
        }
        keyFunc_shift_g() {
        }
        keyFunc_shift_h() {
        }
        keyFunc_shift_i() {
            ; 向⬆️翻页
            SendInput('{PgUp}')
        }
        keyFunc_shift_j() {
            ; Ctal + Tab切换标签页
            SendInput('^{Tab}')
        }
        keyFunc_shift_k() {
            ; 向⬇️翻页
            SendInput('{PgDn}')

        }
        keyFunc_shift_l() {
            ; Ctal + Shift + Tab切换标签页
            SendInput('^+{Tab}')
        }
        keyFunc_shift_m() {
        }
        keyFunc_shift_n() {
        }
        keyFunc_shift_o() {
        }
        keyFunc_shift_p() {
        }
        keyFunc_shift_q() {
            ; Ctrl + Win + left 切换上一个虚拟窗口
            SendInput('^#{Left}')
        }
        keyFunc_shift_r() {
            ; Ctrl + Win + D 创建虚拟窗口
            SendInput('^#d')
        }
        keyFunc_shift_s() {
            ; 删除光标右边至行末
            SendInput('+{End}{Backspace}')
        }
        keyFunc_shift_t() {
        }
        keyFunc_shift_u() {
        }
        keyFunc_shift_v() {
        }
        keyFunc_shift_w() {
            ; Ctrl + Win + F4 关闭当前虚拟窗口
            SendInput('^#{F4}')
        }
        keyFunc_shift_x() {
        }
        keyFunc_shift_y() {
        }
        keyFunc_shift_z() {
        }
    }

    ; =========   F1 ~ F12 ... 开始
    {
        keyFunc_shift_f1() {

        }
        keyFunc_shift_f2() {

        }
        keyFunc_shift_f3() {

        }
        keyFunc_shift_f4() {

        }
        keyFunc_shift_f5() {

        }
        keyFunc_shift_f6() {

        }
        keyFunc_shift_f7() {

        }
        keyFunc_shift_f8() {

        }
        keyFunc_shift_f9() {

        }
        keyFunc_shift_f10() {

        }
        keyFunc_shift_f11() {

        }
        keyFunc_shift_f12() {

        }
    }

    ; =========   0 ~ 9 ... 开始
    {
        keyFunc_shift_0() {

        }
        keyFunc_shift_1() {

        }
        keyFunc_shift_2() {

        }
        keyFunc_shift_3() {

        }
        keyFunc_shift_4() {

        }
        keyFunc_shift_5() {

        }
        keyFunc_shift_6() {

        }
        keyFunc_shift_7() {

        }
        keyFunc_shift_8() {

        }
        keyFunc_shift_9() {

        }
    }

    ; =========   其他符号 ... 开始
    {
        ; 反引号( ` )
        keyFunc_shift_backquote() {

        }

        ; 减号( - )
        keyFunc_shift_minus() {

        }

        ; 等于号（ = ）
        keyFunc_shift_equal() {

        }

        ; ( Backspace )
        keyFunc_shift_backspace() {

        }

        ; ( Tab )
        keyFunc_shift_tab() {

        }

        ; 左方括号( [ )
        keyFunc_shift_leftSquareBracket() {

        }

        ; 右方括号( ] )
        keyFunc_shift_rightSquareBracket() {

        }

        ; 反斜杠( \ )
        keyFunc_shift_backslash() {

        }

        ; 分号( ; )
        keyFunc_shift_semicolon() {

        }

        ; 双引号( "" )
        keyFunc_shift_quote() {

        }

        ; ( Enter )
        keyFunc_shift_enter() {

        }

        ; 逗号( , )
        keyFunc_shift_comma() {

        }

        ; 句号( 。 )
        keyFunc_shift_dot() {

        }

        ; 斜杠( / )
        keyFunc_shift_slash() {

        }

        ; 空格( Space )
        keyFunc_shift_space() {

        }
    }

    ; =========   鼠标操作 ... 开始
    {
        ; 鼠标滚轮向前
        keyFunc_shift_wheelUp() {

        }

        ; 鼠标滚轮向前
        keyFunc_shift_wheelDown() {

        }

        ; 鼠标中键
        keyFunc_shift_midButton() {

        }

        ; 鼠标左键
        keyFunc_shift_leftButton() {

        }

        ; 鼠标右键
        keyFunc_shift_rightButton() {

        }
    }
}

; ================= CapsLock + Win + Key ... 开始 =================
{
    ; =========   A ~ Z ... 开始
    {
        keyFunc_win_a() {
        }
        keyFunc_win_b() {
        }
        keyFunc_win_c() {
        }
        keyFunc_win_d() {
        }
        keyFunc_win_e() {
        }
        keyFunc_win_f() {
        }
        keyFunc_win_g() {
        }
        keyFunc_win_h() {
        }
        keyFunc_win_i() {
        }
        keyFunc_win_j() {
        }
        keyFunc_win_k() {
        }
        keyFunc_win_l() {
        }
        keyFunc_win_m() {
        }
        keyFunc_win_n() {
        }
        keyFunc_win_o() {
        }
        keyFunc_win_p() {
        }
        keyFunc_win_q() {
        }
        keyFunc_win_r() {
        }
        keyFunc_win_s() {
        }
        keyFunc_win_t() {
        }
        keyFunc_win_u() {
        }
        keyFunc_win_v() {
        }
        keyFunc_win_w() {
        }
        keyFunc_win_x() {
        }
        keyFunc_win_y() {
        }
        keyFunc_win_z() {
        }
    }

    ; =========   F1 ~ F12 ... 开始
    {
        keyFunc_win_f1() {

        }
        keyFunc_win_f2() {

        }
        keyFunc_win_f3() {

        }
        keyFunc_win_f4() {

        }
        keyFunc_win_f5() {

        }
        keyFunc_win_f6() {

        }
        keyFunc_win_f7() {

        }
        keyFunc_win_f8() {

        }
        keyFunc_win_f9() {

        }
        keyFunc_win_f10() {

        }
        keyFunc_win_f11() {

        }
        keyFunc_win_f12() {

        }
    }

    ; =========   0 ~ 9 ... 开始
    {
        keyFunc_win_0() {

        }
        keyFunc_win_1() {

        }
        keyFunc_win_2() {

        }
        keyFunc_win_3() {

        }
        keyFunc_win_4() {

        }
        keyFunc_win_5() {

        }
        keyFunc_win_6() {

        }
        keyFunc_win_7() {

        }
        keyFunc_win_8() {

        }
        keyFunc_win_9() {

        }
    }

    ; =========   其他符号 ... 开始
    {
        ; 反引号( ` )
        keyFunc_win_backquote() {

        }

        ; 减号( - )
        keyFunc_win_minus() {

        }

        ; 等于号（ = ）
        keyFunc_win_equal() {

        }

        ; ( Backspace )
        keyFunc_win_backspace() {

        }

        ; ( Tab )
        keyFunc_win_tab() {

        }

        ; 左方括号( [ )
        keyFunc_win_leftSquareBracket() {

        }

        ; 右方括号( ] )
        keyFunc_win_rightSquareBracket() {

        }

        ; 反斜杠( \ )
        keyFunc_win_backslash() {

        }

        ; 分号( ; )
        keyFunc_win_semicolon() {

        }

        ; 双引号( "" )
        keyFunc_win_quote() {

        }

        ; ( Enter )
        keyFunc_win_enter() {

        }

        ; 逗号( , )
        keyFunc_win_comma() {

        }

        ; 句号( 。 )
        keyFunc_win_dot() {

        }

        ; 斜杠( / )
        keyFunc_win_slash() {

        }

        ; 空格( Space )
        keyFunc_win_space() {

        }
    }

    ; =========   鼠标操作 ... 开始
    {
        ; 鼠标滚轮向前
        keyFunc_win_wheelUp() {

        }

        ; 鼠标滚轮向前
        keyFunc_win_wheelDown() {

        }

        ; 鼠标中键
        keyFunc_win_midButton() {

        }

        ; 鼠标左键
        keyFunc_win_leftButton() {

        }

        ; 鼠标右键
        keyFunc_win_rightButton() {

        }
    }
}
