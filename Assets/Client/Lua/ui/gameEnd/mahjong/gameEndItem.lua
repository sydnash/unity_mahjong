--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local gameEndItem = class("gameEndItem", base)

_RES_(gameEndItem, "GameEndUI/Mahjong", "GameEndItem")

local color = {
    meId         = hexColorToColor("e2d488ff"),
    otherId      = hexColorToColor("88c3e2ff"),
    meFanShu     = hexColorToColor("fbdf85ff"),
    otherFanShu  = hexColorToColor("78dcf5ff"),
    meDetail     = hexColorToColor("fffee8ff"),
    otherDetail  = hexColorToColor("e0f7ffff")
}

function gameEndItem:onInit()
    self.pai = {}
    self:reset()
    self.mRecord:addClickListener(self.onRecordClickedHandler, self)
end

function gameEndItem:onRecordClickedHandler()
    local ui = require ("ui.gameEnd.scoreDetail").new(self.finalChanges)
    ui:show()

    playButtonClickSound()
end

function gameEndItem:setPlayerInfo(player, scoreChanges)
    self.mHeader:setTexture(player.headerUrl)
    self.mNickname:setText(cutoutString(player.nickname, gameConfig.nicknameMaxLength))
    self.mId:setText(string.format("帐号:%d", player.acId))
    self.mScore:setScore(player.score)

    self.finalChanges = self:filterScoreChanges(player.acId, scoreChanges)
    
    self:setFanShu()
    self:setScoreInfo()

    if player.acId == gamepref.player.acId then
        self.mRecord:show()
        local scorePos = self.mScore:getLocalPosition()
        scorePos.y = 20
        self.mScore:setLocalPosition(scorePos)
        self.mBGL:setSprite("me")
        self.mBGR:setSprite("me")
        self.mNickname:setColor(color.meId)
        self.mId:setColor(color.meId)
        local fanshuPos = self.mFanShu:getLocalPosition()
        fanshuPos.y = 20
        self.mFanShu:setLocalPosition(fanshuPos)
        self.mFanShu:setColor(color.meFanShu)
        self.mScoreInfo:setColor(color.meDetail)
    else
        self.mRecord:hide()
        local scorePos = self.mScore:getLocalPosition()
        scorePos.y = 0
        self.mScore:setLocalPosition(scorePos)
        self.mBGL:setSprite("other")
        self.mBGR:setSprite("other")
        self.mNickname:setColor(color.otherId)
        self.mId:setColor(color.otherId)
        local fanshuPos = self.mFanShu:getLocalPosition()
        fanshuPos.y = 0
        self.mFanShu:setLocalPosition(fanshuPos)
        self.mFanShu:setColor(color.otherFanShu)
        self.mScoreInfo:setColor(color.otherDetail)
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
            p:setLocalPosition(Vector3.New(x, -7, 0))

            x = x + p.width + 8
            table.insert(self.pai, p)
        end
    end

    local gang = player[opType.gang.id]
    if gang ~= nil then
        for _, u in pairs(gang) do
            local p = require("ui.gameEnd.mahjong.gameEndGangPai").new()
            p:setParent(self.mPai)
            p:show()
            p:setMahjongId(u[1], u[5] == opType.gang.detail.angang)
            p:setLocalPosition(Vector3.New(x, -7, 0))

            x = x + p.width + 8
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
        local p = require("ui.gameEnd.mahjong.gameEndPai").new()
        p:setParent(self.mPai)
        p:show()
        p:setMahjongId(hu)
        p:setLocalPosition(Vector3.New(x + 15, 0, 0))
        p:setHighlight(true)

        table.insert(self.pai, p)
    end
end

