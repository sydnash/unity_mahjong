--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local gameOver = class("gameOver", base)

gameOver.folder = "GameOverUI"
gameOver.resource = "GameOverUI"

function gameOver:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function gameOver:onInit()
    self.mConfirm:addClickListener(self.onConfirmClickedHandler, self)
    self.mShare:addClickListener(self.onShareClickedHandler, self)
end

function gameOver:onConfirmClickedHandler()
    playButtonClickSound()

    self:close()
    self.game:exitGame() 
end

function gameOver:onShareClickedHandler()
    playButtonClickSound()
end

return gameOver

--endregion
