--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local textureManager = {}

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function textureManager.setup()
    TextureManager.instance:Setup()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function textureManager.load(assetPath, assetName)  
    return TextureManager.instance:Load(assetPath, assetName)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function textureManager.unload(tex)
    TextureManager.instance:Unload(tex)
end

return textureManager

--endregion
