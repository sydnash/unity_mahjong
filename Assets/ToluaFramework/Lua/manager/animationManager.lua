--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local animationManager = class("animationManager")
animationManager.assetType = 4

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function animationManager.setup()
    AssetPoolManager.instance:AddPool(animationManager.assetType, "Animation", false)
end

-------------------------------------------------------------------
-- 获取预加载token
-------------------------------------------------------------------
function animationManager.preload()
    return preloadManager.createToken(animationManager.assetType)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function animationManager.load(assetPath, assetName)
    return AssetPoolManager.instance:Alloc(animationManager.assetType, assetPath, assetName)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function animationManager.unload(clip)
    AssetPoolManager.instance:Dealloc(animationManager.assetType, clip)
end

return animationManager

--endregion
