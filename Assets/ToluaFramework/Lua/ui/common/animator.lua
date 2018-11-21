--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local animator = class("animator", base)

local Animator = UnityEngine.Animator

----------------------------------------------------------------
--
----------------------------------------------------------------
function animator:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(Animator))
end

return animator

--endregion
