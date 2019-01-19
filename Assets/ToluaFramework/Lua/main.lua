--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

---------------------------------------------------------------------
-- 在加载任何lua文件前检测本地已下载的热更资源是否有效，无效则删除
---------------------------------------------------------------------
local pverTxt = LFS.ReadText(LFS.CombinePath(LFS.PATCH_PATH, "version.txt"), LFS.UTF8_WITHOUT_BOM)
if pverTxt ~= nil and pverTxt ~= "" then
    local separator = "."

    local pverLua = loadstring(pverTxt)()
    local pverArr = Utils.SplitString(pverLua.num, separator)

    local cverTxt = LFS.ReadTextFromResources("version")
    if cverTxt ~= nil and cverTxt ~= "" then
        local cverLua = loadstring(cverTxt)()
        local cverArr = Utils.SplitString(cverLua.num, separator)

        if pverArr[1] ~= cverArr[1] then
            LFS.RemoveDir(LFS.PATCH_PATH)
        end
    end
end








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