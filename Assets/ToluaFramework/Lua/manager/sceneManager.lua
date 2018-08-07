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
function sceneManager.load(sceneName, completedCallback)
    SceneLoader.instance:Load(sceneName, completedCallback)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function sceneManager.unload()

end

return sceneManager

--endregion
