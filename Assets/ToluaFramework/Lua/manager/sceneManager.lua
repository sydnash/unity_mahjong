--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local sceneManager = {}

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function sceneManager.setup()

end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function sceneManager.load(scenePath, sceneName, completedCallback)
    SceneManager.instance:Load(scenePath, sceneName, completedCallback)
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
