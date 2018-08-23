--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local modelManager = {}

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function modelManager.setup()
    ModelManager.instance:Setup()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function modelManager.load(assetPath, assetName)
    return ModelManager.instance:Load(assetPath, assetName)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function modelManager.unload(model)
    ModelManager.instance:Unload(model.gameObject)
end

return modelManager

--endregion
