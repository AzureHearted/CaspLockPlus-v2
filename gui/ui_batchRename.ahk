#Requires AutoHotkey v2.0
#Include <JSON>
#Include <Array>
#Include <StringUtils>

; 防止中文被转义
JSON.EscapeUnicode := false

RuleTypeMap := Map(
    "插入", "Insert",
    "替换", "Replace",
    "移除", "Remove",
    "序列化", "Serialize",
    "填充", "Fill",
    "正则", "Regex",
    "扩展名", "Extension"
)

RuleTypeReverseMap := Map(
    "Insert", "插入",
    "Replace", "替换",
    "Remove", "移除",
    "Serialize", "序列化",
    "Fill", "填充",
    "Regex", "正则",
    "Extension", "扩展名"
)

;! 带GUI批量重命名
class UIBatchReName {
    /** @type {Gui} */
    gui := ""
    isShow := false
    isOpenRuleEdit := false
    ; 间隙大小
    gapX := 2
    gapY := 4

    rules := []
    /** @type {Array<ReNameFile>} */
    files := []

    ; 预设目录（相对于脚本所在目录）
    presetDir := "\ReName\preset"

    DPIScale := A_ScreenDPI / 96

    ; 构造
    __New() {

        this.gui := Gui('+Resize +MinSize680x400', '批量重命名')

        /** @type {UIRuleEdit} */
        this.RuleEdit := UIRuleEdit(this)

        ; this.gui := Gui('', '批量重命名')
        this.gui.SetFont('q5 s10', "Microsoft YaHei")

        this.gui.MarginX := this.gapX
        this.gui.MarginY := this.gapY

        ;* 顶部按钮
        ; 新增规则按钮
        this.btnAddRule := this.gui.AddButton("r0.75 vAddRule Section", "新增")
        this.btnAddRule.OnEvent("Click", (*) => this.ShowRuleEdit("create", true))
        ; 删除规则按钮
        this.btnDeleteRule := this.gui.AddButton("x+m ys hp vDeleteRule", "移除")
        this.btnDeleteRule.OnEvent("Click", (*) => this.DeleteRule())
        ; 上移规则按钮
        this.btnUpRule := this.gui.AddButton("x+m ys hp vUpRule", "上移")
        this.btnUpRule.OnEvent('Click', (*) => this.UpRule())
        ; 下移规则按钮
        this.btnDownRule := this.gui.AddButton("x+m ys hp vDownRule", "下移")
        this.btnDownRule.OnEvent('Click', (*) => this.DownRule())
        ; 预设选项
        this.gui.AddText("x+m" 4 " yp" 4, "预设：")
        this.listPreset := this.gui.AddDropDownList("x+m ys")
        this.listPreset.OnEvent("Change", (ctrlObj, info) => this.OnPresetChange(ctrlObj, info))

        this.btnSavePreset := this.gui.AddButton("x+m ys r0.75 +Disabled", "保存预设")
        this.btnSavePreset.OnEvent("Click", (*) => this.SavePreset())
        ; this.btnSavePreset.OnEvent("ContextMenu",(GuiObj, GuiCtrlObj, Item, IsRightClick, X, Y)=>this.OnBtnSavePresetContextMenu())
        this.btnDeletePreset := this.gui.AddButton("x+m hp +Disabled", "删除预设")
        this.btnDeletePreset.OnEvent("Click", (*) => this.DeletePreset())
        this.btnManagePreset := this.gui.AddButton("x+m hp", "预设重命名")

        ;清空规则按钮
        this.btnClearRule := this.gui.AddButton("x+m ys r0.75 vClearRule", "清空规则")
        this.btnClearRule.OnEvent("Click", (*) => this.ClearRule())

        ;* 创建规则ListView
        defRuleColumns := ["#", "规则", "说明"]
        this.listRuleView := this.gui.AddListView("x" this.gapX " y+m r8 NoSortHdr Checked Grid Section", defRuleColumns)

        ;* 中部按钮
        this.btnApply := this.gui.AddButton("y+" this.gapY " r0.75 +Disabled", "应用")
        this.btnApply.OnEvent("Click", (*) => this.ReName())

        this.btnPreview := this.gui.AddButton("x+m yp hp", "预览")
        this.btnPreview.OnEvent("Click", (*) => this.Update(true))

        this.btnClearFiles := this.gui.AddButton("x+m yp hp", "清空文件列表")
        this.btnClearFiles.OnEvent("Click", (*) => this.ClearFile())

        ;* 创建文件ListView
        defFileColumns := ["状态", "名称", "新名称", "路径"]
        this.listFileView := this.gui.AddListView("r15 Grid xs Checked LV0x4000", defFileColumns)


        ;* 状态栏
        this.stateBar := this.gui.AddStatusBar()

        ; -------------------------

        ; 设置菜单
        ; this.MenuBar := MenuBar()

        ; -------------------------

        ; 绑定ListView事件
        this.listRuleView.OnEvent("ItemCheck", (listObj, index, isChecked) => this.OnListRuleViewItemCheck(index, isChecked))
        this.listRuleView.OnEvent("DoubleClick", (listObj, index) => this.OnListRuleViewDoubleClick(index))

        this.listFileView.OnEvent("ItemCheck", (listObj, index, isChecked) => this.OnListFileViewItemCheck(index, isChecked))
        this.listFileView.OnEvent("ColClick", (listObj, colIndex) => this.OnListFileViewColClick(colIndex))

        ; 绑定窗口事件
        this.gui.OnEvent('Size', (guiObj, MinMax, Width, Height) => this.OnWindowResize(guiObj, MinMax, Width, Height))
        this.gui.OnEvent("Close", (*) => this.Close())
        this.gui.OnEvent("DropFiles", (GuiObj, GuiCtrlObj, FileArray, X, Y) => this.OnDropFiles(GuiCtrlObj, FileArray, X, Y))

        ;* 注册窗口热键
        HotIfWinActive("ahk_id " this.gui.Hwnd)

        ; 全选文件列表p
        Hotkey("^a", HotKeyCtrlACallback)
        HotKeyCtrlACallback(HotkeyName) {
            ; 获取焦点控件的句柄
            hwnd := ControlGetFocus()
            ; Console.Debug("全选列表", hwnd, this.listFileView.Hwnd)
            if (hwnd == this.listRuleView.Hwnd) {
                ; 全选规则列表
                ; Console.Debug("全选规则列表")
                loop this.listRuleView.GetCount() {
                    this.listRuleView.Modify(A_Index, "+Select")
                }
            }
            if (hwnd == this.listFileView.Hwnd) {
                ; 全选文件列表
                ; Console.Debug("全选文件列表")
                loop this.listFileView.GetCount() {
                    this.listFileView.Modify(A_Index, "+Select")
                }
            }
        }

        ; 保存预设
        Hotkey("^s", HotKeyCtrlSCallback)
        HotKeyCtrlSCallback(HotkeyName) {
            if (this.rules.Length) {
                this.SavePreset()
            }
        }

        HotIf()

    }

    /**
     * * 回调窗口尺寸
     * @param {Gui} GuiObj 窗口Gui对象
     * @param {Integer} MinMax 窗口状态
     * @param {Integer} Width 窗口宽度
     * @param {Integer} Height 窗口高度
     */
    OnWindowResize(guiObj, MinMax, wWidth, wHeight) {
        Critical "on"
        ; 如果窗口被最小化 (-1)，则无需调整控件，直接返回
        if (MinMax == -1)
            return

        ; 获取窗口的视窗尺寸
        this.gui.GetClientPos(&wClientX, &wClientY, &wClientW, &wClientH)
        wMarginX := this.gui.MarginX
        wMarginY := this.gui.MarginY

        ; 查询状态栏高度
        this.stateBar.GetPos(, , , &stateBarHeight)
        ; 计算视口剩余高度
        viewHight := wClientH - stateBarHeight

        ;* 调整顶部按钮 (通常不需要改动)
        this.btnAddRule.GetPos(&xBtnAddRule, &yBtnAddRule, &wBtnAddRule, &hBtnAddRule)
        this.btnAddRule.Move()

        this.btnClearRule.GetPos(&xBtnClearRule, &yBtnClearRule, &wBtnClearRule, &hBtnClearRule)
        this.btnClearRule.Move(wClientW - wMarginX - wBtnClearRule)

        ; PostMessage(0x153, -1, hBtnAddRule, this.listPreset)  ; 设置选区字段的高度.
        ; PostMessage(0x153, 0, hBtnAddRule, this.listPreset)  ; 设置列表项的高度.
        this.listPreset.GetPos(&xListPreset, &yListPreset, &wListPreset, &hListPreset)
        this.listPreset.Move(, yBtnAddRule + (hBtnAddRule - hListPreset) / 2,)


        ;! 计算除按钮和空白区域尺寸外剩余的尺寸
        remainH := viewHight - (hBtnAddRule + wMarginY) * 2 - wMarginY * 3

        ;* 计算两个listView分别分配的尺寸
        LRV_NewHeight := (remainH) * 0.3
        LFV_NewHeight := remainH - LRV_NewHeight

        ;* 调整listRuleView
        this.listRuleView.GetPos(&xLRV, &yLRV, &wLRV, &hLRV)
        this.listRuleView.Move(, yBtnAddRule + hBtnAddRule + wMarginY, wClientW - wMarginX * 2, LRV_NewHeight)

        ;* 调整中间按钮
        this.listRuleView.GetPos(&xLRV, &yLRV, &wLRV, &hLRV)
        this.btnApply.GetPos(&xBtnApply, &yBtnApply, &wBtnApply, &hBtnApply)

        middleButtonY := yLRV + hLRV + wMarginY

        this.btnApply.Move(, middleButtonY)
        this.btnPreview.Move(, middleButtonY)

        this.btnClearFiles.GetPos(&xBtnClearFiles, &yBtnClearFiles, &wBtnClearFiles, &hBtnClearFiles)
        this.btnClearFiles.Move(wClientW - wMarginX - wBtnClearFiles, middleButtonY)

        ;* 调整listFileView
        this.btnClearFiles.GetPos(&xBtnClearFiles, &yBtnClearFiles, &wBtnClearFiles, &hBtnClearFiles)
        this.listFileView.GetPos(&xLFV, &yLFV, &wLFV, &hLFV)
        this.listFileView.Move(, yBtnClearFiles + hBtnClearFiles + wMarginY, wClientW - wMarginX * 2, LFV_NewHeight)

        ;* 底部按钮
        this.listFileView.GetPos(&xLFV, &yLFV, &wLFV, &hLFV)

        bottomButtonY := yLFV + hLFV + wMarginY

        ; this.btnClose.GetPos(&xBtnClose, &yBtnClose, &wBtnClose, &hBtnClose)
        ; this.btnClose.Move(wClientW - wMarginX - wBtnClose, bottomButtonY)

    }

    /**
     * 拖拽文件回调
     * @param {Object} GuiCtrlObj 
     * @param {Array} FileArray 文件路径列表
     * @param {Integer} X 文件拖拽位置的 X 坐标, 相对于窗口客户端区域的左上角.
     * @param {Integer} Y 文件拖拽位置的 Y 坐标, 相对于窗口客户端区域的左上角.
     */
    OnDropFiles(GuiCtrlObj, FileArray, X, Y) {
        Console.Debug("拖拽文件：", FileArray)
        for (path in FileArray) {
            file := ReNameFile(path)
            this.files.Push(file)
            this.AddFile(file)
            ;* 刷新ListView 同时重算重命名结果
            this.Update(true)
        }
    }

