--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local modelManager = { }
modelManager.assetType = 2

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function modelManager.setup()
    AssetPoolManager.instance:AddPool(modelManager.assetType, "Model", false)
end

-------------------------------------------------------------------
-- 开始预加载
-------------------------------------------------------------------
function modelManager.preload_begin()
    return PreloadManager.instance:Begin()
end

-------------------------------------------------------------------
-- 压入预加载的资源参数
-------------------------------------------------------------------
function modelManager.preload_push(token, assetPath, assetName, maxCount)
    PreloadManager.instance:Push(token, modelManager.assetType, assetPath, assetName, maxCount)
end

-------------------------------------------------------------------
-- 执行预加载
-------------------------------------------------------------------
function modelManager.preload(token)
    PreloadManager.instance:Load(token, appConfig.loadCountPreFrame)
end

-------------------------------------------------------------------
-- 停止预加载
-------------------------------------------------------------------
function modelManager.preload_end(token)
    return PreloadManager.instance:End(token)
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
