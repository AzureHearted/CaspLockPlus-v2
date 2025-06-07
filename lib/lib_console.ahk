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
     * @returns {String}
     */
    static VarToString(value) {
        try {
            ; OutputDebug(Type(value))
            switch (Type(value)) {
                case 'Integer':
                    return value
                case 'String':
                    return value
                case 'Func':
                    return "(Func) " Format('{:-35}`t', value.Name '()') "--ParamsCount: " value.MinParams " ~ " value.MaxParams
                case 'VarRef':
                    return this.VarToString(%value%)
                case 'Map', 'Array', 'Object':
                    return JSON.stringify(value)
                default:
                    return 'unknown'
            }
        } catch as e {
            return 'unknown'
        }
    }

    /**
     * Map对象转为Json
     * @param {Map} mapObj Map对象
     */
    static MapToJson(mapObj) {
        result := Console.PadString('MapObj', 80, '-', 'around') . '`n'

        for (key, value in mapObj.__Enum()) {
            ; OutputDebug(Format('{:-30}`t', this.VarToString(key)) ':' Format('`t{:10}', this.VarToString(value)))
            result .= Format('{:-30}`t', this.VarToString(key)) ':' Format('`t{:10}', this.VarToString(value))
            result .= '`n'
        }

        result .= Console.PadString('-', 80, '-', 'around')

        return result
    }

    /**
     * 填充字符
     * @param {String} str 字符串
     * @param {Integer} totalLength 填充长度
     * @param {String} char 填充字符
     * @param {'right'|'left'|'around'} direction 填充方向
     */
    static PadString(str, totalLength, char := ' ', direction := 'right') {

        paddingLen := totalLength - StrLen(str)
        if (paddingLen <= 0) {
            return str
        }
        switch (direction) {
            case 'left': return Console.StrRepeat(char, paddingLen) . str
            case 'right': return str . Console.StrRepeat(char, paddingLen)
            case 'around': return Console.StrRepeat(char, paddingLen / 2) str . Console.StrRepeat(char, paddingLen / 2)

        }
    }

    /**
     * 字符串重复
     * @param char 字符
     * @param count 数量
     */
    static StrRepeat(char, count) {
        result := ''
        loop count {
            result .= char
        }
        return result
    }
}