--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local viewManager = {}
local assetType = 1

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function viewManager.setup()
    AssetPoolManager.instance:AddPool(assetType, "UI", false)

    local root = find("UIRoot")
    GameObject.DontDestroyOnLoad(root);
    viewManager.canvas = findChild(root.transform, "Canvas")
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function viewManager.load(assetPath, assetName)
    return AssetPoolManager.instance:Alloc(assetType, assetPath, assetName)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function viewManager.unload(view)
    AssetPoolManager.instance:Dealloc(assetType, view.gameObject)
end

return viewManager

--endregion
