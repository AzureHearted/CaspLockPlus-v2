#Requires AutoHotkey v2.0

;! 提示窗口
class UITips {
    gui := Gui('+AlwaysOnTop -Caption +ToolWindow')
    ; 窗口是否显示
    isShow := false
    ; 窗口透明度
    transparent := 200
    ;图标Map
    iconMap := Map()

    /**
     * @param content 要展示的内容
     */
    __New(content := "", title := "提示", defColumns := ['提示']) {
        this.content := content
        this.title := title

        scale := A_ScreenDPI / 96

        this.gui.MarginX := 10
        this.gui.MarginY := 10
        this.gui.SetFont('s' 10 * scale, 'Segoe UI')
        this.titleControl := this.gui.AddText('r1.2 Center', this.title)
        this.titleControl.SetFont('s' 10 * scale * 1.2 ' bold')
        this.listViewControl := this.gui.AddListView("xm r8 ReadOnly NoSort NoSortHdr -E0x200", defColumns)

        ; 创建图像列表, 这样 ListView 才可以显示图标:
        this.ImageListID := IL_Create(10)

        ; 计算 SHFILEINFO 结构需要的缓冲大小.
        this.sfi_size := A_PtrSize + 688
        this.sfi := Buffer(this.sfi_size)

        ; 将图像列表附加到 ListView 上, 这样它就可以在以后显示图标:
        this.listViewControl.SetImageList(this.ImageListID)

        ; 事件绑定
        this.gui.OnEvent('Close', (*) => (this.isShow := false))
    }

    ; 显示窗口
    Show() {
        if (this.isShow) ;* 防止重复显示
            return
        this.isShow := true

        this.listViewControl.ModifyCol(1, 'AutoHdr')
        this.listViewControl.ModifyCol(2, 'AutoHdr Logical Sort')
        ; this.listViewControl.Redraw()

        this.gui.Show('NoActivate AutoSize')

        ; 设置窗口样式
        hwnd := this.gui.Hwnd
        WinSetTransparent(this.transparent, 'ahk_id' hwnd)
    }

    ; 隐藏窗口
    Hidden() {
        WinClose(this.gui)
        this.ClearTips()
    }

    ; 改变标题
    ChangeTitle(newTitle) {
        this.titleControl.Value := newTitle
        this.titleControl.Redraw()
    }

    ; 添加tip项
    AddTipItem(iconNumber := 0, arg*) {
        this.listViewControl.Add('Icon' iconNumber, arg*)
    }

    ; 清空所有tip项
    ClearTips() {
        this.listViewControl.Delete()
    }

    ; 加载文件图标并且获取IconNumber
    LoadIcon(FilePath) {
        ; 建立唯一的扩展 ID 以避免变量名中的非法字符,
        ; 例如破折号. 这种使用唯一 ID 的方法也会执行地更好,
        ; 因为在数组中查找项目不需要进行搜索循环.
        SplitPath(FilePath, , , &FileExt)  ; 获取文件扩展名.
        if FileExt ~= "i)\A(EXE|ICO|ANI|CUR)\z"
        {
            ExtID := FileExt  ; 特殊 ID 作为占位符.
            IconNumber := 0  ; 将其标记为未找到, 以便这些类型可以有一个唯一的图标.
        }
        else  ; 其他的扩展名/文件类型, 计算它们的唯一 ID.
        {
            ExtID := 0  ; 进行初始化来处理比其他更短的扩展名.
            Loop 7     ; 限制扩展名为 7 个字符, 这样之后计算的结果才能存放到 64 位值.
            {
                ExtChar := SubStr(FileExt, A_Index, 1)
                if not ExtChar  ; 没有更多字符了.
                    break
                ; 把每个字符与不同的位置进行运算来得到唯一 ID:
                ExtID := ExtID | (Ord(ExtChar) << (8 * (A_Index - 1)))
            }
            ; 检查此文件扩展名的图标是否已经在图像列表中. 如果是,
            ; 可以避免多次调用并极大提高性能,
            ; 尤其对于包含数以百计文件的文件夹而言:
            IconNumber := this.iconMap.Has(ExtID) ? this.iconMap[ExtID] : 0
        }
        ; 取与此文件扩展名关联的高质量小图标:
        if not DllCall("Shell32\SHGetFileInfoW", "Str", FilePath
            , "Uint", 0, "Ptr", this.sfi, "UInt", this.sfi_size, "UInt", 0x101)  ; 0x101 是 SHGFI_ICON+SHGFI_SMALLICON
            IconNumber := 9999999  ; 把它设置到范围外来显示空图标.
        else ; 成功加载图标.
        {
            ; 从结构中提取 hIcon 成员:
            hIcon := NumGet(this.sfi, 0, "Ptr")
            ; 直接添加 HICON 到小图标和大图标列表.
            ; 下面加上 1 来把返回的索引从基于零转换到基于一:
            IconNumber := DllCall("ImageList_ReplaceIcon", "Ptr", this.ImageListID, "Int", -1, "Ptr", hIcon) + 1
            DllCall("ImageList_ReplaceIcon", "Ptr", this.ImageListID, "Int", -1, "Ptr", hIcon)
            ; 现在已经把它复制到图像列表, 所以应销毁原来的:
            DllCall("DestroyIcon", "Ptr", hIcon)
            ; 缓存图标来节省内存并提升加载性能:
            this.iconMap[ExtID] := IconNumber
        }
        IL_Add(this.ImageListID, FilePath)
        ; 在 ListView 中创建新行并把它和上面的图标编号进行关联:
        ; this.gui.Add("Icon" . IconNumber, A_LoopFileName, A_LoopFileDir, A_LoopFileSizeKB, FileExt)
        return IconNumber
    }

    OnClose(callback) {
        this.gui.OnEvent('Close', callback)
    }

    __Delete() {
        this.gui.Destroy()
        this.iconMap.Clear()
    }
}