    /**
     * *添加规则
     * @param {RenameRule.InsertRule|RenameRule.ReplaceRule|RenameRule.RemoveRule|RenameRule.SerializeRule|RenameRule.FillRule|RenameRule.RegexRule|RenameRule.ExtensionRule|""} rule 
     */
    AddRule(rule) {
        ; Console.Debug("新增规则：" rule.TypeName "," rule.Description)
        this.rules.Push(rule)
        index := this.listRuleView.Add("", this.rules.Length, rule.TypeName, rule.Description)
        this.listRuleView.Modify(index, "Check") ; 默认勾选
        ; 更新两个ListView
        this.Update(true)
        ; 取消对 `保存规则` 按钮的禁用
        this.btnSavePreset.Opt("-Disabled")
    }

    /**
     * *更新规则
     * @param {RenameRule.InsertRule|RenameRule.ReplaceRule|RenameRule.RemoveRule|RenameRule.SerializeRule|RenameRule.FillRule|RenameRule.RegexRule|RenameRule.ExtensionRule|""} rule 规则数据
     * @param {Integer} index 索引
     */
    UpdateRule(rule, index) {
        this.rules[index] := rule
        this.listRuleView.Modify(index, "Check", , rule.TypeName, rule.Description)
        this.Update(true)
    }

    ;* 删除所选规则
    DeleteRule(*) {
        listIndex := this.GetListViewIndexList(this.listRuleView, , true)
        ; Console.Debug("获取到的所选项的索引：", listIndex)

        for (index in listIndex) {
            ; 先对rules进行调整
            this.rules.RemoveAt(index)
            ; 再对listRuleView进行调整
            this.listRuleView.Delete(index)
        }

        ; 重新设置索引
        loop this.listRuleView.GetCount() {
            this.listRuleView.Modify(A_Index, , A_Index)
        }

        ; 更新两个ListView
        this.Update(true)

        ; 判断规则列表是否为空
        if (!this.rules.Length) {
            ; 添加对 `保存规则` 按钮的禁用
            this.btnSavePreset.Opt("+Disabled")
        }
    }

    ;* 上移规则
    UpRule(*) {
        listSelectedIndex := this.GetListViewIndexList(this.listRuleView,)
        listCheckedIndex := this.GetListViewIndexList(this.listRuleView, "C")
        ; Console.Debug("获取到的所选项的索引：", listIndex)

        for (index in listSelectedIndex) {
            ; 跳过已经在开头的规则
            if (index <= 1)
                continue
            newIndex := index - 1

            ; 先对rules进行调整
            rule := this.rules.RemoveAt(index)
            this.rules.InsertAt(newIndex, rule)

            ; 再对listRuleView进行调整
            this.listRuleView.Delete(index)
            typeName := RuleTypeReverseMap.Get(rule.Type)
            this.listRuleView.Insert(newIndex, , , rule.TypeName, rule.Description)

            ; 保持选中状态
            this.listRuleView.Modify(newIndex, "+Select")
            ; 判断是否有Checked状态
            if (listCheckedIndex.IndexOf(index)) {
                this.listRuleView.Modify(newIndex, "+Check")
            }
        }
        ; 重新设置索引
        loop this.listRuleView.GetCount() {
            this.listRuleView.Modify(A_Index, , A_Index)
        }

        ; 更新两个ListView
        this.Update(true)
    }

    ;* 下移规则
    DownRule(*) {
        listIndex := this.GetListViewIndexList(this.listRuleView, , true)
        listCheckedIndex := this.GetListViewIndexList(this.listRuleView, "C")
        ; Console.Debug("获取到的所选项的索引：", listIndex)

        for (index in listIndex) {
            ; 跳过已经在结尾的规则
            if (index >= this.rules.Length)
                continue
            newIndex := index + 1

            ; 先对rules进行调整
            rule := this.rules.RemoveAt(index)
            this.rules.InsertAt(newIndex, rule)

            ; 再对listRuleView进行调整
            this.listRuleView.Delete(index)
            typeName := RuleTypeReverseMap.Get(rule.Type)
            this.listRuleView.Insert(newIndex, , , rule.TypeName, rule.Description)

            ; 保持选中状态
            this.listRuleView.Modify(newIndex, "+Select")
            ; 判断是否有Checked状态
            if (listCheckedIndex.IndexOf(index)) {
                this.listRuleView.Modify(newIndex, "+Check")
            }
        }
        ; 重新设置索引
        loop this.listRuleView.GetCount() {
            this.listRuleView.Modify(A_Index, , A_Index)
        }

        ; 更新两个ListView
        this.Update(true)
    }

    /**
     * * 获取选中的规则
     * @param {Gui.ListView} LV ListView控件对象
     * @param {String} rowType 如果省略, 则方法搜索下一个选择的/高亮的行(请参阅下面的例子). 否则, 请指定以下字符串之一:
     * `C` 或 `Checked`: 寻找下一个选中的行.
     * `F` 或 `Focused`: 寻找焦点行. 在整个列表中不可能有多个焦点行, 且有时甚至没有.
     * @param {Integer} reverse 是否反序结果
     * @returns {Array} 输出结果
     */
    GetListViewIndexList(LV := {}, rowType := "", reverse := false) {
        list := []
        RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
        loop {
            RowNumber := LV.GetNext(RowNumber, rowType)  ; 在前一次找到的位置后继续搜索.
            if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
                break
            list.Push(RowNumber)
        }

        newList := []
        if (reverse) {
            ; 判断是否反序
            loop list.Length {
                newList.Push(list[list.Length - A_Index + 1])
            }
        } else {
            newList := list
        }

        return newList
    }

    ;! 清空规则列表
    ClearRule() {
        if (this.rules.Length > 0) {
            this.rules.RemoveAt(1, this.rules.Length)
        }
        this.listRuleView.Delete()
        this.Update(true)

        ; 添加对 `保存规则` 按钮的禁用
        this.btnSavePreset.Opt("+Disabled")
    }

    ;* 保存预设
    SavePreset() {
        ; this.gui.GetPos(&xGui, &yGui, &wGui, &hGui)
        ; this.gui.GetClientPos(&xGui, &yGui, &wGui, &hGui)
        WinGetClientPos(&xGui, &yGui, &wGui, &hGui, "ahk_id" this.gui.Hwnd)
        ; WinGetPos(&xGui, &yGui, &wGui, &hGui, "ahk_id" this.gui.Hwnd)

        inputBoxObj := InputBox("请输入预设名称：", "创建预设", "w200  h90  x" xGui + (wGui - 200 * this.DPIScale) / 2 " y" yGui, "新预设")
        if (inputBoxObj.Result == "Cancel") {
            return
        }
        preset := {
            name: inputBoxObj.Value,
            rules: this.rules
        }

        writeTo := A_ScriptDir this.presetDir "\" preset.name ".json"
        if (FileExist(writeTo)) {
            op := MsgBox("预设 “" preset.name "” 已存在，确认覆盖？", "提示", "YesNo Owner" this.gui.Hwnd)
            if (op == "No") {
                return
            }
        }

        ; Console.Debug("预设准备写入：" writeTo)
        SplitPath(writeTo, , &dir)
        ; 如果目录不存在先创建目录
        if (!DirExist(dir))
            DirCreate(dir)
        ; 写入预设到json文件
        writeCount := JSON.DumpFile(preset, writeTo, true, "UTF-8")
        ; Console.Debug("保存成功，共写入：" writeCount "个字符")
        ; 重新加载预设名称列表
        this.ReLoadPresetNameList()
        ; 设定刚创建预设为当前预设
        this.nowPresetName := preset.name
    }

    ;* 加载预设名称列表
    ReLoadPresetNameList() {
        dir := A_ScriptDir this.presetDir
        list := []
        loop files dir "\*.json", "F" {
            SplitPath(A_LoopFileFullPath, , , , &presetName)
            list.Push(presetName)
        }
        this.listPreset.Delete()
        this.listPreset.Add(list)
    }

    /** @type {String} 当前预设名称 */
    nowPresetName {
        get {
            ; 返回当前预设名
            ; Console.Debug("读取当前预设名称")
            return this.listPreset.Text
        }
        set {
            ; 加载预设
            if (IsSet(Value) && Value) {
                ; Console.Debug("加载预设：" Value)
                path := A_ScriptDir this.presetDir "\" Value ".json"
                ; Console.Debug("预设路径:" path)
                if (FileExist(path)) {
                    ; 加载预设
                    /** @type {Map} */
                    jsonMap := JSON.LoadFile(path, "UTF-8") ;? `JSON.LoadFile` 和 `JSON..Parse` 解析出来的结果是一个 `Map` 对象
                    ; Console.Debug("加载预设 " Type(jsonMap), jsonMap)
                    ; 清空原有规则
                    this.ClearRule()
                    /** @type {Map} */
                    rawRules := jsonMap.Get("rules")
                    ; 将原始对象转为Rule对象
                    for (index, rawRule in rawRules) {
                        ; Console.Debug("规则类型：" Type(rawRule), rawRule)
                        rule := RenameRule.%rawRule.Get("Type") "Rule"%(rawRule)
                        this.AddRule(rule)
                    }
                    this.listPreset.Choose(Value)
                    ; 成功加载预设后允许使用删除预设操作
                    this.btnDeletePreset.Opt("-Disabled")
                }
            } else {
                Console.Debug("预设加载失败：" Value)
                ; 重新加载预设列表
                this.ReLoadPresetNameList()
                ; 失败则禁用删除预设按钮
                this.btnDeletePreset.Opt("+Disabled")
            }
        }
    }

    /**
     * ! 当用户选择了预设时的回调 (预设加载)
     * @param {Gui.DropDownList} ctrlObj 控件对象
     * @param {String} presetName 预设名
     */
    OnPresetChange(ctrlObj, presetName) {
        this.nowPresetName := this.listPreset.Text
    }

    ;* 删除预设
    DeletePreset() {
        ; Console.Debug("准备删除预设：" this.nowPresetName)
        ; 获取预设名称
        presetName := this.nowPresetName
        ; 获取预设下标
        index := this.listPreset.Value

        path := A_ScriptDir this.presetDir "\" presetName ".json"
        if (FileExist(path)) {
            op := MsgBox("确认删除预设 “" presetName "” ", "提示", "YesNo Owner" this.gui.Hwnd)
            Console.Debug("用户确认删除：" op)
            if (op == "No")
                return

            ; 先去除预设列表里面的项目
            if (index) {
                this.nowPresetName := ""
                this.listPreset.Delete(index)
            }

            ; 规则文件丢入回收站
            FileRecycle(path)
        } else {
            this.btnDeletePreset.Opt("+Disabled")
        }
    }

    ;*更新规则ListView
    UpdateRuleListView() {
        this.listRuleView.ModifyCol(1, 'AutoHdr')
        this.listRuleView.ModifyCol(2, 'AutoHdr')
        this.listRuleView.ModifyCol(3, 'AutoHdr')
    }

    /**
     * ListRuleView的Check事件
     * @param {Integer} index 索引行号
     * @param {Integer} isChecked 是否勾选
     */
    OnListRuleViewItemCheck(index, isChecked) {
        ; Console.Debug("行号：" index ",勾选状态：" isChecked)
        this.Update(true)
    }

    /**
     * ListRuleView的双击事件
     * @param {Integer} index 索引行号
     */
    OnListRuleViewDoubleClick(index) {
        if (index) {
            tabIndex := this.RuleEdit.types.IndexOf(RuleTypeReverseMap.Get(this.rules[index].Type))
            this.RuleEdit.nowTabIndex := tabIndex
            this.RuleEdit.editRuleIndex := index
            this.ShowRuleEdit("edit", true)
        } else {
            ; 触发创建规则
            this.ShowRuleEdit("create", true)
        }

    }

    /**
     * * 显示规则编辑窗口
     * @param {"create"|"edit"} mode 模式
     * @param {Integer} disabledParent 禁止父窗口操作
     */
    ShowRuleEdit(mode := "create", disabledParent := false) {
        this.RuleEdit.Show(mode, disabledParent)

    }

