--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local gameEndItem = class("gameEndItem", base)

_RES_(gameEndItem, "GameEndUI/Mahjong", "GameEndItem")

local color = {
    meId            = hexColorToColor("e2d488ff"),
    otherId         = hexColorToColor("88c3e2ff"),
    meFanFu         = hexColorToColor("f4e592ff"),
    otherFanFu      = hexColorToColor("92d1f2ff"),
}

function gameEndItem:onInit()
    self.pai = {}
    self:reset()
    self.mRecord:addClickListener(self.onRecordClickedHandler, self)
end

function gameEndItem:onRecordClickedHandler()
    if self.recordCallback then
        self.recordCallback()
    end
end

function gameEndItem:setPlayerInfo(player, cb)
    self.recordCallback = cb
    self.mHeader:setTexture(player.headerUrl)
    self.mNickname:setText(cutoutString(player.nickname, gameConfig.nicknameMaxLength))
    self.mId:setText(string.format("帐号:%d", player.acId))
    self.mScore:setScore(player.score)

    local pos = self.mScore:getLocalPosition()
    if player.acId == gamepref.player.acId then
        self.mRecord:show()
        pos.y = 20
        self.mScore:setLocalPosition(pos)
        self.mBGL:setSprite("me")
        self.mBGR:setSprite("me")
        self.mNickname:setColor(color.meId)
        self.mId:setColor(color.meId)
    else
        self.mRecord:hide()
        pos.y = 0
        self.mScore:setLocalPosition(pos)
        self.mBGL:setSprite("other")
        self.mBGR:setSprite("other")
        self.mNickname:setColor(color.otherId)
        self.mId:setColor(color.otherId)
    end

    if player.que ~= nil and player.que >= 0 then
        self.mQue:setSprite(getMahjongClassName(player.que))
        self.mQue:show()
    end

    if not json.isNilOrNull(player.hu) and player.hu >= 0 then
        self.mResult:show()
        local detail = opType.hu.detail
        if player.huType == detail.zimo  then
            self.mResult:setSprite("zimo")
        elseif player.huType == detail.gangshanghua then
            self.mResult:setSprite("gangshanghua")
        else
            self.mResult:setSprite("hu")
        end
    end

    if player.isCreator then
        self.mFz:show()
    end

    if player.isMarker then
        self.mZhuang:show()
    end

    local x = 0

    local peng = player[opType.peng.id]
    if peng ~= nil then
        for _, u in pairs(peng) do
            local p = require("ui.gameEnd.mahjong.gameEndPengPai").new()
            p:setParent(self.mPai)
            p:show()
            p:setMahjongId(u[1])
            p:setLocalPosition(Vector3.New(x, 0, 0))

            x = x + p.width + 14
            table.insert(self.pai, p)
        end
    end

    local gang = player[opType.gang.id]
    if gang ~= nil then
        for _, u in pairs(gang) do
            local p = require("ui.gameEnd.mahjong.gameEndGangPai").new()
            p:setParent(self.mPai)
            p:show()
            p:setMahjongId(u[1])
            p:setLocalPosition(Vector3.New(x, 0, 0))

            x = x + p.width + 14
            table.insert(self.pai, p)
        end
    end

    --先把手牌进行排序
    table.sort(player.inhand, function(a, b)
        return a < b
    end)

    for _, u in pairs(player.inhand) do
        local p = require("ui.gameEnd.mahjong.gameEndPai").new()
        p:setParent(self.mPai)
        p:show()
        p:setMahjongId(u)
        p:setLocalPosition(Vector3.New(x, 0, 0))

        x = x + p.width
        table.insert(self.pai, p)
    end

    local hu = player.hu
    if not json.isNilOrNull(hu) and hu >= 0 then
        self.mResult:setSprite("hu")
        self.mResult:show()

        local p = require("ui.gameEnd.mahjong.gameEndPai").new()
        p:setParent(self.mPai)
        p:show()
        p:setMahjongId(hu)
        p:setLocalPosition(Vector3.New(x + 23, 0, 0))
        p:setHighlight(true)

        table.insert(self.pai, p)
    end
end

function gameEndItem:reset()
    self.mFz:hide()
    self.mResult:hide()
    self.mQue:hide()
    self.mZhuang:hide()
end

function gameEndItem:onDestroy()
    for _, v in pairs(self.pai) do
        v:close()
    end
    self.pai = nil

    base.onDestroy(self)
end

return gameEndItem

--endregion
