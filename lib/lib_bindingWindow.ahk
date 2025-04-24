#Requires AutoHotkey v2.0

class BindingWindow {

    ;! 绑定窗口
    static binding(key) {
        ; 获取当前窗口信息
        nId := WinExist('A')
        nClass := WinGetClass('ahk_id ' nId)
        nExe := WinGetProcessName('ahk_id ' nId)
        nName := WinGetTitle('ahk_id ' nId)
        nPath := WinGetProcessPath('ahk_id ' nId)

        ; 比对ini中当前key所绑定的窗口(如果绑定的窗口相同则取消绑定，如果不相同则覆盖绑定)
        section := IniRead('winsInfosRecorder.ini', key, , '')
        iniKeyId := IniRead('winsInfosRecorder.ini', key, 'ahk_id', '')
        iniKeyClass := IniRead('winsInfosRecorder.ini', key, 'ahk_class', '')
        iniKeyExe := IniRead('winsInfosRecorder.ini', key, 'ahk_exe', '')
        iniKeyPath := IniRead('winsInfosRecorder.ini', key, 'path', '')

        foundCount := RegExMatch(iniKeyClass, '^[^\[\]\:]+', &mrClass)

        if (section && ((nId == iniKeyId) || (RegExMatch(nClass, '^' mrClass[]
        ) &&
            (nExe == iniKeyExe)))) {
            this.ShowToolTips('取消绑定')
            IniDelete('winsInfosRecorder.ini', key)
        } else {
            this.ShowToolTips('覆盖绑定')
            IniWrite(nId, 'winsInfosRecorder.ini', key, 'ahk_id')	        ;写入id到ini
            IniWrite(nClass, 'winsInfosRecorder.ini', key, 'ahk_class')  ;写入class到ini
            IniWrite(nExe, 'winsInfosRecorder.ini', key, 'ahk_exe')         ;写入进程名到ini
            IniWrite(nPath, 'winsInfosRecorder.ini', key, 'path')         ;写入path到ini
        }
    }

    ;! 激活窗口
    static active(key) {
        ; 查询当前key是否绑定了窗口
        section := IniRead('winsInfosRecorder.ini', key, , '')
        if (!section) {
            this.ShowToolTips('该按键尚未绑定窗口')
            return
        }

        ; 读取目标窗口信息
        tId := IniRead('winsInfosRecorder.ini', key, 'ahk_id', '')
        tClass := IniRead('winsInfosRecorder.ini', key, 'ahk_class', '')
        tExe := IniRead('winsInfosRecorder.ini', key, 'ahk_exe', '')
        tPath := IniRead('winsInfosRecorder.ini', key, 'path', '')

        ; 先通过target_ahk_id查询窗口是否存在
        if (!WinExist('ahk_id ' . tId)) {
            ; 如果 ahk_id 没有找到窗口则尝试通过 ahk_class 和 ahk_exe 找到窗口
            SetTitleMatchMode('RegEx')
            ; 防错步骤(临时处理方案)
            RegExMatch(tClass, '^[^\[\]\:]+', &mClass)
            ; TrayTip('mClass[] = ' mClass[], '调试', 'IconI')
            OutputDebug('mClass[] = ' mClass[])
            tempId := WinExist('ahk_class ' '^' mClass[] ' ahk_exe ' tExe)

            if (tempId) {
                ; 如果通过 ahk_class 和 ahk_exe 找到窗口，则更新ini中记录的ahk_id
                IniWrite(tempId, 'winsInfosRecorder.ini', key, 'ahk_id')   ;更新id到ini
                tId := tempId
            } else {
                ; 如果进程不存在且 target_path 存在就直接运行 target_path
                if (FileExist(tPath)) {
                    ; this.showToolTips('进程不存在，在尝试启动进程：' tExe)
                    TrayTip('在尝试启动进程：' tExe, '进程不存在', 'Icon!')
                    try {
                        Run(tPath)
                    } catch Error as e {
                        this.ShowToolTips(e.Message)
                    }
                } else {
                    ; this.showToolTips('进程不存在')
                    TrayTip('且无法找到进程"' tExe '"的路径 (请重新绑定窗口)', '进程不存在', 'Icon!')
                }
                return
            }
        }

        ; this.showToolTips('成功找到进程')
        ; 如果目标窗口存在则直接尝试激活/最小化窗口
        if (WinActive('ahk_id' tId)) {
            ; 如果窗口已经被激活了，则进行最小化
            WinMinimize('ahk_id' tId)
        } else {
            ; 否则进行窗口激活
            WinActivate('ahk_id' tId)
        }

    }
    /**
     * * 显示ToolTips消息
     * @param msg 消息内容
     * @param duration 持续时间
     */
    static ShowToolTips(msg, duration := 1000) {
        ToolTip(msg)
        SetTimer(() => ToolTip(), duration)
    }
}