    /**
     * * 获取文件列表
     * @returns {Array<String>} 
     */
    GetFiles() {
        list := []
        ; 尝试获取选中的文件路径
        files := GetSelectedExplorerItemsPaths()
        ; Console.Debug(files)

        if (files.Length > 0) {
            ; 遍历所选文件
            for path in files {
                SplitPath(path, &name)
                attrib := FileGetAttrib(path)
                if (FileGetAttrib(path) ~= "[H]")
                    continue  ; 跳过这个文件并继续下一个文件.

                if (attrib ~= "[A]") {
                    ; this.listFileView.Add(, "✔", name, name, path)
                    list.Push(path)
                }

                if (attrib ~= "[D]") {
                    ; 遍历路径下的文件
                    ; Loop Files pathNowWindow "\*", "FDR" {
                    loop files path "\*", "F" {
                        pathFile := A_LoopFileFullPath
                        fileName := A_LoopFileName
                        if A_LoopFileAttrib ~= "[H]"  ; 跳过任何具有 H(隐藏), R(只读) 或 S(系统). 请参阅 ~= 运算符.
                            continue  ; 跳过这个文件并继续下一个文件.
                        ; this.listFileView.Add(, "✔", fileName, fileName, pathFile)
                        list.Push(pathFile)
                    }
                }

            }
        } else {
            ; 获取当前窗口路径
            pathNowWindow := GetActiveExplorerPath()

            ; Console.Debug("当前窗口路径：" pathNowWindow)

            if (pathNowWindow == "")
                return list
            ; Console.Debug(pathNowWindow "*")

            ; 遍历路径下的文件
            ; Loop Files pathNowWindow "\*", "FDR" {
            loop files pathNowWindow "\*", "F" {
                path := A_LoopFileFullPath
                name := A_LoopFileName
                if A_LoopFileAttrib ~= "[H]"  ; 跳过任何具有 H(隐藏), R(只读) 或 S(系统). 请参阅 ~= 运算符.
                    continue  ; 跳过这个文件并继续下一个文件.
                ; this.listFileView.Add(, "✔", name, name, path)
                list.Push(path)
            }
        }

        return list
    }

    /**
     * *加载文件到ListView
     */
    LoadFile() {
        for (file in this.files) {
            this.AddFile(file)
        }
    }

    /**
     * *加载文件到ListView
     * @param {ReNameFile} file 重命名文件对象
     */
    AddFile(file) {
        ; Console.Debug(file.NewPath)
        index := this.listFileView.Add(, "✔", file.Name, file.Name, file.Path)
        this.listFileView.Modify(index, "+Check")
    }

    ;! 清空文件列表
    ClearFile() {
        ; 先清空files
        if (this.files.Length > 0) {
            this.files.RemoveAt(1, this.files.Length)
        }
        ; 再清空ListView
        this.listFileView.Delete()
        ; 文件清空后就不需要更新ListView了
        ; 但需要更新状态栏
        this.UpdateStateBar()
    }

    ;*更新文件ListView
    UpdateFileListView() {
        this.listFileView.ModifyCol(1, 'AutoHdr')
        this.listFileView.ModifyCol(2, 'AutoHdr')
        this.listFileView.ModifyCol(3, 'AutoHdr')
        this.listFileView.ModifyCol(4, 'AutoHdr')
    }

    /**
     * * 更新两个ListView (可选计算重命名结果)
     * @param updateResult 是否更新重命名结果
     */
    Update(updateResult := false) {

        if (updateResult) {
            ; 计算重命名预览结果
            this.CalcRenamePreview()
        }

        ; 更新ListView
        this.UpdateRuleListView()
        this.UpdateFileListView()

        ; 更新状态栏
        this.UpdateStateBar()
    }

    /**
     * * 更新状态栏文本
     */
    UpdateStateBar() {
        this.stateBar.SetText(" " this.files.Length " 个文件")
    }

    /**
     * ListFileView的Check事件
     * @param {Integer} index 索引行号
     * @param {Integer} isChecked 是否勾选
     */
    OnListFileViewItemCheck(index, isChecked) {
        ; Console.Debug("行号：" index ",勾选状态：" isChecked)
        this.files[index].Enable := isChecked
        this.Update()
    }

    /**
     * 检测ListFileView的标题点击事件 (点击后进行排序)
     * @param {Integer} colIndex 列号 
     */
    OnListFileViewColClick(colIndex) {
        ; Console.Debug("第" colIndex "列标题被点击")
        ; 根据 `ListFileView` 排序 `this.files` 数组
        this.SortFilesByListFileView()
    }

    /**
     * * 根据 `ListFileView` 排序 `this.files` 数组
     */
    SortFilesByListFileView() {
        ; 接收排序后的结果
        /** @type {Array<ReNameFile>} */
        newFiles := []
        ; 根据ListFileView展示的数据对this.files进行排序
        loop this.listFileView.GetCount() {
            path := this.listFileView.GetText(A_Index, 4)
            ; 找到对应的file在this.files中的位置
            index := this.files.Find((f) => f.Path == path)
            file := this.files[index]
            newFiles.Push(file)
        }
        ; 先清空 this.files
        if (this.files.Length > 0) {
            this.files.RemoveAt(1, this.files.Length)
        }
        ; 再添加
        loop newFiles.Length {
            this.files.Push(newFiles[A_Index])
        }
    }

    ;! 计算重命名预览结果
    CalcRenamePreview() {
        ; 获取已经勾选的规则列表
        checkedRuleIndexList := this.GetListViewIndexList(this.listRuleView, "C")
        ; Console.Debug("当前勾选的规则下标：", checkedRuleIndexList)
        checkedRules := []
        ; 只获取已勾选的规则列表
        loop checkedRuleIndexList.Length {
            index := checkedRuleIndexList[A_Index]
            checkedRules.Push(this.rules[index])
        }

        ; 如果规则列表为空则直接旧名称复制给新名称
        if (!checkedRules.Length) {
            loop this.files.Length {
                file := this.files[A_Index]
                file.InitInfo()
                this.listFileView.Modify(A_Index, '', , , file.NewName)
            }
            return
        }
        ; 初始化NewName
        loop this.files.Length {
            file := this.files[A_Index]
            file.InitInfo()
        }
        ; 依次执行规则
        loop checkedRules.Length {
            rule := checkedRules[A_Index]
            ReName.%rule.Type%(this.files, rule)
        }
        ;! 进行冲突检测
        this.CheckConflict()
        ; 最后更新视图
        loop this.files.Length {
            file := this.files[A_Index]
            this.listFileView.Modify(A_Index, '', , , file.NewName)
        }
    }

    /**
     * 冲突检测
     */
    CheckConflict() {
        isConflict := false
        loop this.files.Length {
            /** @type {ReNameFile} */
            file := this.files[A_Index]
            ; 跳过未修改的文件
            if (file.Path == file.NewPath) {
                this.listFileView.Modify(A_Index, , "✔")
                continue
            }
            ; 判断文件是否存在
            ; Console.Debug("新路径属性："  file.NewAttribute)
            ; file.NewAttribute 不为空则说文件存在即冲突
            this.listFileView.Modify(A_Index, , file.NewAttribute ? "❗" : "✔")
            if (file.NewAttribute) {
                isConflict := true
            }
        }
        if (isConflict) {
            ; 冲突时禁用重命名应用按钮
            this.btnApply.Opt('+Disabled')
        } else {
            ; 无冲突时取消对重命名应用按钮的禁用
            this.btnApply.Opt('-Disabled')
        }
    }

    ;! 执行重命名
    ReName() {
        ; Console.Debug("重命名应用")
        if (!this.files.Length) {
            MsgBox("没有可重命名文件。", "提示")
            return
        }

        for (index, fileItem in this.files) {
            ;* 跳过冲突项 NewAttribute 不为空就说明冲突
            if (fileItem.NewAttribute) {
                continue
            }

            try {
                if (fileItem.IsDirectory) {
                    ; 对目录的重命名
                    DirMove(fileItem.Path, fileItem.NewPath, "R")
                    ; 重命名完成后判断是否成功
                    if (DirExist(fileItem.NewPath)) {
                        ; 成功后重新调用__New方法
                        fileItem.__New(fileItem.NewPath)
                        this.listFileView.Modify(index, , fileItem.Name, fileItem.NewName, fileItem.Path)
                    }
                } else {
                    ; 对文件的重命名
                    ; Console.Debug("即将重命名：" fileItem.Path " => " fileItem.NewPath)
                    FileMove(fileItem.Path, fileItem.NewPath)
                    ; 重命名完成后判断是否成功
                    if (FileExist(fileItem.NewPath)) {
                        ; 成功后重新调用__New方法
                        fileItem.__New(fileItem.NewPath)
                        this.listFileView.Modify(index, , fileItem.Name, fileItem.NewName, fileItem.Path)
                    }
                }
            } catch as e {

            }
        }

        MsgBox("✔重命名成功！（成功重命名" this.files.Length "项）", "提示", "Owner" this.gui.Hwnd)
    }

    ; 显示窗口
    Show() {
        ; 加载预设列表
        this.ReLoadPresetNameList()
        ; 获取文件列表
        filePaths := this.GetFiles()

        this.RuleEdit.gui.Opt("+Owner" this.gui.Hwnd)

        ; 显示窗口
        if (!this.isShow) {
            ; 显示窗口
            this.gui.Show('w800 Center')
        } else {
            ; 并且激活窗口
            WinActivate("ahk_id" this.gui.Hwnd)
            if (this.RuleEdit.isShow) {
                WinActivate("ahk_id" this.RuleEdit.gui.Hwnd)
            }
        }

        ; 如果选中的文件列表数量>0则重新载入文件
        if (filePaths.Length > 0) {
            ; 若窗口已经存又再次触发则清空类别重新添加
            this.ClearFile()
            for (path in filePaths) {
                ; 转为ReNameFile对象并存入files
                this.files.Push(ReNameFile(path))
            }
            ; 加载文件列表
            this.LoadFile()
            ;* 刷新ListView 同时重算重命名结果
            this.Update(true)
            ;* 按照路径逻辑排序(首次排序)
            this.listFileView.ModifyCol(4, 'Logical Sort')
            ; 根据 `ListFileView` 排序 `this.files` 数组
            this.SortFilesByListFileView()
        }

        ;* 更新状态栏
        this.UpdateStateBar()

        this.isShow := true
    }

    ; 关闭窗口
    Close() {
        this.gui.Hide()
        this.isShow := false
        this.RuleEdit.Close()
        return 1
    }

    __Delete() {
        this.gui.Destroy()
    }

}

;! 添加规则or编辑窗口
class UIRuleEdit {
    /** @type {Gui} */
    gui := ''
    isShow := false
    mode := "create"
    nowTabIndex := 1
    types := [
        "插入",
        "替换",
        "移除",
        "序列化",
        "填充",
        "正则",
        "扩展名"
    ]
    tabWidth := 420
    editRuleIndex := 0 ; 当前编辑的规则索引

    gapX := 8
    gapY := 6

    DPIScale := A_ScreenDPI / 96

    /**
     * 
     * @param {UIBatchReName}  parent 
     */
    __New(parent) {
        this.parent := parent
        this.gui := Gui(, "规则")
        this.gui.SetFont('q5 s10', "Microsoft YaHei UI")
        this.gui.MarginX := this.gapX
        this.gui.MarginY := this.gapY

        ; Console.Debug("准备定义选项卡")

        ;* 定义选项卡
        this.typeTab := this.gui.AddTab3('', this.types)

        this.gui.SetFont("s10")

        ;? 插入
        this.typeTab.UseTab("插入")
        {
            insertGroup := this.gui.AddGroupBox("w" this.tabWidth " r12 Section", '配置：')

            this.gui.AddText("xp" 15 " yp" 25 " Section", "插入：")
            this.Ctl_Insert_Content := this.gui.AddEdit("x+m yp-" 2 " w340  vInsert_Content")

            this.gui.AddText("xs y+m", "位置：")
            ; "位置" 选项：第一列
            this.Ctl_Insert_Position_Prefix := this.gui.AddRadio("x+m yp" 2 " vInsert_Position_Prefix Group ", "前缀")
            this.Ctl_Insert_Position_Prefix.Value := 1
            this.Ctl_Insert_Position_Suffix := this.gui.AddRadio("xp y+m" 6 " vInsert_Position_Suffix", "后缀")
            this.Ctl_Insert_Position_Index := this.gui.AddRadio("xp y+m" 6 " vInsert_Position_Index", "位置：")
            this.Ctl_Insert_Position_Before := this.gui.AddRadio("xp y+m" 6 " vInsert_Position_Before", "到文本前：")
            this.Ctl_Insert_Position_After := this.gui.AddRadio("xp y+m" 6 " vInsert_Position_After", "到文本后：")
            this.Ctl_Insert_Position_Replace := this.gui.AddRadio("xp y+m" 6 " vInsert_Position_Replace", "替换当前名称")
            this.Ctl_Insert_IgnoreCase := this.gui.AddCheckbox("xp y+m" 6 " vInsert_IgnoreCase", "忽略大小写")
            this.Ctl_Insert_IgnoreCase.Value := 0
            this.Ctl_Insert_IgnoreExt := this.gui.AddCheckbox("xp y+m" 6 " vInsert_IgnoreExt", "忽略扩展名")
            this.Ctl_Insert_IgnoreExt.Value := 1

            ; "位置" 选项：第二列
            ; "位置" 相关附属
            this.Ctl_Insert_Position_Index_AnchorIndex_Edit := this.gui.AddEdit("x" 168 " y" 170 " w60  Section")
            this.Ctl_Insert_Position_Index_AnchorIndex := this.gui.AddUpDown("Range1-2147483647 vInsert_Position_Index_AnchorIndex", 1)
            this.Ctl_Insert_Position_Index_AnchorIndex.OnEvent('Change', (*) => this.Ctl_Insert_Position_Index.Value := true)
            this.Ctl_Insert_Position_Index_ReverseIndex := this.gui.AddCheckbox("x+m" " yp" " hp w80 vInsert_Position_Index_ReverseIndex", "从右到左")
            this.Ctl_Insert_Position_Index_ReverseIndex.OnEvent("Click", (*) => this.Ctl_Insert_Position_Index_ReverseIndex.Value ? this.Ctl_Insert_Position_Index.Value := true : "")
            ; "到文本前" 相关附属
            this.Ctl_Insert_Position_Before_AnchorText := this.gui.AddEdit("xs y+" 3 " vInsert_Position_Before_AnchorText")
            this.Ctl_Insert_Position_Before_AnchorText.OnEvent("Change", (*) => this.Ctl_Insert_Position_Before.Value := true)
            ; "到文本后" 相关附属
            this.Ctl_Insert_Position_After_AnchorText := this.gui.AddEdit("xp y+" 3 " vInsert_Position_After_AnchorText")
            this.Ctl_Insert_Position_After_AnchorText.OnEvent("Change", (*) => this.Ctl_Insert_Position_After.Value := true)
        }

        ;? 替换
        this.typeTab.UseTab("替换")
        {
            this.gui.AddGroupBox("w" this.tabWidth " r12", '配置：')

            this.gui.AddText("xp" 15 " yp" 25 " Section", "查找：")
            this.Ctl_Replace_Match := this.gui.AddEdit("x+m yp-" 2 " w340 vReplace_Match")
            this.gui.AddText("xs y+m", "替换：")
            this.Ctl_Replace_ReplaceTo := this.gui.AddEdit("x+m yp-" 2 " w340 vReplace_ReplaceTo")

            this.gui.AddText("xs y+m", "范围：")
            this.Ctl_Replace_Range_All := this.gui.AddRadio("x+m yp+" 2 " vReplace_Range_All Group", "全部")
            this.Ctl_Replace_Range_All.Value := 1
            this.Ctl_Replace_Range_First := this.gui.AddRadio("xp y+m vReplace_Range_First", "首个")
            this.Ctl_Replace_Range_Last := this.gui.AddRadio("xp y+m vReplace_Range_Last", "末个")
            this.Ctl_Replace_IgnoreCase := this.gui.AddCheckbox("xp y+m vReplace_IgnoreCase", "忽略大小写")
            this.Ctl_Replace_IgnoreCase.Value := 0
            this.Ctl_Replace_IgnoreExt := this.gui.AddCheckbox("xp y+m vReplace_IgnoreExt", "忽略扩展名")
            this.Ctl_Replace_IgnoreExt.Value := 1
        }

        ;? 移除
        this.typeTab.UseTab("移除")
        {
            this.gui.AddGroupBox("w" this.tabWidth " r12", '配置：')

            this.gui.AddText("xp" 15 " yp" 25 " Section", "查找：")
            this.Ctl_Remove_Match := this.gui.AddEdit("x+m yp-" 2 " w340 vRemove_Match")

            this.gui.AddText("xs y+m", "范围：")
            this.Ctl_Remove_Range_All := this.gui.AddRadio("x+m yp+" 2 " vRemove_Range_All Group", "全部")
            this.Ctl_Remove_Range_All.Value := true
            this.Ctl_Remove_Range_First := this.gui.AddRadio("xp y+m vRemove_Range_First", "首个")
            this.Ctl_Remove_Range_Last := this.gui.AddRadio("xp y+m vRemove_Range_Last", "末个")
            this.Ctl_Remove_IgnoreCase := this.gui.AddCheckbox("xp y+m vRemove_IgnoreCase", "忽略大小写")
            this.Ctl_Remove_IgnoreCase.Value := 0
            this.Ctl_Remove_IgnoreExt := this.gui.AddCheckbox("xp y+m vRemove_IgnoreExt", "忽略扩展名")
            this.Ctl_Remove_IgnoreExt.Value := 1

        }

        ;? 序列化
        this.typeTab.UseTab("序列化")
        {
            this.gui.AddGroupBox("w" this.tabWidth " r12", '')

            this.gui.AddGroupBox("x" 32 " y" 75 " r10.6 w230", '插入位置：')
            ; 位置设置
            this.Ctl_Serialize_Position_Prefix := this.gui.AddRadio("xp" 10 " yp" 25 " vSerialize_Position_Prefix Group", '前缀')
            this.Ctl_Serialize_Position_Prefix.Value := 1
            this.Ctl_Serialize_Position_Suffix := this.gui.AddRadio("xp y+m" 6 " vSerialize_Position_Suffix", "后缀")
            this.Ctl_Serialize_Position_Index := this.gui.AddRadio("xp y+m" 6 " vSerialize_Position_Index", "位置：")
            this.Ctl_Serialize_Position_Before := this.gui.AddRadio("xp y+m" 6 " vSerialize_Position_Before", "到文本前：")
            this.Ctl_Serialize_Position_After := this.gui.AddRadio("xp y+m" 6 " vSerialize_Position_After", "到文本后：")
            this.Ctl_Serialize_Position_Replace := this.gui.AddRadio("xp y+m" 6 " vSerialize_Position_Replace", "替换当前名称")
            this.Ctl_Serialize_IgnoreCase := this.gui.AddCheckbox("xp y+m" 6 " vSerialize_IgnoreCase", "忽略大小写")
            this.Ctl_Serialize_IgnoreCase.Value := 0
            this.Ctl_Serialize_IgnoreExt := this.gui.AddCheckbox("xp y+m" 6 " vSerialize_IgnoreExt", "忽略扩展名")
            this.Ctl_Serialize_IgnoreExt.Value := 1

            ; 位置设置：第二列
            ; 位置相关附属
            this.gui.AddEdit("x" 110 " y" 157 " w50 Section")
            this.Ctl_Serialize_Position_Index_AnchorIndex := this.gui.AddUpDown("Range1-2147483647 vSerialize_Position_Index_AnchorIndex", 1)
            this.Ctl_Serialize_Position_Index_AnchorIndex.OnEvent('Change', (*) => this.Ctl_Serialize_Position_Index.Value := true)
            this.Ctl_Serialize_Position_Index_ReverseIndex := this.gui.AddCheckbox("x+m" " yp" " hp w80 vSerialize_Position_Index_ReverseIndex", "从右到左")
            this.Ctl_Serialize_Position_Index_ReverseIndex.OnEvent("Click", (*) => this.Ctl_Serialize_Position_Index_ReverseIndex.Value ? this.Ctl_Serialize_Position_Index.Value := true : "")
            ; "到文本前" 相关附属
            this.Ctl_Serialize_Position_Before_AnchorText := this.gui.AddEdit("xs" 23 " y+" 3.5 " w100 vSerialize_Position_Before_AnchorText")
            this.Ctl_Serialize_Position_Before_AnchorText.OnEvent("Change", (*) => this.Ctl_Serialize_Position_Before.Value := true)
            ; "到文本后" 相关附属
            this.Ctl_Serialize_Position_After_AnchorText := this.gui.AddEdit("xp y+" 3.5 " w100 vSerialize_Position_After_AnchorText")
            this.Ctl_Serialize_Position_After_AnchorText.OnEvent("Change", (*) => this.Ctl_Serialize_Position_After.Value := true)

            ; 序列设置
            this.gui.AddGroupBox("x" 274 " y" 75 " r10.6 w150", '序列位置：')

            this.gui.AddText("xp" 10 " yp" 27 " Section", "起始值：")
            this.gui.AddEdit("x+m yp-" 2 " w50")
            this.Ctl_Serialize_SequenceStart := this.gui.AddUpDown("Range-2147483648-2147483647 vSerialize_SequenceStart", 1)

            this.gui.AddText("xs y+m", "步长：")
            this.gui.AddEdit("x+m" 13 " yp-" 2 " w50")
            this.Ctl_Serialize_SequenceStep := this.gui.AddUpDown("Range-2147483648-2147483647 vSerialize_SequenceStep", 1)

            this.gui.AddText("xs y+m", "补零：")
            this.gui.AddEdit("x+m" 13 " yp-" 2 " w50")
            this.Ctl_Serialize_PaddingCount := this.gui.AddUpDown("Range1-2147483647 vSerialize_PaddingCount", 3)

            this.Ctl_Serialize_ResetFolderChanges := this.gui.AddCheckbox("xs y+m" 6 " vSerialize_ResetFolderChanges", "文件夹变时重置")
            this.Ctl_Serialize_ResetFolderChanges.Value := 1

        }

        ;? 填充
        this.typeTab.UseTab("填充")
        {
            this.gui.AddGroupBox("w" this.tabWidth " r12", '')

            this.gui.AddGroupBox("xp" 15 " yp" 15 " r3 w390", '数字填充：')

            this.Ctl_Fill_ZeroPadding_Enable := this.gui.AddCheckbox("xp" 15 " yp" 30 " vFill_ZeroPadding_Enable Section", "补零填充长度：")
            this.gui.AddEdit("x+m yp-" 3 " w80")
            this.Ctl_Fill_ZeroPadding_Length := this.gui.AddUpDown("Range1-2147483647 vFill_ZeroPadding_Length", 1)
            this.Ctl_Fill_ZeroPadding_Length.OnEvent("Change", (*) => (this.Ctl_Fill_ZeroPadding_Enable.Value := true, this.Ctl_Fill_RemoveZeroPadding.Value := false))

            this.Ctl_Fill_RemoveZeroPadding := this.gui.AddCheckbox("xs y+m vFill_RemoveZeroPadding", "移除补零")

            this.Ctl_Fill_ZeroPadding_Enable.OnEvent("Click", (*) => this.Ctl_Fill_ZeroPadding_Enable.Value ? this.Ctl_Fill_RemoveZeroPadding.Value := false : "")
            this.Ctl_Fill_RemoveZeroPadding.OnEvent("Click", (*) => this.Ctl_Fill_RemoveZeroPadding.Value ? this.Ctl_Fill_ZeroPadding_Enable.Value := false : "")

            this.gui.AddGroupBox("xs-" 15 " y+m" 20 " r4.4 w390", '文本填充：')

            this.Ctl_Fill_TextPadding_Enable := this.gui.AddCheckbox("xp" 15 " yp" 30 " vFill_TextPadding_Enable Section", "文本填充长度：")
            this.gui.AddEdit("x+m" " yp-" 3 " w80")
            this.Ctl_Fill_TextPadding_Length := this.gui.AddUpDown("Range1-2147483647 vFill_TextPadding_Length", 1)
            this.Ctl_Fill_TextPadding_Length.OnEvent("Change", (*) => (this.Ctl_Fill_TextPadding_Enable.Value := true))

            this.gui.AddText("xs y+m" 2, "填充内容：")
            this.Ctl_Fill_TextPadding_Character := this.gui.AddEdit("x+m yp-" 3 " vFill_TextPadding_Character")

            this.gui.AddText("xs y+m" 2, "填充方向：")
            this.Ctl_Fill_TextPadding_Direction_Left := this.gui.AddRadio("x+m yp vFill_TextPadding_Direction_Left Group", "左")
            this.Ctl_Fill_TextPadding_Direction_Left.Value := 1
            this.Ctl_Fill_TextPadding_Direction_Right := this.gui.AddRadio("x+m yp vFill_TextPadding_Direction_Right", "右")

            this.Ctl_Fill_IgnoreExt := this.gui.AddCheckbox("xs y+m" 20 " vFill_IgnoreExt", "忽略扩展名")
            this.Ctl_Fill_IgnoreExt.Value := 1

        }

        ;? 正则
        this.typeTab.UseTab("正则")
        {
            this.gui.AddGroupBox("w" this.tabWidth " r12 Section", '配置：')

            this.gui.AddText("xp" 15 " yp" 25 " Section", "表达式：")
            this.Ctl_Regex_Regex := this.gui.AddEdit("x+m yp-" 2 " w330 vRegex_Regex")
            this.gui.AddText("xs y+m", "替换：")
            this.Ctl_Regex_ReplaceTo := this.gui.AddEdit("x+m" 13 " yp-" 2 " w330 vRegex_ReplaceTo")
            this.Ctl_Regex_IgnoreCase := this.gui.AddCheckbox("xp y+m vRegex_IgnoreCase", "忽略大小写")
            this.Ctl_Regex_IgnoreCase.Value := 0
            this.Ctl_Regex_IgnoreExt := this.gui.AddCheckbox("xp y+m vRegex_IgnoreExt", "忽略扩展名")
            this.Ctl_Regex_IgnoreExt.Value := 1
        }

        ;? 扩展名
        this.typeTab.UseTab("扩展名")
        {
            this.gui.AddGroupBox("w" this.tabWidth " r12 Section", '配置：')
            this.gui.AddText("xp" 15 " yp" 25 " Section", "新扩展名（无需.）")
            this.Ctl_Extension_NewExt := this.gui.AddEdit("xp y+m w390 vExtension_NewExt")
            this.Ctl_Extension_IgnoreExt := this.gui.AddCheckbox("xp y+m vExtension_IgnoreExt", "忽略扩展名")
        }

        this.typeTab.UseTab()

        ;* 底部按钮
        this.btnConfirm := this.gui.AddButton("y+4 w" this.tabWidth - this.gui.MarginY * 5 + 4 " +Default", "添加规则")
        this.btnConfirm.OnEvent("Click", (*) => this.Confirm())
        this.btnCancel := this.gui.AddButton('x+4', "取消")
        this.btnCancel.OnEvent("Click", (*) => this.Cancel())

        ;* 添加Tab事件
        this.typeTab.OnEvent('Change', (CtrlObj, Info) => this.OnTypeChange(CtrlObj, Info))

        ;* 添加窗口事件
        this.gui.OnEvent('Size', (guiObj, MinMax, wWidth, wHeight) => this.OnWindowResize(guiObj, MinMax, wWidth,
            wHeight))
        this.gui.OnEvent("Close", (*) => this.Close())

    }

    /**
     * * 回调窗口尺寸
     * @param {Gui} GuiObj 窗口Gui对象
     * @param {Integer} MinMax 窗口状态
     * @param {Integer} Width 窗口宽度
     * @param {Integer} Height 窗口高度
     */
    OnWindowResize(guiObj, MinMax, wWidth, wHeight) {
        ; 如果窗口被最小化 (-1)，则无需调整控件，直接返回
        if (MinMax == -1)
            return

        this.gui.GetClientPos(&wClientX, &wClientY, &wClientW, &wClientH)
        wMarginX := this.gui.MarginX
        wMarginY := this.gui.MarginY

        ;* 调整"插入"Tab下的第二列
        {
            gap := 4
            this.Ctl_Insert_Position_Index.GetPos(&xPI, &yPI, &wPI, &hPI)
            this.Ctl_Insert_Position_Before.GetPos(&xPB, &yPB, &wPB, &hPB)
            this.Ctl_Insert_Position_After.GetPos(&xPA, &yPA, &wPA, &hPA)
            this.Ctl_Insert_Position_Index_AnchorIndex_Edit.GetPos(, , &wPIAE, &hPIAE)
            xUnify := xPB + wPB + gap
            this.Ctl_Insert_Position_Index_AnchorIndex_Edit.Move(xUnify, yPI + (hPI - hPIAE) / 2)
            this.Ctl_Insert_Position_Index_AnchorIndex_Edit.GetPos(&xPIAE, &yPIAE, &wPIAE, &hPIAE)
            this.Ctl_Insert_Position_Index_AnchorIndex.GetPos(, , &wPIA, &hPIA)
            this.Ctl_Insert_Position_Index_AnchorIndex.Move(xPIAE + wPIAE, yPIAE)

            this.Ctl_Insert_Position_Index_ReverseIndex.GetPos(, , , &hPIR)
            this.Ctl_Insert_Position_Index_AnchorIndex.GetPos(&xPIA, &yPIA, &wPIA, &hPIA)
            this.Ctl_Insert_Position_Index_ReverseIndex.Move(xPIA + wPIA + gap, yPIA + (hPIA - hPIR) / 2)

            this.Ctl_Insert_Position_Before_AnchorText.GetPos(, , , &hPBA)
            this.Ctl_Insert_Position_Before_AnchorText.Move(xUnify, yPB + (hPB - hPBA) / 2)

            this.Ctl_Insert_Position_After_AnchorText.GetPos(, , , &hPAA)
            this.Ctl_Insert_Position_After_AnchorText.Move(xUnify, yPA + (hPA - hPAA) / 2)
        }

        ;* 调整底部按钮
        this.btnCancel.GetPos(&bclX, &bclY, &bclW, &bclH)
        ; 底部按钮的统一Y值
        bottomButtonY := wClientH - wMarginY - bclH
        this.btnCancel.Move(wClientW - wMarginX - bclW, bottomButtonY)

        this.btnCancel.GetPos(&bclX, &bclY, &bclW, &bclH)
        this.btnConfirm.GetPos(&bcmX, &bcmY, &bcmW, &bcmH)
        this.btnConfirm.Move(bclX - 4 - bcmW, bottomButtonY)

    }

    /**
     * * 点击标签页导致类型改变的的回调
     * @param {Gui.Tab} CtrlObj 
     * @param {Integer} index
     */
    OnTypeChange(CtrlObj, index) {
        ; 记录当前tab的下标
        this.nowTabIndex := CtrlObj.Value
    }

    /**
     * 解析表单信息成rule
     * @returns {RenameRule.InsertRule|RenameRule.ReplaceRule|RenameRule.RemoveRule|RenameRule.SerializeRule|RenameRule.FillRule|RenameRule.RegexRule|RenameRule.ExtensionRule|""}
     */
    ParseToRule() {
        type := RuleTypeMap.Get(this.types[this.nowTabIndex])
        submits := this.gui.Submit(false)
        ; Console.Debug("创建规则:" type, submits)

        rawObj := Map()
        ;* 选出当前规则类型相关的键值对
        for (k, v in submits.OwnProps()) {
            ; 跳过不是Type开头的参数的字段
            if ( not InStr(k, type)) {
                continue
            }
            k := StrReplace(k, type "_")
            ; rawObj[k] := v
            rawObj.Set(k, v)
        }

        rule := ""

        ;* 解析规则
        if (type == "Insert") {
            rule := RenameRule.InsertRule()
            ; 插入内容
            rule.Content := rawObj.Get("Content")
            ; 忽略扩展名
            rule.IgnoreExt := rawObj.Get("IgnoreExt")
            ; 忽略大小写
            rule.IgnoreCase := rawObj.Get("IgnoreCase")
            ; 解析位置
            for (k, v in rawObj.__Enum()) {
                if ( not InStr(k, "Position")) {
                    continue
                }

                k := StrReplace(k, "Position_")

                if ( not InStr(k, "_") && v) {
                    rule.Position := k
                }
            }
            ; 解析位置相关参数
            for (k, v in rawObj.__Enum()) {
                if ( not InStr(k, "Position")) {
                    continue
                }

                k := StrReplace(k, "Position_")

                if (InStr(k, "_")) {
                    if (k ~= "^(Before|After)") {
                        k := StrReplace(k, "_")
                        rule.%k% := v
                    }
                    if (k ~= "^Index") {
                        k := StrReplace(k, "Index_")
                        ; Console.Debug(k)
                        rule.%k% := v
                    }
                }
            }

        } else if (type == "Replace") {
            rule := RenameRule.ReplaceRule()
            ; 需要替换的内容
            rule.Match := rawObj.Get("Match")
            rule.ReplaceTo := rawObj.Get("ReplaceTo")
            rule.IgnoreCase := rawObj.Get("IgnoreCase")
            rule.IgnoreExt := rawObj.Get("IgnoreExt")

            ; 解析范围
            for (k, v in rawObj.__Enum()) {
                if ( not InStr(k, "Range")) {
                    continue
                }

                k := StrReplace(k, "Range_")

                if ( not InStr(k, "_") && v) {
                    rule.Range := k
                }
            }

        } else if (type == "Remove") {
            rule := RenameRule.RemoveRule()
            ; 需要移除的内容
            rule.Match := rawObj.Get("Match")
            rule.IgnoreCase := rawObj.Get("IgnoreCase")
            rule.IgnoreExt := rawObj.Get("IgnoreExt")
            ; 解析范围
            for (k, v in rawObj.__Enum()) {
                if ( not InStr(k, "Range")) {
                    continue
                }

                k := StrReplace(k, "Range_")

                if ( not InStr(k, "_") && v) {
                    rule.Range := k
                }
            }
        } else if (type == "Serialize") {
            rule := RenameRule.SerializeRule()
            rule.SequenceStart := rawObj.Get("SequenceStart")
            rule.SequenceStep := rawObj.Get("SequenceStep")
            rule.PaddingCount := rawObj.Get("PaddingCount")
            rule.ResetFolderChanges := rawObj.Get("ResetFolderChanges")
            rule.IgnoreCase := rawObj.Get("IgnoreCase")
            rule.IgnoreExt := rawObj.Get("IgnoreExt")

            ; 解析位置
            for (k, v in rawObj.__Enum()) {
                if ( not InStr(k, "Position")) {
                    continue
                }

                k := StrReplace(k, "Position_")

                if ( not InStr(k, "_") && v) {
                    rule.Position := k
                }
            }

            ; 解析位置相关参数
            for (k, v in rawObj.__Enum()) {
                if ( not InStr(k, "Position")) {
                    continue
                }

                k := StrReplace(k, "Position_")

                if (InStr(k, "_")) {
                    if (k ~= "^(Before|After)") {
                        k := StrReplace(k, "_")
                        rule.%k% := v
                    }
                    if (k ~= "^Index") {
                        k := StrReplace(k, "Index_")
                        ; Console.Debug(k)
                        rule.%k% := v
                    }
                }
            }

        } else if (type == "Fill") {
            rule := RenameRule.FillRule()
            rule.IgnoreExt := rawObj.Get("IgnoreExt")
            rule.RemoveZeroPadding := rawObj.Get("RemoveZeroPadding")

            for (k, v in rawObj.__Enum()) {
                list := StrSplit(k, "_")
                ; Console.Debug(list)

                ; 补零填充
                if (InStr(k, "ZeroPadding_")) {
                    if (list.Length == 2) {
                        rule.ZeroPadding.%list[2]% := v
                    }
                }

                ; 文本填充
                if (InStr(k, "TextPadding_")) {
                    if (list.Length == 2) {
                        Console.Debug(list, v)
                        ;
                        rule.TextPadding.%list[2]% := v
                    } else if (list.Length == 3) {
                        if (v) {
                            ; Console.Debug(list, v)
                            rule.TextPadding.%list[2]% := list[3]
                        }
                    }
                }
            }

        } else if (type == "Regex") {
            rule := RenameRule.RegexRule()
            rule.Regex := rawObj.Get("Regex")
            rule.ReplaceTo := rawObj.Get("ReplaceTo")
            rule.IgnoreCase := rawObj.Get("IgnoreCase")
            rule.IgnoreExt := rawObj.Get("IgnoreExt")

        } else if (type == "Extension") {
            rule := RenameRule.ExtensionRule()
            rule.NewExt := rawObj.Get("NewExt")
            rule.IgnoreExt := rawObj.Get("IgnoreExt")
        }

        return rule
    }

    /**
     * 投射规则信息到界面
     * @param {RenameRule.InsertRule|RenameRule.ReplaceRule|RenameRule.RemoveRule|RenameRule.SerializeRule|RenameRule.FillRule|RenameRule.RegexRule|RenameRule.ExtensionRule|""|""} rule 规则对象
     */
    MapRuleGUI(rule) {
        ; Console.Debug("准备显示规则：", rule)
        switch (rule.Type) {
            case "Insert":
                /** @param {InsertRule} rule */
                this.Ctl_Insert_Content.Value := rule.Content
                this.%"Ctl_Insert_Position_" rule.Position%.Value := 1
                this.Ctl_Insert_Position_Index_AnchorIndex.Value := rule.AnchorIndex
                this.Ctl_Insert_Position_Before_AnchorText.Value := rule.BeforeAnchorText
                this.Ctl_Insert_Position_After_AnchorText.Value := rule.AfterAnchorText
                this.Ctl_Insert_Position_Index_ReverseIndex.Value := rule.ReverseIndex
                this.Ctl_Insert_IgnoreCase.Value := rule.IgnoreCase
                this.Ctl_Insert_IgnoreExt.Value := rule.IgnoreExt
            case "Replace":
                this.Ctl_Replace_Match.Value := rule.Match
                this.Ctl_Replace_ReplaceTo.Value := rule.ReplaceTo
                this.%"Ctl_Replace_Range_" rule.Range%.Value := 1
                this.Ctl_Replace_IgnoreCase.Value := rule.IgnoreCase
                this.Ctl_Replace_IgnoreExt.Value := rule.IgnoreExt
            case "Remove":
                this.Ctl_Remove_Match.Value := rule.Match
                this.%"Ctl_Remove_Range_" rule.Range%.Value := 1
                this.Ctl_Remove_IgnoreCase.Value := rule.IgnoreCase
                this.Ctl_Remove_IgnoreExt.Value := rule.IgnoreExt
            case "Serialize":
                this.%"Ctl_Serialize_Position_" rule.Position% := 1
                this.Ctl_Serialize_IgnoreCase.Value := rule.IgnoreCase
                this.Ctl_Serialize_IgnoreExt.Value := rule.IgnoreExt
                this.Ctl_Serialize_Position_Index_AnchorIndex.Value := rule.AnchorIndex
                this.Ctl_Serialize_Position_Index_ReverseIndex.Value := rule.ReverseIndex
                this.Ctl_Serialize_Position_Before_AnchorText.Value := rule.BeforeAnchorText
                this.Ctl_Serialize_Position_After_AnchorText.Value := rule.AfterAnchorText
                this.Ctl_Serialize_SequenceStart.Value := rule.SequenceStart
                this.Ctl_Serialize_SequenceStep.Value := rule.SequenceStep
                this.Ctl_Serialize_PaddingCount.Value := rule.PaddingCount
                this.Ctl_Serialize_ResetFolderChanges.Value := rule.ResetFolderChanges
            case "Fill":
                this.Ctl_Fill_ZeroPadding_Enable := rule.ZeroPadding.Enable
                this.Ctl_Fill_ZeroPadding_Length := rule.ZeroPadding.Length
                this.Ctl_Fill_RemoveZeroPadding := rule.RemoveZeroPadding
                this.Ctl_Fill_TextPadding_Enable := rule.TextPadding.Enable
                this.Ctl_Fill_TextPadding_Character := rule.TextPadding.Character
                this.Ctl_Fill_TextPadding_Length := rule.TextPadding.Length
                this.%"Ctl_Fill_TextPadding_Direction_" rule.TextPadding.Direction% := 1
                this.Ctl_Fill_IgnoreExt.Value := rule.IgnoreExt
            case "Regex":
                Console.Debug(rule)
                this.Ctl_Regex_Regex.Value := rule.Regex
                this.Ctl_Regex_ReplaceTo.Value := rule.ReplaceTo
                this.Ctl_Regex_IgnoreCase.Value := rule.IgnoreCase
                this.Ctl_Regex_IgnoreExt.Value := rule.IgnoreExt
            case "Extension":
                this.Ctl_Extension_NewExt.Value := rule.NewExt
                this.Ctl_Extension_IgnoreExt := rule.IgnoreExt
        }
    }

    ;! 确认提交规则
    Confirm() {
        rule := this.ParseToRule()

        ; Console.Debug("添加规则：", rule)
        if (rule) {
            if (this.mode == "create") {
                ; 如果规则有效则更新父窗口以及父类
                this.parent.AddRule(rule)
            } else if (this.mode == "edit") {
                if (this.editRuleIndex) {
                    ; Console.Debug("编辑成功！ ", rule)
                    this.parent.UpdateRule(rule, this.editRuleIndex)
                }
            }
        } else {
            Console.Debug("规则解析失败")
        }

        this.Close()
    }

    ; 取消操作
    Cancel() {
        ; Console.Debug("取消")
        this.Close()
    }

    /**
     * 显示窗口
     * @param {"create"|"edit"} mode 模式
     * @param {Integer}  disabledParent 显示窗口期间是否禁止父窗口操作
     * @param {Integer}  editIndex 编辑的
     */
    Show(mode := "create", disabledParent := false) {
        this.mode := mode ; 记录模式
        this.UpdateMode()
        ; 判断是否禁止父窗口操作
        if (disabledParent)
            this.parent.gui.Opt("+Disabled")

        this.gui.Opt("+Owner" this.parent.gui.Hwnd)
        this.gui.Show()
        this.isShow := true

        if (mode == "create") {
            this.typeTab.Choose(this.nowTabIndex)
        } else if (mode == "edit") {
            if (!this.editRuleIndex) {
                Console.Debug("没有指定要编辑的规则索引")
                return
            }
            ; 拿到要编辑的规则
            rule := this.parent.rules[this.editRuleIndex]
            ; Console.Debug("Show编辑规则：" this.editRuleIndex " , ", rule)
            this.typeTab.Choose(this.nowTabIndex)
            this.MapRuleGUI(rule)
        }

    }

    ; 根据模式进行相应调整
    UpdateMode() {
        if (this.mode == "create") {
            this.gui.Title := "创建规则"
            this.btnConfirm.Text := "创建"
        } else if (this.mode == "edit") {
            this.gui.Title := "编辑规则"
            this.btnConfirm.Text := "保存"
        }
    }

    Close() {
        this.gui.Hide()
        this.isShow := false

        this.parent.gui.Opt("-Disabled")
        parentHwnd := this.parent.gui.Hwnd
        if (WinExist("ahk_id" parentHwnd)) {
            WinActivate("ahk_id" parentHwnd)
        }
        ; 关闭窗口后将"编辑索引"置为0
        this.editRuleIndex := 0
        return 1
    }

    __Delete() {
        this.gui.Destroy()
    }
}

class RenameRule {
    ; 基础规则类
    class BaseRule {
        Type := ""
        /** 忽略扩展名 */
        IgnoreExt := true

        ; 获取规则名
        TypeName {
            get {
                return RuleTypeReverseMap.Get(this.Type)
            }
        }

        ; 获取规则描述
        Description {
            get {
                return ""
            }
        }
    }

    ;! 插入规则
    class InsertRule extends RenameRule.BaseRule {
        Type := "Insert"
        ; 插入内容
        Content := ""
        ; 插入位置 'Prefix' | 'Suffix' | 'Index' | 'After' | 'Before' | 'Replace'
        Position := "prefix"
        ; Index的锚点位置索引
        AnchorIndex := 1
        ; Index是否反向(false为：从左到右)
        ReverseIndex := false
        ; Before锚点文本
        BeforeAnchorText := ''
        ; After的锚点文本
        AfterAnchorText := ''
        ; 忽略大小写
        IgnoreCase := false
        ; 全字匹配
        IsExactMatch := false

        /**
         * * 构造函数
         * @param {Map<RenameRule.InsertRule>} rawRule 原始Rule对象，需要从Map对象解析成Rule对象的时候才需要传入
         */
        __New(rawRule?) {

            if (IsSet(rawRule)) {
                this.Content := rawRule.Get("Content", "")
                this.Position := rawRule.Get("Position", "Preset")
                this.AnchorIndex := rawRule.Get("AnchorIndex", 1)
                this.ReverseIndex := rawRule.Get("ReverseIndex", false)
                this.BeforeAnchorText := rawRule.Get("BeforeAnchorText", "")
                this.AfterAnchorText := rawRule.Get("AfterAnchorText", "")
                this.IgnoreCase := rawRule.Get("IgnoreCase", false)
                this.IsExactMatch := rawRule.Get("IsExactMatch", false)
                this.IgnoreExt := rawRule.Get("IgnoreExt", true)
            }
        }

        /** @type {String} 规则描述*/
        Description {
            get {
                desc := ""
                if (this.Type == "Insert") {
                    desc .= "插入 `"" this.Content "`" "

                    if (this.Position == "Prefix" || this.Position == "Suffix") {
                        direction := this.Position == "Prefix" ? "前" : "后"
                        desc .= "作为" direction "缀"
                    }

                    if (this.Position == "Index") {
                        desc .= "在位置 " this.AnchorIndex " 处"
                        if (this.ReverseIndex) {
                            desc .= "（从右到左）"
                        }
                    }

                    if (this.Position == "Before" || this.Position == "After") {
                        desc .= "在 `"" (this.Position == "Before" ? this.BeforeAnchorText : this.AfterAnchorText) "`""
                        desc .= this.IgnoreCase ? "（不区分大小写）" : ""
                        desc .= this.Position == "Before" ? "之前" : "之后"
                    }

                    if (this.Position == "Replace") {
                        desc .= "替换当前文件名"
                    }

                    if (this.IgnoreExt) {
                        desc .= "（忽略扩展名）"
                    }
                }
                return desc
            }
            set {

            }
        }
    }

    ;! 替换规则
    class ReplaceRule extends RenameRule.BaseRule {
        Type := "Replace"
        /** 需替换的内容 */
        Match := ""
        /** 替换为 */
        ReplaceTo := ""
        /** 替换范围  'All' | 'First' | 'Last' */
        Range := 'All'
        /** 忽略大小写 */
        IgnoreCase := false
        /** 全字匹配 */
        IsExactMatch := false

        /**
         * * 构造函数
         * @param {Map<RenameRule.ReplaceRule>} rawRule 原始Rule对象，需要从Map对象解析成Rule对象的时候才需要传入
         */
        __New(rawRule?) {

            if (IsSet(rawRule)) {
                this.Match := rawRule.Get("Match", "")
                this.ReplaceTo := rawRule.Get("ReplaceTo", "")
                this.Range := rawRule.Get("Range", "All")
                this.IgnoreCase := rawRule.Get("IgnoreCase", false)
                this.IsExactMatch := rawRule.Get("IsExactMatch", false)
                this.IgnoreExt := rawRule.Get("IgnoreExt", true)
            }
        }

        /** @type {String} 规则描述*/
        Description {
            get {
                rangeMap := {
                    All: '全部',
                    First: '首个',
                    Last: '末个'
                }

                desc := "替换" rangeMap.%this.Range% " `"" this.Match "`" 替换为 `"" this.ReplaceTo "`""

                ; 最后判断：是否忽略扩展名、区分大小写
                if (this.IgnoreExt) {
                    desc .= "（忽略扩展名）"
                }
                if (this.IgnoreCase) {
                    desc .= "（不区分大小写）"
                }
                return desc
            }
            set {

            }
        }
    }

    ;! 删除规则
    class RemoveRule extends RenameRule.BaseRule {
        Type := "Remove"
        /** 要删除的内容 */
        Match := ""
        /** 要删除的范围 'All' | 'First' | 'Last' */
        Range := 'All'
        /** 忽略大小写*/
        IgnoreCase := false
        /** 全字匹配 */
        IsExactMatch := false

        /**
         * * 构造函数
         * @param {Map<RenameRule.RemoveRule>} rawRule 原始Rule对象，需要从Map对象解析成Rule对象的时候才需要传入
         */
        __New(rawRule?) {

            if (IsSet(rawRule)) {
                this.Match := rawRule.Get("Match", "")
                this.Range := rawRule.Get("Range", "All")
                this.IgnoreCase := rawRule.Get("IgnoreCase", false)
                this.IsExactMatch := rawRule.Get("IsExactMatch", false)
                this.IgnoreExt := rawRule.Get("IgnoreExt", true)
            }
        }

        /** @type {String} 规则描述*/
        Description {
            get {
                rangeMap := {
                    All: '全部',
                    First: '首个',
                    Last: '末个'
                }

                desc := "移除" rangeMap.%this.Range% " `"" this.Match "`""
                ; 最后判断：是否忽略扩展名、区分大小写
                if (this.IgnoreExt) {
                    desc .= "（忽略扩展名）"
                }
                if (this.IgnoreCase) {
                    desc .= "（不区分大小写）"
                }
                return desc
            }
            set {

            }
        }
    }

    ;! 序列化规则
    class SerializeRule extends RenameRule.BaseRule {
        Type := "Serialize"
        /** 要插入序列的位置 'Prefix' | 'Suffix' | 'Index' | 'After' | 'Before' | 'Replace' */
        Position := "Prefix"
        ; Index的锚点位置索引
        AnchorIndex := 1
        ; Index是否反向(false为：从左到右)
        ReverseIndex := false
        ; Before锚点文本
        BeforeAnchorText := ""
        ; After的锚点文本
        AfterAnchorText := ""
        /** 序列起始值 */
        SequenceStart := 1
        /** 序列步长 */
        SequenceStep := 1
        /** 补零数量 (-1:自动填充 0：不进行补零 >0:填充指定数量的0) */
        PaddingCount := -1
        /** 文件夹变更重置 */
        ResetFolderChanges := true
        /** 忽略大小写 (当 anchorText 生效时, 对 anchorText 也生效) */
        IgnoreCase := false
        /** 全字匹配 (当 anchorText 生效时, 对 anchorText 也生效) */
        IsExactMatch := false

        /**
         * * 构造函数
         * @param {Map<RenameRule.SerializeRule>} rawRule 原始Rule对象，需要从Map对象解析成Rule对象的时候才需要传入
         */
        __New(rawRule?) {

            if (IsSet(rawRule)) {
                this.Position := rawRule.Get("Position", "Prefix")
                this.AnchorIndex := rawRule.Get("AnchorIndex", 1)
                this.ReverseIndex := rawRule.Get("ReverseIndex", false)
                this.BeforeAnchorText := rawRule.Get("BeforeAnchorText", "")
                this.AfterAnchorText := rawRule.Get("AfterAnchorText", "")
                this.SequenceStart := rawRule.Get("SequenceStart", 1)
                this.SequenceStep := rawRule.Get("SequenceStep", 1)
                this.PaddingCount := rawRule.Get("PaddingCount", -1)
                this.ResetFolderChanges := rawRule.Get("ResetFolderChanges", true)
                this.IgnoreCase := rawRule.Get("IgnoreCase", false)
                this.IsExactMatch := rawRule.Get("IsExactMatch", false)
                this.IgnoreExt := rawRule.Get("IgnoreExt", true)

            }
        }


        /** @type {String} 规则描述*/
        Description {
            get {
                desc := "增量序列化起始于 " this.SequenceStart " 增量 " this.SequenceStep ""
                if (this.ResetFolderChanges) {
                    desc .= "（文件夹变更时重置）"
                }
                if (this.PaddingCount > 0) {
                    desc .= " 补足长度为 " this.PaddingCount " 位"
                } else if (this.PaddingCount == -1) {
                    desc .= " 补足长度自动识别"
                }
                ; 位置
                if (this.Position == "Prefix" || this.Position == "Suffix") {
                    direction := this.Position == "Prefix" ? "前" : "后"
                    desc .= " 作为" direction "缀"
                }

                if (this.Position == "Index") {
                    desc .= " 序列插入到 " this.AnchorIndex " 处"
                    if (this.ReverseIndex) {
                        desc .= "（位置索引从右到左）"
                    }
                }

                if (this.Position == "Before" || this.Position == "After") {
                    desc .= " 序列插入到 `"" (this.Position == "Before" ? this.BeforeAnchorText : this.AfterAnchorText) "`""
                    desc .= this.IgnoreCase ? "（不区分大小写）" : ""
                    desc .= this.Position == "Before" ? "之前" : "之后"
                }

                if (this.Position == "Replace") {
                    desc .= " 替换当前文件名"
                }

                if (this.IgnoreExt) {
                    desc .= "（忽略扩展名）"
                }
                return desc
            }
            set {

            }
        }
    }

