--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local animationManager = class("animationManager")
local assetType = "animation"

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function animationManager.setup()
    AssetPoolManager.instance:AddPool(assetType, "Animation", false)
end

-------------------------------------------------------------------
-- 获取预加载token
-------------------------------------------------------------------
function animationManager.preload()
    return preloadManager.createToken(assetType)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function animationManager.load(assetPath, assetName)
    return AssetPoolManager.instance:Alloc(assetType, assetPath, assetName)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function animationManager.unload(clip)
    AssetPoolManager.instance:Dealloc(assetType, clip)
end

return animationManager

--endregion
