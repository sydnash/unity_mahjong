--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local sceneManager = {}
local hasSetup = false

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function sceneManager.setup()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function sceneManager.load(sceneName, completedCallback)
    if not hasSetup then
        SceneManager.instance:Setup("Scene")
        hasSetup = true
    end

    SceneManager.instance:Load(sceneName, completedCallback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function sceneManager.getActivedSceneName()
    return SceneManager.instance:GetActivedSceneName()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function sceneManager.unload()

end

return sceneManager

--endregion
