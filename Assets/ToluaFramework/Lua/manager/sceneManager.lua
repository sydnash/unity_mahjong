--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local sceneManager = {}

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function sceneManager.setup()
    SceneManager.instance:Setup("scene")
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function sceneManager.load(sceneName, completedCallback)
    SceneManager.instance:Load(string.lower(sceneName), completedCallback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function sceneManager.unload()

end

return sceneManager

--endregion
