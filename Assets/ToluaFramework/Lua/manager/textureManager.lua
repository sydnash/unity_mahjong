--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local textureManager = {}
local assetType = 3

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function textureManager.setup()
    AssetPoolManager.instance:AddPool(assetType, "Texture", true)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function textureManager.load(assetPath, assetName)  
    return AssetPoolManager.instance:Alloc(assetType, assetPath, assetName)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function textureManager.unload(tex, destroy)
    local suc = AssetPoolManager.instance:Dealloc(assetType, tex)

    if (not suc) and destroy then
        GameObject.Destroy(tex)
    end
end

return textureManager

--endregion
