#Requires AutoHotkey v2.0

; 按键映射
keysMap := Map()

; ================= CapsLock + Key ... 开始 =================
{
    ; =========   A ~ Z ... 开始
    {
        keysMap['caps_a'] := 'keyFunc_a'
        keysMap['caps_b'] := 'keyFunc_b'
        keysMap['caps_c'] := 'keyFunc_c'
        keysMap['caps_d'] := 'keyFunc_d'
        keysMap['caps_e'] := 'keyFunc_e'
        keysMap['caps_f'] := 'keyFunc_f'
        keysMap['caps_g'] := 'keyFunc_g'
        keysMap['caps_h'] := 'keyFunc_h'
        keysMap['caps_i'] := 'keyFunc_i'
        keysMap['caps_j'] := 'keyFunc_j'
        keysMap['caps_k'] := 'keyFunc_k'
        keysMap['caps_l'] := 'keyFunc_l'
        keysMap['caps_m'] := 'keyFunc_m'
        keysMap['caps_n'] := 'keyFunc_n'
        keysMap['caps_o'] := 'keyFunc_o'
        keysMap['caps_p'] := 'keyFunc_p'
        keysMap['caps_q'] := 'keyFunc_q'
        keysMap['caps_r'] := 'keyFunc_r'
        keysMap['caps_s'] := 'keyFunc_s'
        keysMap['caps_t'] := 'keyFunc_t'
        keysMap['caps_u'] := 'keyFunc_u'
        keysMap['caps_v'] := 'keyFunc_v'
        keysMap['caps_w'] := 'keyFunc_w'
        keysMap['caps_x'] := 'keyFunc_x'
        keysMap['caps_y'] := 'keyFunc_y'
        keysMap['caps_z'] := 'keyFunc_z'
    }

    ; =========   F1 ~ F12 ... 开始
    {
        keysMap['caps_f1'] := 'keyFunc_f1'
        keysMap['caps_f2'] := 'keyFunc_f2'
        keysMap['caps_f3'] := 'keyFunc_f3'
        keysMap['caps_f4'] := 'keyFunc_f4'
        keysMap['caps_f5'] := 'keyFunc_f5'
        keysMap['caps_f6'] := 'keyFunc_f6'
        keysMap['caps_f7'] := 'keyFunc_f7'
        keysMap['caps_f8'] := 'keyFunc_f8'
        keysMap['caps_f9'] := 'keyFunc_f9'
        keysMap['caps_f10'] := 'keyFunc_f10'
        keysMap['caps_f11'] := 'keyFunc_f11'
        keysMap['caps_f12'] := 'keyFunc_f12'
    }

    ; =========   0 ~ 9 ... 开始
    {
        keysMap['caps_0'] := 'keyFunc_0'
        keysMap['caps_1'] := 'keyFunc_1'
        keysMap['caps_2'] := 'keyFunc_2'
        keysMap['caps_3'] := 'keyFunc_3'
        keysMap['caps_4'] := 'keyFunc_4'
        keysMap['caps_5'] := 'keyFunc_5'
        keysMap['caps_6'] := 'keyFunc_6'
        keysMap['caps_7'] := 'keyFunc_7'
        keysMap['caps_8'] := 'keyFunc_8'
        keysMap['caps_9'] := 'keyFunc_9'
    }

    ; =========   其他符号 ... 开始
    {
        ; 反引号( ` )
        keysMap['caps_backquote'] := "keyFunc_backquote"

        ; 减号( - )
        keysMap['caps_minus'] := "keyFunc_minus"

        ; 等于号（ = ）
        keysMap['caps_equal'] := "keyFunc_equal"

        ; ( Backspace )
        keysMap['caps_backspace'] := "keyFunc_backspace"

        ; ( Tab )
        keysMap['caps_tab'] := "keyFunc_tab"

        ; 左方括号( [ )
        keysMap['caps_leftSquareBracket'] := "keyFunc_leftSquareBracket"

        ; 右方括号( ] )
        keysMap['caps_rightSquareBracket'] := "keyFunc_rightSquareBracket"

        ; 反斜杠( \ )
        keysMap['caps_backslash'] := "keyFunc_backslash"

        ; 分号( ; )
        keysMap['caps_semicolon'] := "keyFunc_semicolon"

        ; 单引号('')
        keysMap['caps_quote'] := "keyFunc_quote"

        ; ( Enter )
        keysMap['caps_enter'] := "keyFunc_enter"

        ; 逗号( , )
        keysMap['caps_comma'] := "keyFunc_comma"

        ; 句号( 。 )
        keysMap['caps_dot'] := "keyFunc_dot"

        ; 斜杠( / )
        keysMap['caps_slash'] := "keyFunc_slash"

        ; 空格( Space )
        keysMap['caps_space'] := "keyFunc_space"
    }

    ; =========   鼠标操作 ... 开始
    {
        ; 鼠标滚轮向前
        keysMap['caps_wheelUp'] := "keyFunc_wheelUp"

        ; 鼠标滚轮向前
        keysMap['caps_wheelDown'] := "keyFunc_wheelDown"

        ; 鼠标中键
        keysMap['caps_midButton'] := "keyFunc_midButton"

        ; 鼠标左键
        keysMap['caps_leftButton'] := "keyFunc_leftButton"

        ; 鼠标右键
        keysMap['caps_rightButton'] := "keyFunc_rightButton"
    }
}

; ================= CapsLock + Alt + Key ... 结束 =================
{
    ; =========   A ~ Z ... 开始
    {
        keysMap['caps_alt_a'] := 'keyFunc_alt_a'
        keysMap['caps_alt_b'] := 'keyFunc_alt_b'
        keysMap['caps_alt_c'] := 'keyFunc_alt_c'
        keysMap['caps_alt_d'] := 'keyFunc_alt_d'
        keysMap['caps_alt_e'] := 'keyFunc_alt_e'
        keysMap['caps_alt_f'] := 'keyFunc_alt_f'
        keysMap['caps_alt_g'] := 'keyFunc_alt_g'
        keysMap['caps_alt_h'] := 'keyFunc_alt_h'
        keysMap['caps_alt_i'] := 'keyFunc_alt_i'
        keysMap['caps_alt_j'] := 'keyFunc_alt_j'
        keysMap['caps_alt_k'] := 'keyFunc_alt_k'
        keysMap['caps_alt_l'] := 'keyFunc_alt_l'
        keysMap['caps_alt_m'] := 'keyFunc_alt_m'
        keysMap['caps_alt_n'] := 'keyFunc_alt_n'
        keysMap['caps_alt_o'] := 'keyFunc_alt_o'
        keysMap['caps_alt_p'] := 'keyFunc_alt_p'
        keysMap['caps_alt_q'] := 'keyFunc_alt_q'
        keysMap['caps_alt_r'] := 'keyFunc_alt_r'
        keysMap['caps_alt_s'] := 'keyFunc_alt_s'
        keysMap['caps_alt_t'] := 'keyFunc_alt_t'
        keysMap['caps_alt_u'] := 'keyFunc_alt_u'
        keysMap['caps_alt_v'] := 'keyFunc_alt_v'
        keysMap['caps_alt_w'] := 'keyFunc_alt_w'
        keysMap['caps_alt_x'] := 'keyFunc_alt_x'
        keysMap['caps_alt_y'] := 'keyFunc_alt_y'
        keysMap['caps_alt_z'] := 'keyFunc_alt_z'
    }

    ; =========   F1 ~ F12 ... 开始
    {
        keysMap['caps_alt_f1'] := 'keyFunc_alt_f1'
        keysMap['caps_alt_f2'] := 'keyFunc_alt_f2'
        keysMap['caps_alt_f3'] := 'keyFunc_alt_f3'
        keysMap['caps_alt_f4'] := 'keyFunc_alt_f4'
        keysMap['caps_alt_f5'] := 'keyFunc_alt_f5'
        keysMap['caps_alt_f6'] := 'keyFunc_alt_f6'
        keysMap['caps_alt_f7'] := 'keyFunc_alt_f7'
        keysMap['caps_alt_f8'] := 'keyFunc_alt_f8'
        keysMap['caps_alt_f9'] := 'keyFunc_alt_f9'
        keysMap['caps_alt_f10'] := 'keyFunc_alt_f10'
        keysMap['caps_alt_f11'] := 'keyFunc_alt_f11'
        keysMap['caps_alt_f12'] := 'keyFunc_alt_f12'
    }

    ; =========   0 ~ 9 ... 开始
    {
        keysMap['caps_alt_0'] := 'keyFunc_alt_0'
        keysMap['caps_alt_1'] := 'keyFunc_alt_1'
        keysMap['caps_alt_2'] := 'keyFunc_alt_2'
        keysMap['caps_alt_3'] := 'keyFunc_alt_3'
        keysMap['caps_alt_4'] := 'keyFunc_alt_4'
        keysMap['caps_alt_5'] := 'keyFunc_alt_5'
        keysMap['caps_alt_6'] := 'keyFunc_alt_6'
        keysMap['caps_alt_7'] := 'keyFunc_alt_7'
        keysMap['caps_alt_8'] := 'keyFunc_alt_8'
        keysMap['caps_alt_9'] := 'keyFunc_alt_9'
    }

    ; =========   其他符号 ... 开始
    {
        ; 反引号( ` )
        keysMap['caps_alt_backquote'] := "keyFunc_alt_backquote"

        ; 减号( - )
        keysMap['caps_alt_minus'] := "keyFunc_alt_minus"

        ; 等于号（ = ）
        keysMap['caps_alt_equal'] := "keyFunc_alt_equal"

        ; ( Backspace )
        keysMap['caps_alt_backspace'] := "keyFunc_alt_backspace"

        ; ( Tab )
        keysMap['caps_alt_tab'] := "keyFunc_alt_tab"

        ; 左方括号( [ )
        keysMap['caps_alt_leftSquareBracket'] := "keyFunc_alt_leftSquareBracket"

        ; 右方括号( ] )
        keysMap['caps_alt_rightSquareBracket'] := "keyFunc_alt_rightSquareBracket"

        ; 反斜杠( \ )
        keysMap['caps_alt_backslash'] := "keyFunc_alt_backslash"

        ; 分号( ; )
        keysMap['caps_alt_semicolon'] := "keyFunc_alt_semicolon"

        ; 单引号('')
        keysMap['caps_alt_quote'] := "keyFunc_alt_quote"

        ; ( Enter )
        keysMap['caps_alt_enter'] := "keyFunc_alt_enter"

        ; 逗号( , )
        keysMap['caps_alt_comma'] := "keyFunc_alt_comma"

        ; 句号( 。 )
        keysMap['caps_alt_dot'] := "keyFunc_alt_dot"

        ; 斜杠( / )
        keysMap['caps_alt_slash'] := "keyFunc_alt_slash"

        ; 空格( Space )
        keysMap['caps_alt_space'] := "keyFunc_alt_space"
    }

    ; =========   鼠标操作 ... 开始
    {
        ; 鼠标滚轮向前
        keysMap['caps_alt_wheelUp'] := "keyFunc_alt_wheelUp"

        ; 鼠标滚轮向前
        keysMap['caps_alt_wheelDown'] := "keyFunc_alt_wheelDown"

        ; 鼠标中键
        keysMap['caps_alt_midButton'] := "keyFunc_alt_midButton"

        ; 鼠标左键
        keysMap['caps_alt_leftButton'] := "keyFunc_alt_leftButton"

        ; 鼠标右键
        keysMap['caps_alt_rightButton'] := "keyFunc_alt_rightButton"
    }
}

