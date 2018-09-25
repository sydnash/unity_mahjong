--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local viewManager = {}
viewManager.assetType = 1

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function viewManager.setup()
    AssetPoolManager.instance:AddPool(viewManager.assetType, "UI", false)

    local root = find("UIRoot")
    GameObject.DontDestroyOnLoad(root.gameObject);
    viewManager.canvas = root:findChild("Canvas")
end

-------------------------------------------------------------------
-- 获取预加载token
-------------------------------------------------------------------
function viewManager.preload()
    return preloadManager.createToken(viewManager.assetType)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function viewManager.load(assetPath, assetName)
    return AssetPoolManager.instance:Alloc(viewManager.assetType, assetPath, assetName)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function viewManager.unload(view)
    AssetPoolManager.instance:Dealloc(viewManager.assetType, view.gameObject)
end

return viewManager

--endregion
