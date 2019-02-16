--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local modelManager = { }
assetType = "model"

-------------------------------------------------------------------
-- 全局初始化
-------------------------------------------------------------------
function modelManager.setup()
    AssetPoolManager.instance:AddPool(assetType, "model", false)
end

-------------------------------------------------------------------
-- 加载资源
-------------------------------------------------------------------
function modelManager.load(assetPath, assetName)
    return AssetPoolManager.instance:Alloc(assetType, string.lower(assetPath), string.lower(assetName))
end

-------------------------------------------------------------------
-- 卸载资源
-------------------------------------------------------------------
function modelManager.unload(model)
    AssetPoolManager.instance:Dealloc(assetType, model.gameObject)
end

return modelManager

--endregion