function gameEndItem:filterScoreChanges(acId, scoreChanges)
    local finalChanges = {}

    if (not json.isNilOrNull(scoreChanges)) and (#scoreChanges > 0) then
        table.bubbleSort(scoreChanges, function(t1, t2)
            return t1.Idx < t2.Idx
        end)

        for _, info in pairs(scoreChanges) do
            local win = {}
            local failed = {}
            local hasSelf = false
            local selfResult = 0
            for _, c in pairs(info.C) do
                if c.AcId == acId then
                    hasSelf = true
                    selfResult = c
                end
                if c.Change > 0 then
                    table.insert(win, c.AcId)
                else
                    table.insert(failed, c.AcId)
                end
            end
            if hasSelf then
                local t = {}
                t.Op            = info.Op
                t.Detail        = info.De
                t.IsHaiDi       = info.IsHaiDi
                t.FanXing       = info.FanXing
                t.Gen           = info.Gen
                t.HuFanShu      = info.HuFanShu or 0
                t.BeFanShu      = info.BeFanShu or 0

                t.Fan           = selfResult.Fan
                t.Score         = selfResult.Change
                if selfResult.Change > 0 then
                    t.BeAcIds = failed
                else
                    t.BeAcIds = win
                end
                table.insert(finalChanges, t)
            end
        end
    end

    return finalChanges
end

local detailTypeName = {
    [opType.gang.detail.angang]                     = {"暗杠", ""},
    [opType.gang.detail.bagangwithmoney]            = {"巴杠", ""},
    [opType.gang.detail.minggang]                   = {"明杠", ""},
    [opType.gang.detail.zhuanyu]                    = {"被转雨", "转雨"},
    [opType.gang.detail.fanyu]                      = {"被返雨", "返雨"},
    [opType.hu.detail.zimo]                         = {"自摸", ""},
    [opType.hu.detail.dianpao]                      = {"接炮", "点炮"},
    [opType.hu.detail.qianggang]                    = {"抢杠", "被抢杠"},
    [opType.hu.detail.gangshanghua]                 = {"杠上花", ""},
    [opType.hu.detail.gangshangpao]                 = {"杠上胡", "杠上炮"},
    [opType.hu.detail.tianhu]                       = {"天胡", ""},
    [opType.hu.detail.dihu]                         = {"地胡", "被地胡"},
    [opType.hu.detail.chahuazhu]                    = {"查花猪", "被查花猪"},
    [opType.hu.detail.chajiao]                      = {"查叫", "被查叫"},
    [opType.hu.detail.bijiao]                       = {"比叫", "被比叫"},
}

local fanxingTypeName = {
    [fanXingType.su]            = "平胡", 
    [fanXingType.qingYiSe]      = "清一色", 
    [fanXingType.qiDui]         = "七对", 
    [fanXingType.daDuiZi]       = "大对子", 
    [fanXingType.jinGouDiao]    = "金钩吊", 
    [fanXingType.jiangDui]      = "将对", 
    [fanXingType.yaoJiu]        = "幺九", 
    [fanXingType.menQing]       = "门清", 
    [fanXingType.zhongZhang]    = "中张", 
    [fanXingType.jiangQiDui]    = "将七对", 
    [fanXingType.jiaXinWu]      = "夹心五", 
}

function gameEndItem:setScoreInfo()
--    log("gameEndItem.setScoreInfo, data = " .. table.tostring(self.finalChanges))
    local text = string.empty

    local gang = {
        [opType.gang.detail.angang]          = 0,
        [opType.gang.detail.bagangwithmoney] = 0,
        [opType.gang.detail.minggang]        = 0,
    }

    for _, v in pairs(self.finalChanges) do
        if v.Op == opType.hu.id then
            local d = detailTypeName[v.Detail]
            if v.Score > 0 then                
                if v.Detail == opType.hu.detail.bijiao or v.Detail == opType.hu.detail.qianggang then
                    text = text .. string.format("%s(%d) ", d[1], v.BeAcIds[1])
                else
                    text = text .. d[1]
                    --统计根数和番型
                    local ht = string.empty
                    if v.Gen > 0 then
                        ht = ht .. tostring(v.Gen) .. "根 "
                    end

                    if not json.isNilOrNull(v.FanXing) then
                        for k, u in pairs(v.FanXing) do
                            ht = ht .. fanxingTypeName[u]
                            if k < #v.FanXing then
                                ht = ht .. " "
                            end
                        end
                    end

                    if string.isNilOrEmpty(ht) then
                        text = text .. " "
                    else
                        text = text .. string.format("(%s) ", ht)
                    end
                end
            else
                if v.Detail == opType.hu.detail.dianpao or v.Detail == opType.hu.detail.gangshangpao or v.Detail == opType.hu.detail.qianggang or v.Detail == opType.hu.detail.bijiao then
                    text = text .. string.format("%s(%d) ", d[2], v.BeAcIds[1])
                else
                    text = text .. d[2] .. " "
                end
            end
        elseif v.Op == opType.gang.id then
            if v.Score > 0 and gang[v.Detail] ~= nil then
                gang[v.Detail] = gang[v.Detail] + 1
            end
        end
    end

    for k, v in pairs(gang) do
        local d = detailTypeName[k]
        if v > 0 then
            text = text .. string.format("%sx%d ", d[1], v)
        end
    end

    self.mScoreInfo:setText(text)
end

function gameEndItem:setFanShu()
    local fan = -1

    for _, v in pairs(self.finalChanges) do
        if v.Op == opType.hu.id and v.Score >= 0 then
            fan = v.Fan
            break
        end
    end

    if fan == 0 then
        self.mFanShu:setText("素番")
    elseif fan > 0 then
        self.mFanShu:setText(tostring(fan) .. "番")
    else
        self.mFanShu:setText(string.empty)
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
