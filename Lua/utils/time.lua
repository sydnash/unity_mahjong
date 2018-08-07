--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local time = class()

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function time.now()
    return os.time()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function time.realtimeSinceStartup()
    return Time.realtimeSinceStartup
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function time.formatDate(date)
    date = (date == nil) and time.now() or date
    return os.date("%Y-%m-%d", date)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function time.formatTime(time)
    time = (time == nil) and time.now() or time
    return os.date("%H:%M:%S", time)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function time.formatDateTime(dt)
    dt = (dt == nil) and time.now() or dt
    return os.date("%Y-%m-%d %H:%M:%S", dt)
end

return time

--endregion
