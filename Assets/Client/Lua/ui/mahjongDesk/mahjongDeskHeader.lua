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
        self:setReady(player.ready)

        if player.que ~= nil and player.que >= 0 then
            self:showDingQue(player.que)
        else
            self.mQue:hide()
        end

        if player.hu ~= nil and player.hu[1].HuCard >= 0 then
            self:setHu(true)
        else
            self:setHu(false)
        end

        if player.isCreator then
            self.mFz:show()
        else
            self.mFz:hide()
        end

        if player.isMarker then
            self.mZhuang:show()
        else
            self.mZhuang:hide()
        end
    end
end

function mahjongDeskHeader:setReady(ready)
    if self.mReady ~= nil then
        if ready then
            self.mReady:show()
        else
            self.mReady:hide()
        end
    end
end

function mahjongDeskHeader:setHu(hu)
    if hu then
        self.mHu:show()
    else
        self.mHu:hide()
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
    self:setReady(false)
    self.mHu:hide()
    self.mGfx:hide()
    self.mQue:hide()
    self.mFz:hide()
    self.mZhuang:hide()
end

function mahjongDeskHeader:onDestroy()
    self.mIcon:setTexture(nil)
end

return mahjongDeskHeader

--endregion
