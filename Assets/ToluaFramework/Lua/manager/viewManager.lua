--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local viewManager = {}
local assetType = "view"

local GameObject = UnityEngine.GameObject
local CanvasScaler = UnityEngine.UI.CanvasScaler
local Camera     = UnityEngine.Camera
local Screen = UnityEngine.Screen

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function viewManager.setup()
    AssetPoolManager.instance:AddPool(assetType, "ui", false)

    local root = find("UIRoot")
    viewManager.canvas = root:findChild("Canvas")

    if CanvasScaler ~= nil then
        local canvasScaler = getComponentU(viewManager.canvas.gameObject, typeof(CanvasScaler))
        if canvasScaler ~= nil then
            local sr = Screen.width / Screen.height
            if sr <= (16 / 9) then
                canvasScaler.matchWidthOrHeight = 0
            else
                canvasScaler.matchWidthOrHeight = 1
            end
        end
    end

    local camera = root:findChild("UICamera")
    viewManager.camera = getComponentU(camera.gameObject, typeof(Camera))

    GameObject.DontDestroyOnLoad(root.gameObject);
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function viewManager.load(assetPath, assetName)
    return AssetPoolManager.instance:Alloc(assetType, string.lower(assetPath), string.lower(assetName))
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function viewManager.unload(view)
    AssetPoolManager.instance:Dealloc(assetType, view.gameObject)
end

return viewManager

--endregion