    ;! 填充规则
    class FillRule extends RenameRule.BaseRule {
        Type := "Fill"

        /** 补零填充 */
        ZeroPadding := {
            /** 是否启用 */
            Enable: false,
            /** 填充长度*/
            Length: 3
        }

        /** 移除补零 */
        RemoveZeroPadding := false

        /** 文本填充 */
        TextPadding := {
            /** 是否启用 */
            Enable: false,
            /** 填充字符 */
            Character: "",
            /** 填充长度*/
            Length: 3,
            /** 填充方向 'Left' | 'Right' */
            Direction: 'Left'
        }

        /**
         * * 构造函数
         * @param {Map<RenameRule.FillRule>} rawRule 原始Rule对象，需要从Map对象解析成Rule对象的时候才需要传入
         */
        __New(rawRule?) {

            if (IsSet(rawRule)) {
                ZeroPadding := rawRule.Get("ZeroPadding", { Enable: false, Length: 3 })
                this.ZeroPadding.Enable := ZeroPadding.Get("ZeroPadding", false)
                this.ZeroPadding.Length := ZeroPadding.Get("Length", 3)

                this.RemoveZeroPadding := rawRule.Get("RemoveZeroPadding", false)

                TextPadding := rawRule.Get("TextPadding", { Enable: false, Character: "", Length: 3, Direction: "Left" })
                this.TextPadding.Enable := TextPadding.Get("Enable", false)
                this.TextPadding.Character := TextPadding.Get("Character", "")
                this.TextPadding.Length := TextPadding.Get("Length", 3)
                this.TextPadding.Direction := TextPadding.Get("Direction", "Left")

                this.IgnoreExt := rawRule.Get("IgnoreExt", true)
            }
        }

