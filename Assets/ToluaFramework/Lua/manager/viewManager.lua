--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local viewManager = {}

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function viewManager.setup()
    UIManager.instance:Setup()
    viewManager.canvas = UIManager.instance.canvas
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function viewManager.load(assetPath, assetName)
    return UIManager.instance:Load(assetPath, assetName)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function viewManager.unload(view)
    UIManager.instance:Unload(view.gameObject)
end

return viewManager

--endregion
