#Requires AutoHotkey v2.0
#Include <JSON>


class Console {
    /**
     * 日志打印
     * @param {Array} args 要打印的内容
     */
    static Log(args*) {
        OutputDebug('数量：' args.Length)
        for (arg in args) {
            OutputDebug('[log] ' FormatTime(A_Now, 'yyyy-MM-dd HH:mm:ss') '`n' this.VarToString(arg))
        }
    }

    /**
     * 调试打印
     * @param {Array} args 要打印的内容
     */
    static Debug(args*) {
        for (arg in args) {
            OutputDebug(this.VarToString(arg))
        }
    }

    /**
     * 变量转字符串
     * @param {Any} value 
     */
    static VarToString(value) {
        ; OutputDebug(Type(OutputDebug))
        try {
            switch (Type(value)) {
                case 'Integer':
                    return value
                case 'String':
                    return value
                case 'Func':
                    return "(Func) " value.Name "()`t --VarCount:" value.MinParams "~" value.MaxParams
                case 'VarRef':
                    return this.VarToString(%value%)
                case 'Array':
                case 'Object':
                default:
                    return JSON.stringify(value)
            }
        } catch as e {
            return 'null`t' e.Message
        }
    }
}