        /** @type {String} 规则描述*/
        Description {
            get {
                desc := ""
                ; 分情况讨论
                if (this.RemoveZeroPadding) {
                    desc .= "移除补零"
                } else if (this.ZeroPadding.Enable) {
                    desc .= "补零填充，长度 " this.ZeroPadding.Length
                }
                if (this.TextPadding.Enable) {
                    directionMap := {
                        Left: "左侧",
                        Right: "右侧"
                    }
                    if (this.ZeroPadding.Enable || this.RemoveZeroPadding) desc .= "；"
                        desc .=
                            "文本填充，填充内容 `"" this.TextPadding.Character "`" ，长度 " this.TextPadding.Length "，" directionMap.%this.TextPadding.Direction%
                }
                ; 判断是否忽略扩展名
                if (this.ignoreExt) {
                    desc .= "（忽略扩展名）"
                }
                return desc
            }
            set {

            }
        }
    }

    ;! 正则规则
    class RegexRule extends RenameRule.BaseRule {
        Type := "Regex"
        /** 正则表达式 */
        Regex := ""
        /** 替换表达式 */
        ReplaceTo := ""
        /** 忽略大小写 */
        IgnoreCase := false
        /** 全字匹配 */
        IsExactMatch := false


        /**
         * * 构造函数
         * @param {Map<RenameRule.RegexRule>} rawRule 原始Rule对象，需要从Map对象解析成Rule对象的时候才需要传入
         */
        __New(rawRule?) {
            if (IsSet(rawRule)) {
                this.Regex := rawRule.Get("Regex", "")
                this.ReplaceTo := rawRule.Get("ReplaceTo", "")
                this.IgnoreCase := rawRule.Get("IgnoreCase", false)
                this.IsExactMatch := rawRule.Get("IsExactMatch", false)
                this.IgnoreExt := rawRule.Get("IgnoreExt", true)
            }
        }

        /** @type {String} 规则描述*/
        Description {
            get {
                desc := "替换表达式 `"" this.Regex "`" 替换为 `"" this.ReplaceTo "`""

                if (this.IgnoreCase) {
                    desc .= "（不区分大小写）"
                }
                if (this.IgnoreExt) {
                    desc .= "（忽略扩展名）"
                }
                return desc
            }
            set {

            }
        }
    }

