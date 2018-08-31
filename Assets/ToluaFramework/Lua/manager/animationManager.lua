--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local animationManager = class("animationManager")

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function animationManager.setup()

end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function animationManager.load(assetPath, assetName)
    return AnimationManager.instance:Load(assetPath, assetName)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function animationManager.unload(clip)
    AnimationManager.instance:Unload(clip)
end

return animationManager

--endregion
