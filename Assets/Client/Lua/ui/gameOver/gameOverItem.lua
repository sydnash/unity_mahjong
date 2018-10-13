--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.panel")
local gameOverItem = class("gameOverItem", base)

function gameOverItem:onInit()
    self:reset()
end

function gameOverItem:setPlayerInfo(player)
    self.mIcon:setTexture(player.headerTex)
    self.mNickname:setText(player.nickname)
    self.mId:setText(string.format("帐号:%d", player.acId))
    self.mScore:setScore(player.totalScore)

    if player.isCreator then
        self.mFz:show()
    end

    if player.isWinner then
        self.mWinner:show()
    end
end

function gameOverItem:reset()
    self.mFz:hide()
    self.mWinner:hide()
end

function gameOverItem:onDestroy()
    self.mIcon:setTexture(nil)
    self.super.onDestroy(self)
end

return gameOverItem

--endregion
