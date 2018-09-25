--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local modelManager = { }
modelManager.assetType = 2

-------------------------------------------------------------------
-- 全局初始化
-------------------------------------------------------------------
function modelManager.setup()
    AssetPoolManager.instance:AddPool(modelManager.assetType, "Model", false)
end

-------------------------------------------------------------------
-- 获取预加载token
-------------------------------------------------------------------
function modelManager.preload()
    return preloadManager.createToken(modelManager.assetType)
end

-------------------------------------------------------------------
-- 加载资源
-------------------------------------------------------------------
function modelManager.load(assetPath, assetName)
    return AssetPoolManager.instance:Alloc(modelManager.assetType, assetPath, assetName)
end

-------------------------------------------------------------------
-- 卸载资源
-------------------------------------------------------------------
function modelManager.unload(model)
    AssetPoolManager.instance:Dealloc(modelManager.assetType, model.gameObject)
end

return modelManager

--endregion
