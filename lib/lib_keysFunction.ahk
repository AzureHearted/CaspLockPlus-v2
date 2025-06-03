#Requires AutoHotkey v2.0

#Include <lib_functions>
#Include <lib_keysFunLogic>
#Include <lib_bindingWindow>
#Include ../gui/ui_setting.ahk
#Include ../gui/ui_webview.ahk

; 每个按键初始的默认事件

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
            funcLogic_copy()
            ; 监听剪贴板，进行剪贴板显示
            OnClipboardChange(handle)
            handle(*) {
                ShowToolTips(A_Clipboard)
                OnClipboardChange(handle, 0)
            }
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
            ; 呼出Quicker搜索框，并填入选中内容(如果有)
            ; text := ''
            ; if (!WinActive('Quicker搜索')) {
            ;     ; 只有不在Quicker搜索框下才尝试获取选中文本
            ;     text := GetSelText(100)
            ; }
            ; Run("quicker:search:" text)
            id := WinExist('Quicker搜索')
            Run("quicker:search:")
            if (!id) {
                hwnd := WinWait('Quicker搜索')
                WinActivate('ahk_id' hwnd)
                OutputDebug('已聚焦')
            }
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
            funcLogic_paste()
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
            /** 打开窗口检查器 */
            Run(A_Temp '\CapsLockPlus v2\WindowSpy.exe')
        }
        keyFunc_f10() {
            /** WebView2浏览器 */
            global UISets, UserConfig
            UISets.webview.Show(UserConfig.URLDefault)
        }
        keyFunc_f11() {
            Reload()
        }
        keyFunc_f12() {
            /** 设置窗口 */
            global UISets
            UISets.setting.Show()
        }
    }

    ; =========   0 ~ 9 ... 开始
    {
        keyFunc_0() {

        }
        keyFunc_1() {
            BindingWindow.Active('1')
        }
        keyFunc_2() {
            BindingWindow.Active('2')
        }
        keyFunc_3() {
            BindingWindow.Active('3')
        }
        keyFunc_4() {
            BindingWindow.Active('4')
        }
        keyFunc_5() {
            BindingWindow.Active('5')
        }
        keyFunc_6() {
            BindingWindow.Active('6')
        }
        keyFunc_7() {
            BindingWindow.Active('7')
        }
        keyFunc_8() {
            BindingWindow.Active('8')
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
            BindingWindow.Active('``')
        }

        ; 减号( - )
        keyFunc_minus() {
            funcLogic_volumeDown()
        }

        ; 等于号（ = ）
        keyFunc_equal() {
            funcLogic_volumeUp()
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

        ; 单引号('')
        keyFunc_quote() {
            ; 用 "" 包裹选中内容
            funcLogic_doubleChar('"')
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
            ; 输入 Tab
            SendInput('{Tab}')
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
            ; 默认事件
            SendInput('{MButton}')
        }

        ; 鼠标左键
        keyFunc_leftButton() {
            ; 默认事件
            SendInput('{LButton}')
        }

        ; 鼠标右键
        keyFunc_rightButton() {
            ; 默认事件
            SendInput('{RButton}')
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
            ; 获取选中的文件路径
            paths := GetSelectedExplorerItemsPaths()
            if (!paths.Length) {
                ShowToolTips('没有选中文件(文件夹)')
                return
            }
            output := ''
            index := 1
            for (path in paths) {
                output := output path (index < paths.Length ? '`n' : '')
                index++
            }
            OutputDebug('选中的路径：`n' output)
            A_Clipboard := output
            ShowToolTips('已获取路径：`n' output)
        }
        keyFunc_alt_d() {
        }
        keyFunc_alt_e() {
        }
        keyFunc_alt_f() {
            ; todo 打开Everything搜索选中内容🔍
            ; 读取ini中记录的Everything路径
            pathEverythingExe := IniRead('setting.ini', 'Everything', 'path', "C:\Program Files\Everything\Everything.exe")
            ; 获取选中文本
            text := GetSelText()
            if (!FileExist(pathEverythingExe)) {
                ; 如果默认Everything路径不存在，则查看进程中是否有Everything进程
                if (!ProcessExist('Everything.exe')) {
                    ; 没有找到Everything进程则提示用户
                    ShowToolTips('请确保Everything在后台运行')
                    return
                }
                ; 找到Everything进程后更新Everything进程路径
                pathEverythingExe := ProcessGetPath('Everything.exe')
                ; 更新配置文件中记录的Everything路径
                IniWrite(pathEverythingExe, 'setting.ini', 'Everything', 'path')
            }
            ; 通过命令行调用Everything搜索
            Run(pathEverythingExe ' -s "' text '"')
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
            if (WinActive('ahk_exe EXCEL.EXE') || WinActive('ahk_exe wps.exe') || WinActive('ahk_class XLMAIN')) {
                ; Ctrl + Alt + V
                SendInput('^!v')
            }
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
            BindingWindow.Binding('1')
        }
        keyFunc_alt_2() {
            BindingWindow.Binding('2')
        }
        keyFunc_alt_3() {
            BindingWindow.Binding('3')
        }
        keyFunc_alt_4() {
            BindingWindow.Binding('4')
        }
        keyFunc_alt_5() {
            BindingWindow.Binding('5')
        }
        keyFunc_alt_6() {
            BindingWindow.Binding('6')
        }
        keyFunc_alt_7() {
            BindingWindow.Binding('7')
        }
        keyFunc_alt_8() {
            BindingWindow.Binding('8')
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
            BindingWindow.Binding('``')
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

        ; 单引号('')
        keyFunc_alt_quote() {
            ; 用 “” 包裹选中内容
            funcLogic_doubleChar('“', '”')
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
            ; 默认事件
            SendInput('{MButton}')
        }

        ; 鼠标左键
        keyFunc_alt_leftButton() {
            ; 默认事件
            SendInput('{LButton}')
        }

        ; 鼠标右键
        keyFunc_alt_rightButton() {
            ; 默认事件
            SendInput('{RButton}')
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
            ; Ctrl + Tab切换标签页
            SendInput('^{Tab}')
        }
        keyFunc_shift_k() {
            ; 向⬇️翻页
            SendInput('{PgDn}')

        }
        keyFunc_shift_l() {
            ; Ctrl + Shift + Tab切换标签页
            SendInput('^+{Tab}')
        }
        keyFunc_shift_m() {
        }
        keyFunc_shift_n() {
        }
        keyFunc_shift_o() {
            ; 定位到文档结尾
            SendInput('^{End}')
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
            ; 定位到文档开头
            SendInput('^{Home}')
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

        ; 单引号('')
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
            ; 默认事件
            SendInput('{MButton}')
        }

        ; 鼠标左键
        keyFunc_shift_leftButton() {
            ; 默认事件
            SendInput('{LButton}')
        }

        ; 鼠标右键
        keyFunc_shift_rightButton() {
            ; 默认事件
            SendInput('{RButton}')
        }
    }
}

; ================= CapsLock + Ctrl + Key ... 开始 =================
{
    ; =========   A ~ Z ... 开始
    {
        keyFunc_ctrl_a() {
        }
        keyFunc_ctrl_b() {
        }
        keyFunc_ctrl_c() {
        }
        keyFunc_ctrl_d() {
        }
        keyFunc_ctrl_e() {
        }
        keyFunc_ctrl_f() {
        }
        keyFunc_ctrl_g() {
        }
        keyFunc_ctrl_h() {
        }
        keyFunc_ctrl_i() {
        }
        keyFunc_ctrl_j() {
        }
        keyFunc_ctrl_k() {
        }
        keyFunc_ctrl_l() {
        }
        keyFunc_ctrl_m() {
        }
        keyFunc_ctrl_n() {
        }
        keyFunc_ctrl_o() {
        }
        keyFunc_ctrl_p() {
        }
        keyFunc_ctrl_q() {
        }
        keyFunc_ctrl_r() {
        }
        keyFunc_ctrl_s() {
        }
        keyFunc_ctrl_t() {
        }
        keyFunc_ctrl_u() {
        }
        keyFunc_ctrl_v() {
        }
        keyFunc_ctrl_w() {
        }
        keyFunc_ctrl_x() {
        }
        keyFunc_ctrl_y() {
        }
        keyFunc_ctrl_z() {
        }
    }

    ; =========   F1 ~ F12 ... 开始
    {
        keyFunc_ctrl_f1() {
        }
        keyFunc_ctrl_f2() {
        }
        keyFunc_ctrl_f3() {
        }
        keyFunc_ctrl_f4() {
        }
        keyFunc_ctrl_f5() {
        }
        keyFunc_ctrl_f6() {
        }
        keyFunc_ctrl_f7() {
        }
        keyFunc_ctrl_f8() {
        }
        keyFunc_ctrl_f9() {
        }
        keyFunc_ctrl_f10() {
        }
        keyFunc_ctrl_f11() {
        }
        keyFunc_ctrl_f12() {
        }
    }

    ; =========   0 ~ 9 ... 开始
    {
        keyFunc_ctrl_0() {
        }
        keyFunc_ctrl_1() {
        }
        keyFunc_ctrl_2() {
        }
        keyFunc_ctrl_3() {
        }
        keyFunc_ctrl_4() {
        }
        keyFunc_ctrl_5() {
        }
        keyFunc_ctrl_6() {
        }
        keyFunc_ctrl_7() {
        }
        keyFunc_ctrl_8() {
        }
        keyFunc_ctrl_9() {
        }
    }

    ; =========   其他符号 ... 开始
    {
        ; 反引号( ` )
        keyFunc_ctrl_backquote() {
        }

        ; 减号( - )
        keyFunc_ctrl_minus() {
        }

        ; 等于号（ = ）
        keyFunc_ctrl_equal() {
        }

        ; ( Backspace )
        keyFunc_ctrl_backspace() {
        }

        ; ( Tab )
        keyFunc_ctrl_tab() {
        }

        ; 左方括号( [ )
        keyFunc_ctrl_leftSquareBracket() {
        }

        ; 右方括号( ] )
        keyFunc_ctrl_rightSquareBracket() {
        }

        ; 反斜杠( \ )
        keyFunc_ctrl_backslash() {
        }

        ; 分号( ; )
        keyFunc_ctrl_semicolon() {
        }

        ; 单引号('')
        keyFunc_ctrl_quote() {
        }

        ; ( Enter )
        keyFunc_ctrl_enter() {
        }

        ; 逗号( , )
        keyFunc_ctrl_comma() {
        }

        ; 句号( 。 )
        keyFunc_ctrl_dot() {
        }

        ; 斜杠( / )
        keyFunc_ctrl_slash() {
        }

        ; 空格( Space )
        keyFunc_ctrl_space() {
        }
    }

    ; =========   鼠标操作 ... 开始
    {
        ; 鼠标滚轮向前
        keyFunc_ctrl_wheelUp() {
        }

        ; 鼠标滚轮向前
        keyFunc_ctrl_wheelDown() {
        }

        ; 鼠标中键
        keyFunc_ctrl_midButton() {
        }

        ; 鼠标左键
        keyFunc_ctrl_leftButton() {
        }

        ; 鼠标右键
        keyFunc_ctrl_rightButton() {
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

        ; 单引号('')
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