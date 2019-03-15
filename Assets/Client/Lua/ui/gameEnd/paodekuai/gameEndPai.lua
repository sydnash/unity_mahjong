--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local pokerType = require("logic.poker.pokerType")

local base = require("ui.common.view")
local gameEndPai = class("gameEndPai", base)

_RES_(gameEndPai, "GameEndUI/PaoDeKuai", "GameEndItemPai")
gameEndPai.width = 120

function gameEndPai:ctor(pokerId)
    self.id = pokerId
    base.ctor(self)
end

function gameEndPai:onInit()
    self.mPai:setSprite(tostring(self.id))
end



return gameEndPai

--endregion
