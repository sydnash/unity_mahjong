--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local patchViewManager = {}
local assetType = "patchview"
local assetPath = "PatchUI"

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function patchViewManager.setup()
    AssetPoolManager.instance:AddPool(assetType, "UI", false)
    patchViewManager.root = UnityEngine.GameObject.Find("UIRoot/Canvas/Low")
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function patchViewManager.load(assetName)
    return AssetPoolManager.instance:Alloc(assetType, assetPath, assetName)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function patchViewManager.unload(view)
    AssetPoolManager.instance:Dealloc(assetType, view.gameObject)
end

return patchViewManager

--endregion
