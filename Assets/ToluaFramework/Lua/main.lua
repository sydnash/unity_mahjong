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
        if pverArr.Length > 1 and cverArr.Length > 1 then
            if pverArr[1] ~= cverArr[1] then
                LFS.RemoveDir(LFS.PATCH_PATH)
            end
        end
    end
end







require("utils.class")
G_Current_Version = "0.0.0"

local appConfig = require("config.appConfig")
local profiler  = require("UnityEngine.Profiler")
local app       = nil

--主入口函数。从这里开始lua逻辑
function main()
    if appConfig.debug then
        profiler:start()
    end
    
    local patchManager = require("logic.manager.patchManager")
    patchManager.patch(function()
        app = require("clientApp")
        app:start()
    end)
end

--场景切换通知
function onLevelWasLoaded(level)
    collectgarbage("collect")
    Time.timeSinceLevelLoad = 0
end

function onApplicationQuit()
    if appConfig.debug then
        profiler:stop()
    end

    if app ~= nil then
        app:quit()
    end

    Logger.Close()
end

--endregion