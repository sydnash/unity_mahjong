--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
----------------------------------------------------------------------------
--scoredetailitem
----------------------------------------------------------------------------
local scoreDetailItem = class("scoreDetailItem", base)
_RES_(scoreDetailItem, "GameEndUI", "ScoreDetailItem")

local seatTypeName = {
    [seatType.right]    = "下家",
    [seatType.top]      = "对家",
    [seatType.left]     = "上家",
}
local detailTypeName = {
    [opType.gang.detail.angang]                     = {"下雨", "被下雨"},
    [opType.gang.detail.bagangwithmoney]            = {"刮风", "被刮风"},
    [opType.gang.detail.minggang]                   = {"下雨", "被下雨"},
    [opType.gang.detail.zhuanyu]                    = {"被转雨", "转雨"},
    [opType.gang.detail.fanyu]                      = {"被返雨", "返雨"},
    [opType.hu.detail.zimo]                         = {"自摸", "被自摸"},
    [opType.hu.detail.dianpao]                      = {"胡", "点炮"},
    [opType.hu.detail.qianggang]                    = {"抢杠", "被抢杠"},
    [opType.hu.detail.gangshanghua]                 = {"杠上花", "被杠上花"},
    [opType.hu.detail.gangshangpao]                 = {"杠上胡", "杠上炮"},
    [opType.hu.detail.tianhu]                       = {"天胡", "被天胡"},
    [opType.hu.detail.dihu]                         = {"地胡", "被地胡"},
    [opType.hu.detail.chahuazhu]                    = {"查花猪", "被查花猪"},
    [opType.hu.detail.chajiao]                      = {"查叫", "被查叫"},
    [opType.hu.detail.bijiao]                       = {"比叫", "被比叫"},
}

local fanxingTypeName = {
    [fanXingType.su]            = "平胡", 
    [fanXingType.qingYiSe]      = "清一色", 
    [fanXingType.qiDui]         = "七对", 
    [fanXingType.daDuiZi]       = "大队子", 
    [fanXingType.jinGouDiao]    = "金钩吊", 
    [fanXingType.jiangDui]      = "将对", 
    [fanXingType.yaoJiu]        = "幺九", 
    [fanXingType.menQing]       = "门清", 
    [fanXingType.zhongZhang]    = "中张", 
    [fanXingType.jiangQiDui]    = "将七对", 
    [fanXingType.jiaXinWu]      = "夹心五", 
}

function scoreDetailItem:setData(data)
    local totalPlayerCnt = clientApp.currentDesk:getTotalPlayerCount()
    self.mScore:setText(tostring(data.Score) .. "分")
    local who = {}
    for _, acId in pairs(data.BeAcIds) do
        local seatType = clientApp.currentDesk:getSeatTypeByAcId(acId)
        table.insert(who, seatTypeName[seatType])
    end
    self.mWho:setText(table.concat(who, ","))

    self.mMultiply:setText(string.empty)
    if data.Fan ~= nil and data.Fan >= 0 and data.Op == opType.hu.id then
        if data.Fan == 0 then
            self.mMultiply:setText("素番")
        else
            self.mMultiply:setText(tostring(math.abs(data.Fan / 1)) .. "番")
        end
    end

    local t = detailTypeName[data.Detail]
    if not t then
        log("error " .. data.Detail)
        return
    end
    local name1
    if data.Score > 0 then
        name1 = t[1]
    else
        name1 = t[2]
    end
    local name2

    if data.Detail ~= opType.hu.detail.bijiao then
        if data.Op == opType.hu.id then
            local names = {}
            if data.FanXing and #data.FanXing > 0 then
                for _, fanxing in pairs(data.FanXing) do
                    table.insert(names, fanxingTypeName[fanxing])
                end
            else
                table.insert(names, "平胡")
            end
            if data.IsHaiDi then
                table.insert(names, "海底")
            end
            if data.Gen and data.Gen > 0 then
                table.insert(names, tostring(data.Gen) .. "根")
            end
            if #names > 0 then
                name2 = table.concat(names, "、")
            end
        end
        if name2 ~= nil then
            name1 = name1 .. "(" .. name2 .. ")"
        end
    else
        name1 = name1 .. string.format("(%s番比%s番)", tostring(data.HuFanShu), tostring(data.BeFanShu))
        self.mMultiply:setText("")
    end
    self.mName:setText(name1)
end

----------------------------------------------------------------------------
--scoredetail
----------------------------------------------------------------------------
local scoreDetail = class("scoreDetail", base)
_RES_(scoreDetail, "GameEndUI", "ScoreDetailUI")

function scoreDetail:ctor(scoreChanges)
    self.scoreChanges = scoreChanges
    base.ctor(self)
end

function scoreDetail:onInit()
    if self.scoreChanges == nil or #self.scoreChanges == 0 then
        self.mEmpty:show()
        self.mList:hide()
    else
        self.mEmpty:hide()
        self.mList:show()

        --sort and filter changes
        self.finalChanges = {}
        table.bubbleSort(self.scoreChanges, function(t1, t2)
            return t1.Idx < t2.Idx
        end)

        for _, info in pairs(self.scoreChanges) do
            local win = {}
            local failed = {}
            local hasSelf = false
            local selfResult = 0
            for _, c in pairs(info.C) do
                if c.AcId == gamepref.player.acId then
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
                table.insert(self.finalChanges, t)
            end
        end

        self:refreshUI()
    end

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function scoreDetail:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function scoreDetail:refreshUI()
    local createItem = function()
        return scoreDetailItem.new()
    end

    local refreshItem = function(item, index)
        item:setData(self.finalChanges[index + 1])
    end

    self.mList:reset()
    self.mList:set(#self.finalChanges, createItem, refreshItem)
end

function scoreDetail:onCloseAllUIHandler()
    self:close()
end

function scoreDetail:onDestory()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    base.onDestroy(self)
end

return scoreDetail

--endregion