    ;! 扩展名
    class ExtensionRule extends RenameRule.BaseRule {
        Type := "Extension"
        /** 新扩展名 (无需添加.符号) */
        NewExt := ""

        /**
         * * 构造函数
         * @param {Map<RenameRule.ExtensionRule>} rawRule 原始Rule对象，需要从Map对象解析成Rule对象的时候才需要传入
         */
        __New(rawRule?) {
            if (IsSet(rawRule)) {
                this.NewExt := rawRule.Get("NewExt", "")
                this.IgnoreExt := rawRule.Get("IgnoreExt", false)
            }
        }

        /** @type {String} 规则描述*/
        Description {
            get {
                if (this.NewExt == '')
                    return '移除扩展名'
                desc := "修改扩展名为 `"" this.NewExt "`""
                if (this.IgnoreExt) {
                    desc .= "（添加到原始文件名）"
                }
                return desc
            }
            set {

            }
        }
    }

}


class ReNameFile {
    /**
     * * 构造
     * @param {String} path 路径
     */
    __New(path) {
        SplitPath(path, &name, &dir, &ext, &nameNoExt, &drive)

        this.Path := path
        this.Name := name
        this.Dir := dir
        this.Ext := ext
        this.Drive := drive

        ;? 默认让新名称等于旧名称
        this.NewName := name

        ;? 默认允许被修改
        this.Enable := true


        ;! 定义自有的动态属性（为了能被.OwnProps()方法枚举到）

        ; 文件名(不含扩展名)
        this.DefineProp("NameNoExt", { Get: GetNameNoExt })
        GetNameNoExt(*) {
            SplitPath(this.Name, &name, &dir, &ext, &nameNoExt, &drive)
            return nameNoExt
        }

        ; 是否是目录
        this.DefineProp("IsDirectory", { Get: GetIsDirectory })
        GetIsDirectory(*) {
            attrib := DirExist(this.Path)
            return attrib ~= "[D]"
        }

        ; 属性（为空则说明路径不存在）
        this.DefineProp("Attribute", { Get: GetAttribute })
        GetAttribute(*) {
            attrib := ""
            if (this.IsDirectory) {
                attrib := DirExist(this.Path)
            } else {
                attrib := FileExist(this.Path)
            }
            return attrib
        }

        ; 新文件名(不含扩展名)
        this.DefineProp("NewNameNoExt", { Get: GetNewNameNoExt })
        GetNewNameNoExt(*) {
            SplitPath(this.NewName, , , , &nameNoExt)
            return nameNoExt
        }

        ; 新路径
        this.DefineProp("NewPath", { Get: GetNewPath })
        GetNewPath(*) {
            return this.Dir "\" this.NewName
        }

        ; 新属性（用于判断是否冲突）
        this.DefineProp("NewAttribute", { Get: GetNewAttribute })
        GetNewAttribute(*) {
            if (this.IsDirectory) {
                return DirExist(this.NewPath)
            } else {
                return FileExist(this.NewPath)
            }
        }

        ;! 备份一份初始数据
        this.__InitData := ReNameFile.Backup(this)
    }


    ;* 初始化信息（将旧名称赋值给新名称）
    InitInfo() {
        this.NewName := this.__InitData.Name
    }

    ;? 重置数据回到最初版本
    Reset() {
        this.Path := this.__InitData.Path
        this.Name := this.__InitData.Name
        this.Dir := this.__InitData.Dir
        this.Ext := this.__InitData.Ext
        this.Dir := this.__InitData.Dir
    }

    ; 备份子类
    class Backup {
        /**
         * 构造
         * @param {ReNameFile} data ReNameFile 对象
         */
        __New(data) {
            this.Name := data.Name
            this.Dir := data.Dir
            this.IsDirectory := data.IsDirectory
            this.Attribute := data.Attribute
            this.Drive := data.Drive

            this.DefineProp("Path", { Get: GetPath })
            GetPath(*) {
                return this.Dir "\" this.Name
            }

            this.DefineProp("NameNoExt", { Get: GetNameNoExt })
            GetNameNoExt(*) {
                SplitPath(this.Name, , , , &nameNoExt)
                return nameNoExt
            }

            this.DefineProp("Ext", { Get: GetExt })
            GetExt(*) {
                SplitPath(this.Name, , , &Ext)
                return Ext
            }
        }
    }
}

/**
 * ! 重命名器类
 */
class ReName {
    /**
     * f 插入
     * @param {Array<ReNameFile>} list 待重命名列表
     * @param {InsertRule} rule 规则对象
     */
    static Insert(list, rule := "") {
        ; Console.Debug(list.Length)
        ; 拿到要插入的内容
        content := rule.Content

        for (item in list) {
            ; 跳过不允许被修改的项目
            if (!item.Enable)
                continue

            ; 拿到文件名(通过IgnoreCase判断是否包含扩展名)
            test := rule.IgnoreExt ? item.NewNameNoExt : item.NewName

            ;? AHK 的switch语句不能使用break跳出，case并不会贯穿
            switch (rule.Position) {
                case "Prefix":
                    test := content . test
                case "Suffix":
                    test := test . content
                case "Index":
                    test := StringUtils.InsertByIndex(test, content, rule.AnchorIndex, rule.ReverseIndex)
                case "Before":
                    test := StringUtils.InsertByMatch(test, content, rule.BeforeAnchorText, "Before", {
                        ignoreCase: rule.IgnoreCase,
                        isExactMatch: rule.IsExactMatch
                    })
                case "After":
                    test := StringUtils.InsertByMatch(test, content, rule.AfterAnchorText, "After", {
                        ignoreCase: rule.IgnoreCase,
                        isExactMatch: rule.IsExactMatch
                    })
                case "Replace":
                    test := content
            }

            ; 最后判断是否加上扩展名
            item.NewName := test . (rule.IgnoreExt ? "." item.Ext : "")
        }

    }

    /**
     * f 替换
     * @param {Array<ReNameFile>} list 待重命名列表
     * @param {ReplaceRule} rule 规则对象
     */
    static Replace(list, rule := "") {
        ; Console.Debug(list.Length)
        ; 拿到要插入的内容
        match := rule.Match
        replaceTo := rule.ReplaceTo
        range := rule.Range

        for (item in list) {
            ; 跳过不允许被修改的项目
            if (!item.Enable)
                continue

            ; 拿到文件名(通过IgnoreCase判断是否包含扩展名)
            test := rule.IgnoreExt ? item.NewNameNoExt : item.NewName

            test := StringUtils.Replace(test, match, replaceTo, range, {
                ignoreCase: rule.IgnoreCase,
                IsExactMatch: rule.IsExactMatch
            })

            ; 最后判断是否加上扩展名
            item.NewName := test . (rule.IgnoreExt ? "." item.Ext : "")
        }

    }

    /**
     * f 移除
     * @param {Array<ReNameFile>} list 待重命名列表
     * @param {RemoveRule} rule 规则对象
     */
    static Remove(list, rule := "") {
        ; Console.Debug(list.Length)
        ; 拿到要插入的内容
        match := rule.Match
        range := rule.Range

        for (item in list) {
            ; 跳过不允许被修改的项目
            if (!item.Enable)
                continue

            ; 拿到文件名(通过IgnoreCase判断是否包含扩展名)
            test := rule.IgnoreExt ? item.NewNameNoExt : item.NewName

            test := StringUtils.Remove(test, match, range, {
                ignoreCase: rule.IgnoreCase,
                IsExactMatch: rule.IsExactMatch
            })

            ; 最后判断是否加上扩展名
            item.NewName := test . (rule.IgnoreExt ? "." item.Ext : "")
        }
    }

    /**
     * f 序列化
     * @param {Array<ReNameFile>} list 待重命名列表
     * @param {SerializeRule} rule 规则对象
     */
    static Serialize(list, rule := "") {
        ; 计算最大补零长度
        autoPaddingLength := Floor(Log(Abs(list.length * rule.SequenceStep))) + (rule.SequenceStep > 0 ? 1 : 2)
        ; 当前目录
        currentDir := ""
        ; 序列计数
        num := 0
        ;依次处理每个文件
        for (item in list) {
            ; 跳过不允许被修改的项目
            if (!item.Enable)
                continue

            ; 如果当前目录currentDir为空，或者当前目录与item所在目录不同，则记录当前目录
            if (!currentDir || currentDir != item.Dir) {
                currentDir := item.Dir
                ; 判断是否重置序列
                if (rule.ResetFolderChanges)
                    num := 0
            }
            ; 生成序列
            sequence := "" Abs(num++ * rule.SequenceStep + rule.SequenceStart)
            ; 判断是否补零
            paddingCount := 0
            if (rule.PaddingCount > 0) {
                ; 填充到指定长度
                paddingCount := rule.PaddingCount
                sequence := StringUtils.Padding(sequence, "0", paddingCount)
            } else if (rule.PaddingCount <= -1) {
                ; 自动判断填充长度
                sequence := StringUtils.Padding(sequence, "0", Integer(sequence) != 0 ? autoPaddingLength : autoPaddingLength + 1)
            }
            ;判断是递增还是递减
            if (rule.SequenceStep < 0 && Integer(sequence) != 0) {
                ; 如果是序列为负数则加上负号
                sequence := "-" sequence
            }

            ; 拿到文件名(通过IgnoreCase判断是否包含扩展名)
            test := rule.IgnoreExt ? item.NewNameNoExt : item.NewName

            ;? AHK 的switch语句不能使用break跳出，case并不会贯穿
            switch (rule.Position) {
                case "Prefix":
                    test := sequence . test
                case "Suffix":
                    test := test . sequence
                case "Index":
                    test := StringUtils.InsertByIndex(test, sequence, rule.AnchorIndex, rule.ReverseIndex)
                case "Before":
                    test := StringUtils.InsertByMatch(test, sequence, rule.BeforeAnchorText, "Before", {
                        ignoreCase: rule.IgnoreCase,
                        isExactMatch: rule.IsExactMatch
                    })
                case "After":
                    test := StringUtils.InsertByMatch(test, sequence, rule.AfterAnchorText, "After", {
                        ignoreCase: rule.IgnoreCase,
                        isExactMatch: rule.IsExactMatch
                    })
                case "Replace":
                    test := sequence
            }

            ; 最后判断是否加上扩展名
            item.NewName := test . (rule.IgnoreExt ? "." item.Ext : "")
        }
    }


    /**
     * f 填充
     * @param {Array<ReNameFile>} list 待重命名列表
     * @param {FillRule} rule 规则对象
     */
    static Fill(list, rule := "") {
        for (item in list) {
            ; 跳过不允许被修改的项目
            if (!item.Enable)
                continue

            ; 拿到文件名(通过IgnoreCase判断是否包含扩展名)
            test := rule.IgnoreExt ? item.NewNameNoExt : item.NewName

            ;* 补零填充和移除补零
            {
                if (rule.RemoveZeroPadding) {
                    test := StringUtils.RemoveZeroPaddingString(test)
                } else if (rule.ZeroPadding.Enable) {
                    test := StringUtils.ZeroPadding(test, rule.ZeroPadding.Length)
                }
            }

            ;* 文本填充
            {
                test := StringUtils.Padding(test, rule.TextPadding.Character, rule.TextPadding.Length, rule.TextPadding.Direction)
            }


            ; 最后判断是否加上扩展名
            item.NewName := test . (rule.IgnoreExt ? "." item.Ext : "")
        }
    }

    /**
     * f 正则
     * @param {Array<ReNameFile>} list 待重命名列表
     * @param {RegexRule} rule 规则对象
     */
    static Regex(list, rule := "") {
        for (item in list) {
            ; 跳过不允许被修改的项目
            if (!item.Enable)
                continue

            ; 拿到文件名(通过IgnoreCase判断是否包含扩展名)
            test := rule.IgnoreExt ? item.NewNameNoExt : item.NewName

            test := StringUtils.RegexReplace(test, rule.Regex, rule.ReplaceTo, {
                ignoreCase: rule.IgnoreCase,
                isExactMatch: rule.IsExactMatch
            })

            ; 最后判断是否加上扩展名
            item.NewName := test . (rule.IgnoreExt ? "." item.Ext : "")
        }
    }

    /**
     * f 扩展名
     * @param {Array<ReNameFile>} list 待重命名列表
     * @param {ExtensionRule} rule 规则对象
     */
    static Extension(list, rule := "") {
        for (item in list) {
            ; 跳过不允许被修改的项目和文件夹
            if (!item.Enable || item.IsDirectory)
                continue

            ; 拿到文件名(通过IgnoreCase判断是否包含扩展名)
            test := rule.IgnoreExt ? item.NewNameNoExt : item.NewName

            if (rule.ignoreExt) {
                ; 如果忽略拓展名则直接在原扩展名后面拼接新扩展名
                test .= "." rule.NewExt
            } else {
                ; 如果不忽略则替换原本的扩展名
                SplitPath(test, , , , &nameNoExt)
                test := nameNoExt "." rule.NewExt
            }

            item.NewName := test
        }
    }
}