; ================= CapsLock + Shift + Key ... 开始 =================
{
    ; =========   A ~ Z ... 开始
    {
        keysMap['caps_shift_a'] := 'keyFunc_shift_a'
        keysMap['caps_shift_b'] := 'keyFunc_shift_b'
        keysMap['caps_shift_c'] := 'keyFunc_shift_c'
        keysMap['caps_shift_d'] := 'keyFunc_shift_d'
        keysMap['caps_shift_e'] := 'keyFunc_shift_e'
        keysMap['caps_shift_f'] := 'keyFunc_shift_f'
        keysMap['caps_shift_g'] := 'keyFunc_shift_g'
        keysMap['caps_shift_h'] := 'keyFunc_shift_h'
        keysMap['caps_shift_i'] := 'keyFunc_shift_i'
        keysMap['caps_shift_j'] := 'keyFunc_shift_j'
        keysMap['caps_shift_k'] := 'keyFunc_shift_k'
        keysMap['caps_shift_l'] := 'keyFunc_shift_l'
        keysMap['caps_shift_m'] := 'keyFunc_shift_m'
        keysMap['caps_shift_n'] := 'keyFunc_shift_n'
        keysMap['caps_shift_o'] := 'keyFunc_shift_o'
        keysMap['caps_shift_p'] := 'keyFunc_shift_p'
        keysMap['caps_shift_q'] := 'keyFunc_shift_q'
        keysMap['caps_shift_r'] := 'keyFunc_shift_r'
        keysMap['caps_shift_s'] := 'keyFunc_shift_s'
        keysMap['caps_shift_t'] := 'keyFunc_shift_t'
        keysMap['caps_shift_u'] := 'keyFunc_shift_u'
        keysMap['caps_shift_v'] := 'keyFunc_shift_v'
        keysMap['caps_shift_w'] := 'keyFunc_shift_w'
        keysMap['caps_shift_x'] := 'keyFunc_shift_x'
        keysMap['caps_shift_y'] := 'keyFunc_shift_y'
        keysMap['caps_shift_z'] := 'keyFunc_shift_z'
    }

    ; =========   F1 ~ F12 ... 开始
    {
        keysMap['caps_shift_f1'] := 'keyFunc_shift_f1'
        keysMap['caps_shift_f2'] := 'keyFunc_shift_f2'
        keysMap['caps_shift_f3'] := 'keyFunc_shift_f3'
        keysMap['caps_shift_f4'] := 'keyFunc_shift_f4'
        keysMap['caps_shift_f5'] := 'keyFunc_shift_f5'
        keysMap['caps_shift_f6'] := 'keyFunc_shift_f6'
        keysMap['caps_shift_f7'] := 'keyFunc_shift_f7'
        keysMap['caps_shift_f8'] := 'keyFunc_shift_f8'
        keysMap['caps_shift_f9'] := 'keyFunc_shift_f9'
        keysMap['caps_shift_f10'] := 'keyFunc_shift_f10'
        keysMap['caps_shift_f11'] := 'keyFunc_shift_f11'
        keysMap['caps_shift_f12'] := 'keyFunc_shift_f12'
    }

    ; =========   0 ~ 9 ... 开始
    {
        keysMap['caps_shift_0'] := 'keyFunc_shift_0'
        keysMap['caps_shift_1'] := 'keyFunc_shift_1'
        keysMap['caps_shift_2'] := 'keyFunc_shift_2'
        keysMap['caps_shift_3'] := 'keyFunc_shift_3'
        keysMap['caps_shift_4'] := 'keyFunc_shift_4'
        keysMap['caps_shift_5'] := 'keyFunc_shift_5'
        keysMap['caps_shift_6'] := 'keyFunc_shift_6'
        keysMap['caps_shift_7'] := 'keyFunc_shift_7'
        keysMap['caps_shift_8'] := 'keyFunc_shift_8'
        keysMap['caps_shift_9'] := 'keyFunc_shift_9'
    }

    ; =========   其他符号 ... 开始
    {
        ; 反引号( ` )
        keysMap['caps_shift_backquote'] := "keyFunc_shift_backquote"

        ; 减号( - )
        keysMap['caps_shift_minus'] := "keyFunc_shift_minus"

        ; 等于号（ = ）
        keysMap['caps_shift_equal'] := "keyFunc_shift_equal"

        ; ( Backspace )
        keysMap['caps_shift_backspace'] := "keyFunc_shift_backspace"

        ; ( Tab )
        keysMap['caps_shift_tab'] := "keyFunc_shift_tab"

        ; 左方括号( [ )
        keysMap['caps_shift_leftSquareBracket'] := "keyFunc_shift_leftSquareBracket"

        ; 右方括号( ] )
        keysMap['caps_shift_rightSquareBracket'] := "keyFunc_shift_rightSquareBracket"

        ; 反斜杠( \ )
        keysMap['caps_shift_backslash'] := "keyFunc_shift_backslash"

        ; 分号( ; )
        keysMap['caps_shift_semicolon'] := "keyFunc_shift_semicolon"

        ; 单引号('')
        keysMap['caps_shift_quote'] := "keyFunc_shift_quote"

        ; ( Enter )
        keysMap['caps_shift_enter'] := "keyFunc_shift_enter"

        ; 逗号( , )
        keysMap['caps_shift_comma'] := "keyFunc_shift_comma"

        ; 句号( 。 )
        keysMap['caps_shift_dot'] := "keyFunc_shift_dot"

        ; 斜杠( / )
        keysMap['caps_shift_slash'] := "keyFunc_shift_slash"

        ; 空格( Space )
        keysMap['caps_shift_space'] := "keyFunc_shift_space"
    }

    ; =========   鼠标操作 ... 开始
    {
        ; 鼠标滚轮向前
        keysMap['caps_shift_wheelUp'] := "keyFunc_shift_wheelUp"

        ; 鼠标滚轮向前
        keysMap['caps_shift_wheelDown'] := "keyFunc_shift_wheelDown"

        ; 鼠标中键
        keysMap['caps_shift_midButton'] := "keyFunc_shift_midButton"

        ; 鼠标左键
        keysMap['caps_shift_leftButton'] := "keyFunc_shift_leftButton"

        ; 鼠标右键
        keysMap['caps_shift_rightButton'] := "keyFunc_shift_rightButton"
    }
}

; ================= CapsLock + Ctrl + Key ... 开始 =================
{
  ; =========   A ~ Z ... 开始
  {
      keysMap['caps_ctrl_a'] := 'keyFunc_ctrl_a'
      keysMap['caps_ctrl_b'] := 'keyFunc_ctrl_b'
      keysMap['caps_ctrl_c'] := 'keyFunc_ctrl_c'
      keysMap['caps_ctrl_d'] := 'keyFunc_ctrl_d'
      keysMap['caps_ctrl_e'] := 'keyFunc_ctrl_e'
      keysMap['caps_ctrl_f'] := 'keyFunc_ctrl_f'
      keysMap['caps_ctrl_g'] := 'keyFunc_ctrl_g'
      keysMap['caps_ctrl_h'] := 'keyFunc_ctrl_h'
      keysMap['caps_ctrl_i'] := 'keyFunc_ctrl_i'
      keysMap['caps_ctrl_j'] := 'keyFunc_ctrl_j'
      keysMap['caps_ctrl_k'] := 'keyFunc_ctrl_k'
      keysMap['caps_ctrl_l'] := 'keyFunc_ctrl_l'
      keysMap['caps_ctrl_m'] := 'keyFunc_ctrl_m'
      keysMap['caps_ctrl_n'] := 'keyFunc_ctrl_n'
      keysMap['caps_ctrl_o'] := 'keyFunc_ctrl_o'
      keysMap['caps_ctrl_p'] := 'keyFunc_ctrl_p'
      keysMap['caps_ctrl_q'] := 'keyFunc_ctrl_q'
      keysMap['caps_ctrl_r'] := 'keyFunc_ctrl_r'
      keysMap['caps_ctrl_s'] := 'keyFunc_ctrl_s'
      keysMap['caps_ctrl_t'] := 'keyFunc_ctrl_t'
      keysMap['caps_ctrl_u'] := 'keyFunc_ctrl_u'
      keysMap['caps_ctrl_v'] := 'keyFunc_ctrl_v'
      keysMap['caps_ctrl_w'] := 'keyFunc_ctrl_w'
      keysMap['caps_ctrl_x'] := 'keyFunc_ctrl_x'
      keysMap['caps_ctrl_y'] := 'keyFunc_ctrl_y'
      keysMap['caps_ctrl_z'] := 'keyFunc_ctrl_z'
  }

  ; =========   F1 ~ F12 ... 开始
  {
      keysMap['caps_ctrl_f1'] := 'keyFunc_ctrl_f1'
      keysMap['caps_ctrl_f2'] := 'keyFunc_ctrl_f2'
      keysMap['caps_ctrl_f3'] := 'keyFunc_ctrl_f3'
      keysMap['caps_ctrl_f4'] := 'keyFunc_ctrl_f4'
      keysMap['caps_ctrl_f5'] := 'keyFunc_ctrl_f5'
      keysMap['caps_ctrl_f6'] := 'keyFunc_ctrl_f6'
      keysMap['caps_ctrl_f7'] := 'keyFunc_ctrl_f7'
      keysMap['caps_ctrl_f8'] := 'keyFunc_ctrl_f8'
      keysMap['caps_ctrl_f9'] := 'keyFunc_ctrl_f9'
      keysMap['caps_ctrl_f10'] := 'keyFunc_ctrl_f10'
      keysMap['caps_ctrl_f11'] := 'keyFunc_ctrl_f11'
      keysMap['caps_ctrl_f12'] := 'keyFunc_ctrl_f12'
  }

  ; =========   0 ~ 9 ... 开始
  {
      keysMap['caps_ctrl_0'] := 'keyFunc_ctrl_0'
      keysMap['caps_ctrl_1'] := 'keyFunc_ctrl_1'
      keysMap['caps_ctrl_2'] := 'keyFunc_ctrl_2'
      keysMap['caps_ctrl_3'] := 'keyFunc_ctrl_3'
      keysMap['caps_ctrl_4'] := 'keyFunc_ctrl_4'
      keysMap['caps_ctrl_5'] := 'keyFunc_ctrl_5'
      keysMap['caps_ctrl_6'] := 'keyFunc_ctrl_6'
      keysMap['caps_ctrl_7'] := 'keyFunc_ctrl_7'
      keysMap['caps_ctrl_8'] := 'keyFunc_ctrl_8'
      keysMap['caps_ctrl_9'] := 'keyFunc_ctrl_9'
  }

  ; =========   其他符号 ... 开始
  {
      ; 反引号( ` )
      keysMap['caps_ctrl_backquote'] := "keyFunc_ctrl_backquote"

      ; 减号( - )
      keysMap['caps_ctrl_minus'] := "keyFunc_ctrl_minus"

      ; 等于号（ = ）
      keysMap['caps_ctrl_equal'] := "keyFunc_ctrl_equal"

      ; ( Backspace )
      keysMap['caps_ctrl_backspace'] := "keyFunc_ctrl_backspace"

      ; ( Tab )
      keysMap['caps_ctrl_tab'] := "keyFunc_ctrl_tab"

      ; 左方括号( [ )
      keysMap['caps_ctrl_leftSquareBracket'] := "keyFunc_ctrl_leftSquareBracket"

      ; 右方括号( ] )
      keysMap['caps_ctrl_rightSquareBracket'] := "keyFunc_ctrl_rightSquareBracket"

      ; 反斜杠( \ )
      keysMap['caps_ctrl_backslash'] := "keyFunc_ctrl_backslash"

      ; 分号( ; )
      keysMap['caps_ctrl_semicolon'] := "keyFunc_ctrl_semicolon"

      ; 单引号('')
      keysMap['caps_ctrl_quote'] := "keyFunc_ctrl_quote"

      ; ( Enter )
      keysMap['caps_ctrl_enter'] := "keyFunc_ctrl_enter"

      ; 逗号( , )
      keysMap['caps_ctrl_comma'] := "keyFunc_ctrl_comma"

      ; 句号( 。 )
      keysMap['caps_ctrl_dot'] := "keyFunc_ctrl_dot"

      ; 斜杠( / )
      keysMap['caps_ctrl_slash'] := "keyFunc_ctrl_slash"

      ; 空格( Space )
      keysMap['caps_ctrl_space'] := "keyFunc_ctrl_space"
  }

  ; =========   鼠标操作 ... 开始
  {
      ; 鼠标滚轮向前
      keysMap['caps_ctrl_wheelUp'] := "keyFunc_ctrl_wheelUp"

      ; 鼠标滚轮向前
      keysMap['caps_ctrl_wheelDown'] := "keyFunc_ctrl_wheelDown"

      ; 鼠标中键
      keysMap['caps_ctrl_midButton'] := "keyFunc_ctrl_midButton"

      ; 鼠标左键
      keysMap['caps_ctrl_leftButton'] := "keyFunc_ctrl_leftButton"

      ; 鼠标右键
      keysMap['caps_ctrl_rightButton'] := "keyFunc_ctrl_rightButton"
  }
}

