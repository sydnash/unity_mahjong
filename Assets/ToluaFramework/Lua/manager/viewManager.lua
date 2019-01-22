--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local viewManager = {}
local assetType = "view"

local GameObject = UnityEngine.GameObject
local Camera     = UnityEngine.Camera

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function viewManager.setup()
    AssetPoolManager.instance:AddPool(assetType, "UI", false)

    local root = find("UIRoot")
    viewManager.canvas = root:findChild("Canvas")
    local camera = root:findChild("UICamera")
    viewManager.camera = getComponentU(camera.gameObject, typeof(Camera))

    GameObject.DontDestroyOnLoad(root.gameObject);
end

-------------------------------------------------------------------
-- 获取预加载token
-------------------------------------------------------------------
function viewManager.preload()
    return preloadManager.createToken(assetType)
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
