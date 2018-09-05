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
function time.formatDate(d)
    d = (d == nil) and time.now() or d
    return os.date("%Y-%m-%d", d)
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
function time.formatDateTime(dt)
    dt = (dt == nil) and time.now() or dt
    return os.date("%Y-%m-%d %H:%M:%S", dt)
end

return time

--endregion
