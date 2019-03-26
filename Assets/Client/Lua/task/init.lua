require("task.yaotongmahjong.init")
require("task.core.table")
require("task.core.string")

-------------------------------------------------------------------
--全局错误/异常处理函数
-------------------------------------------------------------------
function _GDB_TRACKBACK_(errorMessage)
    local msg = string.format("Lua error: %s\n%s", tostring(errorMessage), debug.traceback("", 2))
    return msg
end

function printLog(tag, fmt, a, ...)
    local desc = ""
    if a == nil then
        desc = fmt
    else
        desc = string.format(tostring(fmt),a,...)
    end
    local t = {
        "[",
        string.upper(tostring(tag)),
        "] ",
        desc,
    }
    print(table.concat(t))
end

function printError(fmt, ...)
    print(debug.traceback("", 2))
end

function printInfo(fmt, ...)
    printLog("INFO", fmt, ...)
end
