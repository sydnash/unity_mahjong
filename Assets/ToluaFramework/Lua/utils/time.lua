--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local time = class()

-------------------------------------------------------------------
--
-------------------------------------------------------------------
time.SECONDS_PER_DAY = 24 * 60 * 60

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function time.now()
    return os.time()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function time.today()
    local nowtime = os.date("*t")
    nowtime.hour = 0
    nowtime.min  = 0
    nowtime.sec  = 0

    return os.time(nowtime)
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
function time.formatDate(d)
    d = (d == nil) and time.now() or d
    return os.date("%Y.%m.%d", d)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function time.formatTime(t)
    t = (t == nil) and time.now() or t
    return os.date("%H:%M:%S", t)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function time.formatTimeWithoutSecond(t)
    t = (t == nil) and time.now() or t
    return os.date("%H:%M", t)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function time.formatDateTime(dt)
    dt = (dt == nil) and time.now() or dt
    return os.date("%Y.%m.%d %H:%M:%S", dt)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function time.formatDateTimeWithoutSecond(dt)
    dt = (dt == nil) and time.now() or dt
    return os.date("%Y.%m.%d %H:%M", dt)
end

return time

--endregion
