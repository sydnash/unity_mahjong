--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

require("std")

local profiler  = require("UnityEngine.Profiler")
local clientApp = require("logic.clientApp")
local Resources =  UnityEngine.Resources

--主入口函数。从这里开始lua逻辑
function main()
    if appConfig.debug then
        profiler:start()
    end

    local app = clientApp.new()
    app.start()
end

--场景切换通知
function onLevelWasLoaded(level)
    Resources.UnloadUnusedAssets()
    collectgarbage("collect")
    Time.timeSinceLevelLoad = 0
end

function onApplicationQuit()
    if appConfig.debug then
        profiler:stop()
    end
end

--endregion