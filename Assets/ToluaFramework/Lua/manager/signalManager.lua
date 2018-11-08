--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local slots = {}

-------------------------------------------------------------------
-- 注册信号处理函数
-------------------------------------------------------------------
local function register(signalName, func, target)
--    log(string.format("register, signalName = %s, target = %s", signalName, target.name))
    if slots[signalName] == nil then
        slots[signalName] = {}
    end

    local slot = { t = target, f = func }
    table.insert(slots[signalName], slot)
end

-------------------------------------------------------------------
-- 注销信号处理函数
-------------------------------------------------------------------
local function unregister(signalName, func, target)
    local slot = slots[signalName]

    if slot ~= nil then
        for k, v in pairs(slot) do
            if v.t == target and v.f == func then
--                log(string.format("unregister, signalName = %s, target = %s", signalName, target.name))
                slot[k] = nil
                break
            end
        end
    end
end

-------------------------------------------------------------------
-- 发送信号
-------------------------------------------------------------------
local function signal(signalName, args)
    local slot = slots[signalName]

    if slot == nil then
        logWarning(string.format("handler of signal [%s] is not found in signalManager", signalName))
    else
        for _, v in pairs(slot) do
            if v.t == nil then
                v.f(args)
            else
                v.f(v.t, args)
            end
        end
    end
end

-------------------------------------------------------------------
-- 返回
-------------------------------------------------------------------
return {
    registerSignalHandler   = register,
    unregisterSignalHandler = unregister,
    signal                  = signal,
}

--endregion
