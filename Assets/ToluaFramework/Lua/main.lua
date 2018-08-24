--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

require("std")

local profiler  = require("UnityEngine.Profiler")
local Resources =  UnityEngine.Resources

--主入口函数。从这里开始lua逻辑
function main()
    if appConfig.debug then
        profiler:start()
    end

    soundManager.setup()
    viewManager.setup()
    eventManager.setup()
    sceneManager.setup()

    local app = require("clientApp").new()
    app:start()
end

--场景切换通知
function onLevelWasLoaded(level)
    Resources.UnloadUnusedAssets()
    collectgarbage("collect")
    Time.timeSinceLevelLoad = 0
end

function onApplicationQuit()
    networkManager.disconnect()

    if appConfig.debug then
        profiler:stop()
    end

    Logger.Close()
    log("application quit")
end

--endregion