--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local gameEnd = class("gameEnd", base)

gameEnd.folder = "GameEndUI"
gameEnd.resource = "GameEndUI"

function gameEnd:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function gameEnd:onInit()
    self.mConfirm:addClickListener(self.onConfirmClickedHandler, self)
end

function gameEnd:onConfirmClickedHandler()
    playButtonClickSound()

    self:close()

    if self.game.leftGames > 0 then
        self.game:ready(true)
    else
        self.game:exitGame()
    end    
end

return gameEnd

--endregion