; ================= CapsLock + Win + Key ... 开始 =================
{
    ; =========   A ~ Z ... 开始
    {
        keysMap['caps_win_a'] := 'keyFunc_win_a'
        keysMap['caps_win_b'] := 'keyFunc_win_b'
        keysMap['caps_win_c'] := 'keyFunc_win_c'
        keysMap['caps_win_d'] := 'keyFunc_win_d'
        keysMap['caps_win_e'] := 'keyFunc_win_e'
        keysMap['caps_win_f'] := 'keyFunc_win_f'
        keysMap['caps_win_g'] := 'keyFunc_win_g'
        keysMap['caps_win_h'] := 'keyFunc_win_h'
        keysMap['caps_win_i'] := 'keyFunc_win_i'
        keysMap['caps_win_j'] := 'keyFunc_win_j'
        keysMap['caps_win_k'] := 'keyFunc_win_k'
        keysMap['caps_win_l'] := 'keyFunc_win_l'
        keysMap['caps_win_m'] := 'keyFunc_win_m'
        keysMap['caps_win_n'] := 'keyFunc_win_n'
        keysMap['caps_win_o'] := 'keyFunc_win_o'
        keysMap['caps_win_p'] := 'keyFunc_win_p'
        keysMap['caps_win_q'] := 'keyFunc_win_q'
        keysMap['caps_win_r'] := 'keyFunc_win_r'
        keysMap['caps_win_s'] := 'keyFunc_win_s'
        keysMap['caps_win_t'] := 'keyFunc_win_t'
        keysMap['caps_win_u'] := 'keyFunc_win_u'
        keysMap['caps_win_v'] := 'keyFunc_win_v'
        keysMap['caps_win_w'] := 'keyFunc_win_w'
        keysMap['caps_win_x'] := 'keyFunc_win_x'
        keysMap['caps_win_y'] := 'keyFunc_win_y'
        keysMap['caps_win_z'] := 'keyFunc_win_z'
    }

    ; =========   F1 ~ F12 ... 开始
    {
        keysMap['caps_win_f1'] := 'keyFunc_win_f1'
        keysMap['caps_win_f2'] := 'keyFunc_win_f2'
        keysMap['caps_win_f3'] := 'keyFunc_win_f3'
        keysMap['caps_win_f4'] := 'keyFunc_win_f4'
        keysMap['caps_win_f5'] := 'keyFunc_win_f5'
        keysMap['caps_win_f6'] := 'keyFunc_win_f6'
        keysMap['caps_win_f7'] := 'keyFunc_win_f7'
        keysMap['caps_win_f8'] := 'keyFunc_win_f8'
        keysMap['caps_win_f9'] := 'keyFunc_win_f9'
        keysMap['caps_win_f10'] := 'keyFunc_win_f10'
        keysMap['caps_win_f11'] := 'keyFunc_win_f11'
        keysMap['caps_win_f12'] := 'keyFunc_win_f12'
    }

    ; =========   0 ~ 9 ... 开始
    {
        keysMap['caps_win_0'] := 'keyFunc_win_0'
        keysMap['caps_win_1'] := 'keyFunc_win_1'
        keysMap['caps_win_2'] := 'keyFunc_win_2'
        keysMap['caps_win_3'] := 'keyFunc_win_3'
        keysMap['caps_win_4'] := 'keyFunc_win_4'
        keysMap['caps_win_5'] := 'keyFunc_win_5'
        keysMap['caps_win_6'] := 'keyFunc_win_6'
        keysMap['caps_win_7'] := 'keyFunc_win_7'
        keysMap['caps_win_8'] := 'keyFunc_win_8'
        keysMap['caps_win_9'] := 'keyFunc_win_9'
    }

    ; =========   其他符号 ... 开始
    {
        ; 反引号( ` )
        keysMap['caps_win_backquote'] := "keyFunc_win_backquote"

        ; 减号( - )
        keysMap['caps_win_minus'] := "keyFunc_win_minus"

        ; 等于号（ = ）
        keysMap['caps_win_equal'] := "keyFunc_win_equal"

        ; ( Backspace )
        keysMap['caps_win_backspace'] := "keyFunc_win_backspace"

        ; ( Tab )
        keysMap['caps_win_tab'] := "keyFunc_win_tab"

        ; 左方括号( [ )
        keysMap['caps_win_leftSquareBracket'] := "keyFunc_win_leftSquareBracket"

        ; 右方括号( ] )
        keysMap['caps_win_rightSquareBracket'] := "keyFunc_win_rightSquareBracket"

        ; 反斜杠( \ )
        keysMap['caps_win_backslash'] := "keyFunc_win_backslash"

        ; 分号( ; )
        keysMap['caps_win_semicolon'] := "keyFunc_win_semicolon"

        ; 单引号('')
        keysMap['caps_win_quote'] := "keyFunc_win_quote"

        ; ( Enter )
        keysMap['caps_win_enter'] := "keyFunc_win_enter"

        ; 逗号( , )
        keysMap['caps_win_comma'] := "keyFunc_win_comma"

        ; 句号( 。 )
        keysMap['caps_win_dot'] := "keyFunc_win_dot"

        ; 斜杠( / )
        keysMap['caps_win_slash'] := "keyFunc_win_slash"

        ; 空格( Space )
        keysMap['caps_win_space'] := "keyFunc_win_space"
    }

    ; =========   鼠标操作 ... 开始
    {
        ; 鼠标滚轮向前
        keysMap['caps_win_wheelUp'] := "keyFunc_win_wheelUp"

        ; 鼠标滚轮向前
        keysMap['caps_win_wheelDown'] := "keyFunc_win_wheelDown"

        ; 鼠标中键
        keysMap['caps_win_midButton'] := "keyFunc_win_midButton"

        ; 鼠标左键
        keysMap['caps_win_leftButton'] := "keyFunc_win_leftButton"

        ; 鼠标右键
        keysMap['caps_win_rightButton'] := "keyFunc_win_rightButton"
    }
}
