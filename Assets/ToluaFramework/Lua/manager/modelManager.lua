--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local modelManager = { }
assetType = "model"

-------------------------------------------------------------------
-- 全局初始化
-------------------------------------------------------------------
function modelManager.setup()
    AssetPoolManager.instance:AddPool(assetType, "Model", false)
end

-------------------------------------------------------------------
-- 获取预加载token
-------------------------------------------------------------------
function modelManager.preload()
    return preloadManager.createToken(assetType)
end

-------------------------------------------------------------------
-- 加载资源
-------------------------------------------------------------------
function modelManager.load(assetPath, assetName)
    return AssetPoolManager.instance:Alloc(assetType, assetPath, assetName)
end

-------------------------------------------------------------------
-- 卸载资源
-------------------------------------------------------------------
function modelManager.unload(model)
    AssetPoolManager.instance:Dealloc(assetType, model.gameObject)
end

return modelManager

--endregion
