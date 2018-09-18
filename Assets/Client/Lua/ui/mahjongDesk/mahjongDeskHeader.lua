--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongClass = require("const.mahjongClass")

local base = require("ui.common.panel")
local mahjongDeskHeader = class("mahjongDeskHeader", base)

function mahjongDeskHeader:onInit()
    self.mU:show()
    self.mP:hide()
    self:reset()
end

function mahjongDeskHeader:setPlayerInfo(player)
    if player == nil then
        self.mU:show()
        self.mP:hide()
    else
        self.mU:hide()
        self.mP:show()

        self.mIcon:setTexture(player.headerTex)

        self.mNickname:setText(player.nickname)
        self.mScore:setText(string.format("分数:%d", player.score))

        if self.mReady ~= nil and player.ready then
            self.mReady:show()
        end

        if player.que ~= nil then
            self:showDingQue(player.que)
        end

        if player.hu ~= nil and player.hu[1].HuCard >= 0 then
            self.mHu:show()
        end

        if player.isCreator then
            self.mFz:show()
        end
    end
end

function mahjongDeskHeader:setReady(ready)
    if ready then
        if self.mReady ~= nil then
            self.mReady:show()
        end
    else
        if self.mReady ~= nil then
            self.mReady:hide()
        end
    end
end

function mahjongDeskHeader:playGfx(gfxName)
    self.mGfx:setSprite(gfxName)
    self.mGfx:show()
    self.mGfxAnim:play()
end

function mahjongDeskHeader:showDingQue(mjtype)
    self.mQue:setSprite(getMahjongClassName(mjtype))
    self.mQue:show()
end

function mahjongDeskHeader:reset()
    if self.mReady ~= nil then
        self.mReady:hide()
    end

    self.mHu:hide()
    self.mGfx:hide()
    self.mQue:hide()
end

function mahjongDeskHeader:onDestroy()
    self.mIcon:setTexture(nil)
end

return mahjongDeskHeader

--endregion
