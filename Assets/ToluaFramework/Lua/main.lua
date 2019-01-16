--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

require("std")

local profiler  = require("UnityEngine.Profiler")
local app = nil

--主入口函数。从这里开始lua逻辑
function main()
    if appConfig.debug then
        profiler:start()
    end

    soundManager.setup()
    viewManager.setup()
    modelManager.setup()
    textureManager.setup()
    animationManager.setup()
    eventManager.setup()
    sceneManager.setup()
    
    app = require("clientApp")
    app:start()
end

--场景切换通知
function onLevelWasLoaded(level)
    AssetPoolManager.instance:UnloadUnused()
    collectgarbage("collect")
    Time.timeSinceLevelLoad = 0
end

function onApplicationQuit()
    networkManager.disconnect()

    if appConfig.debug then
        profiler:stop()
    end

    app:quit()
    Logger.Close()

    log("application quit")
end

--endregion