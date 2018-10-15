--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterStatistics = class("friendsterStatistics", base)

_RES_(friendsterStatistics, "FriendsterUI", "FriendsterStatisticsUI")

local filter = {
    today       = 1,
    yestoday    = 2,
}

function friendsterStatistics:onInit()
    self.mReturn:addClickListener(self.onReturnClickedHandler, self)
    self.mTabHistory:addClickListener(self.onTabHistoryClickedHandler, self)
    self.mTabRank:addClickListener(self.onTabRankClickedHandler, self)
    self.mPageHistory_TabToday:addClickListener(self.onHistoryTabToadyClickedHandler, self)
    self.mPageHistory_TabYestoday:addClickListener(self.onHistoryTabYestoadyClickedHandler, self)
    self.mPageRank_TabToday:addClickListener(self.onRankTabToadyClickedHandler, self)
    self.mPageRank_TabYestoday:addClickListener(self.onRankTabYestoadyClickedHandler, self)

    self.mTabHistoryS:show()
    self.mTabHistory:hide()
    self.mTabRankS:hide()
    self.mTabRank:show()

    self.mPageHistory:show()
    self.mPageRank:hide()
end

function friendsterStatistics:onReturnClickedHandler()
    playButtonClickSound()
    self:close()
end

function friendsterStatistics:onTabHistoryClickedHandler()
    playButtonClickSound()

    self.mTabHistoryS:show()
    self.mTabHistory:hide()
    self.mTabRankS:hide()
    self.mTabRank:show()

    self.mPageHistory:show()
    self.mPageRank:hide()

    self.filter = filter.today
    self:refreshHistory()
end

function friendsterStatistics:onTabRankClickedHandler()
    playButtonClickSound()

    self.mTabHistoryS:hide()
    self.mTabHistory:show()
    self.mTabRankS:show()
    self.mTabRank:hide()

    self.mPageHistory:hide()
    self.mPageRank:show()

    self.filter = filter.today
    self:refreshRank()
end

function friendsterStatistics:onHistoryTabToadyClickedHandler()
    playButtonClickSound()

    self.filter = filter.today
    self:refreshHistory()
end

function friendsterStatistics:onHistoryTabYestoadyClickedHandler()
    playButtonClickSound()

    self.filter = filter.yestoday
    self:refreshHistory()
end

function friendsterStatistics:onRankTabToadyClickedHandler()
    playButtonClickSound()

    self.filter = filter.today
    self:refreshRank()
end

function friendsterStatistics:onRankTabYestoadyClickedHandler()
    playButtonClickSound()

    self.filter = filter.yestoday
    self:refreshRank()
end

function friendsterStatistics:set(data)
    self.mCastCount:setText(string.format("消耗房卡:%d", 123))
    self.mTotalCount:setText(string.format("建房总数:%d", 456))

    self.mPageHistory:show()
    self.mPageRank:hide()

    self.history = {
        [filter.today]    = {},
        [filter.yestoday] = {},
    }
    self.rank = {
        [filter.today]    = {},
        [filter.yestoday] = {},
    }

    for _, v in pairs(data) do
        
    end

    self.filter = filter.today
    self:refreshHistory()
end

function friendsterStatistics:refreshHistory()
    if self.filter == filter.today then
        self.mPageHistory_TabTodayS:show()
        self.mPageHistory_TabToday:hide()
        self.mPageHistory_TabYestodayS:hide()
        self.mPageHistory_TabYestoday:show()
    else
        self.mPageHistory_TabTodayS:hide()
        self.mPageHistory_TabToday:show()
        self.mPageHistory_TabYestodayS:show()
        self.mPageHistory_TabYestoday:hide()
    end

    local histories = self.history[self.filter]
    local count = #histories

    if count <= 0 then
        self.mHistoryEmpty:show()
        self.mHistoryList:hide()
    else
        self.mHistoryEmpty:hide()
        self.mHistoryList:show()

        local createItem = function()
            return require("ui.friendster.FriendsterStatisticsHistoryItem").new()
        end

        local refreshItem = function(item, index)

        end

        self.mHistoryList:reset()
        self.mHistoryList:set(count, createItem, refreshItem)
    end
end

function friendsterStatistics:refreshRank()
    if self.filter == filter.today then
        self.mPageRank_TabTodayS:show()
        self.mPageRank_TabToday:hide()
        self.mPageRank_TabYestodayS:hide()
        self.mPageRank_TabYestoday:show()
    else          
        self.mPageRank_TabTodayS:hide()
        self.mPageRank_TabToday:show()
        self.mPageRank_TabYestodayS:show()
        self.mPageRank_TabYestoday:hide()
    end

    local ranks = self.rank[self.filter]
    local count = #ranks

    if count <= 0 then
        self.mRankEmpty:show()
        self.mRankList:hide()
    else
        self.mRankEmpty:hide()
        self.mRankList:show()

        local createItem = function()
            return require("ui.friendster.FriendsterStatisticsRankItem").new()
        end

        local refreshItem = function(item, index)

        end

        self.mRankList:reset()
        self.mRankList:set(count, createItem, refreshItem)
    end
end

function friendsterStatistics:onDestroy()
    self.mHistoryList:reset()
    self.mRankList:reset()

    self.super.onDestroy(self)
end

return friendsterStatistics

--endregion
