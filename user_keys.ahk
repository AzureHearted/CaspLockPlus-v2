#Requires AutoHotkey v2.0
#Include <lib_functions>

RegisterUserCapsLookHotkeys() {
  global CapsLookPlus
  /** VsCode、Visual Studio和Quicker共通的部分快捷键 */
  ; 向⬆️移动代码
  CapsLookPlus.AddHotkey("$#I", "!{Up}", , "ahk_exe i)(Code|devenv|Quicker)\.exe")
  ; 向⬇️移动代码
  CapsLookPlus.AddHotkey("$#K", "!{Down}", , "ahk_exe i)(Code|devenv|Quicker)\.exe")

  /** VsCode的部分快捷键 */
  ; 删除行(Vscode 默认快捷键 Ctrl + Shift + K)
  CapsLookPlus.AddHotkey("$D", "^+k", , "ahk_exe i)Code\.exe")
  ; 向⬆️复制行
  CapsLookPlus.AddHotkey("$N", "+!{Up}", , "ahk_exe i)Code\.exe")
  ; 向⬇️复制行
  CapsLookPlus.AddHotkey("$M", "+!{Down}", , "ahk_exe i)Code\.exe")


  /** Quicker的部分快捷键 */
  ; 向⬇️复制行
  CapsLookPlus.AddHotkey("$M", "^{d}", , "ahk_exe i)Quicker\.exe")
  ; 删除当前行
  CapsLookPlus.AddHotkey("$D", "^+{d}", , "ahk_exe i)Quicker\.exe")
}