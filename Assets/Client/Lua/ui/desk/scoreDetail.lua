--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
----------------------------------------------------------------------------
--scoredetailitem
----------------------------------------------------------------------------
local scoreDetailItem = class("scoreDetailItem", base)
_RES_(scoreDetailItem, "DeskUI", "ScoreDetailItem")

function scoreDetailItem:setData(data)
    local nodes = {self.mTitle, self.mP1, self.mP2, self.mP3, self.mP4}
    for _, t in pairs(nodes) do
        t:hide()
    end
    for idx, info in pairs(data) do
        nodes[idx]:show()
        nodes[idx]:setText(info)
    end
end

----------------------------------------------------------------------------
--scoredetail
----------------------------------------------------------------------------
local scoreDetail = class("scoreDetail", base)
_RES_(scoreDetail, "DeskUI", "ScoreDetailUI")

function scoreDetail:ctor(game)
    self.sd = game.gameScoreDetail
    self.game = game
    base.ctor(self)
end

function scoreDetail:onInit()
    if json.isNilOrNull(self.sd) or #self.sd == 0 then
        self.mEmpty:show()
        self.mList:hide()
    else
        self.mEmpty:hide()
        self.mList:show()

        local dataList = {}
        local obj1 
        for idx, str in pairs(self.sd) do
            local obj = table.fromjson(str)
            obj1 = obj
            local t1 = {}
            table.insert(t1, string.format("第%d/%d局", idx, self.game:getTotalGameCount()))
            for _, info in pairs(obj) do
                table.insert(t1, string.format("%d分", info.Score))
            end
            table.insert(dataList, t1)
        end
        local t1 = dataList[1]
        local head = {}
        local total = {}
        table.insert(head, "局数")
        table.insert(total, "总计：")
        for _, info in pairs(obj1) do
            local player = self.game:getPlayerByAcId(info.AcId)
            local name = cutoutString(player.nickname, gameConfig.nicknameMaxLength)
            table.insert(head, name)
            table.insert(total, string.format("%d分", player.score))
        end
        table.insert(dataList, 1, head)

        self.total = total
        self.showData = dataList 
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
    local nodes = {self.mTitle, self.mP1, self.mP2, self.mP3, self.mP4}
    for _, t in pairs(nodes) do
        t:hide()
    end
    for idx, info in pairs(self.total) do
        nodes[idx]:show()
        nodes[idx]:setText(info)
    end

    local createItem = function()
        return scoreDetailItem.new()
    end

    local refreshItem = function(item, index)
        item:setData(self.showData[index + 1])
    end

    self.mList:reset()
    self.mList:set(#self.showData, createItem, refreshItem)
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

