--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local modelManager = {}
local assetType = 2

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function modelManager.setup()
    AssetPoolManager.instance:AddPool(assetType, "Model", false)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function modelManager.load(assetPath, assetName)
    return AssetPoolManager.instance:Alloc(assetType, assetPath, assetName)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function modelManager.unload(model)
    AssetPoolManager.instance:Dealloc(assetType, model.gameObject)
end

return modelManager

--endregion
