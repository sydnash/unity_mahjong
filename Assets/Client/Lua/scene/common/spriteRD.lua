--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local spriteRD = class("spriteRD", base)

----------------------------------------------------------------
--
----------------------------------------------------------------
function spriteRD:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(SpriteRD))
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function spriteRD:setSprite(spriteName)
    self.component.spriteName = spriteName
end

return spriteRD

--endregion
