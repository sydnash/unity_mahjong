--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local gameOver = class("gameOver", base)

_RES_(gameOver, "GameOverUI", "GameOverUI")

function gameOver:ctor(game, datas)
    self.game  = game
    self.datas = datas
    self.super.ctor(self)
end

function gameOver:onInit()
    self.mDeskId:setText(string.format("房号:%d", self.datas.deskId))
    self.mFinishCount:setText(string.format("已打%d/%d局", self.datas.finishGameCount, self.datas.totalGameCount))
    self.mDateTime:setText(time.formatDateTime())

    local items = { self.mItemA, self.mItemB, self.mItemC, self.mItemD, }
    self.items = items

    for k, v in pairs(self.datas.players) do
        local item = items[k+1]
        item:setPlayerInfo(v)
    end

    self.mConfirm:addClickListener(self.onConfirmClickedHandler, self)
    self.mShare:addClickListener(self.onShareClickedHandler, self)
end

function gameOver:onConfirmClickedHandler()
    playButtonClickSound()

    self.game:exitGame() 
    self:close()
end

function gameOver:onShareClickedHandler()
    playButtonClickSound()
end

function gameOver:onDestroy()
    for _, v in pairs(self.items) do
        v.mIcon:setTexture(nil)
    end
end

return gameOver

--endregion
