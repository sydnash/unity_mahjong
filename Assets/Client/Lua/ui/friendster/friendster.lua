--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local friendster_Lc = require("logic.friendster.friendster")

local base = require("ui.common.view")
local friendster = class("friendster", base)

_RES_(friendster, "FriendsterUI", "FriendsterUI")

function friendster:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mTabMyU:addClickListener(self.onMyClickedHandler, self)
    self.mTabJoinedU:addClickListener(self.onJoinedClickedHandler, self)
    self.mTabGuideU:addClickListener(self.onGuideClickedHandler, self)
    self.mCreate:addClickListener(self.onCreateClickedHandler, self)
    self.mJoin:addClickListener(self.onJoinClickedHandler, self)
    
    self.mTabMyS:show()
    self.mTabMyU:hide()
    self.mTabJoinedS:hide()
    self.mTabJoinedU:show()
    self.mTabGuideS:hide()
    self.mTabGuideU:show()

    self.mPageRows:show()
    self.mPageGuide:hide()

    self.mCreate:show()
    self.mJoin:hide()

    signalManager.registerSignalHandler(signalType.enterDeskSignal, self.onEnterDeskHandler, self)
end

function friendster:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function friendster:onMyClickedHandler()
    playButtonClickSound()

    self.mTabMyS:show()
    self.mTabMyU:hide()
    self.mTabJoinedS:hide()
    self.mTabJoinedU:show()
    self.mTabGuideS:hide()
    self.mTabGuideU:show()

    self.mPageRows:show()
    self.mPageGuide:hide()

    self.mCreate:show()
    self.mJoin:hide()

    self:refreshList(self.my)
end

function friendster:onJoinedClickedHandler()
    playButtonClickSound()

    self.mTabMyS:hide()
    self.mTabMyU:show()
    self.mTabJoinedS:show()
    self.mTabJoinedU:hide()
    self.mTabGuideS:hide()
    self.mTabGuideU:show()

    self.mPageRows:show()
    self.mPageGuide:hide()

    self.mCreate:hide()
    self.mJoin:show()

    self:refreshList(self.joined)
end

function friendster:onGuideClickedHandler()
    playButtonClickSound()

    self.mTabMyS:hide()
    self.mTabMyU:show()
    self.mTabJoinedS:hide()
    self.mTabJoinedU:show()
    self.mTabGuideS:show()
    self.mTabGuideU:hide()

    self.mPageRows:hide()
    self.mPageGuide:show()
end

function friendster:onCreateClickedHandler()
    playButtonClickSound()

    local ui = require("ui.friendster.createFriendster").new(function(friendster)
        table.insert(self.my, friendster)

        table.sort(self.my, function(a, b)
            return a.ClubId < b.ClubId
        end)

        self:refreshList(self.my)
    end)
    ui:show()
end

function friendster:onJoinClickedHandler()
    playButtonClickSound()

    local ui = require("ui.friendster.joinFriendster").new(function(friendster)
        table.insert(self.joined, friendster)

        table.sort(self.joined, function(a, b)
            return a.ClubId < b.ClubId
        end)

        self:refreshList(self.joined)
    end)
    ui:show()
end

function friendster:set(data, enterDeskCallback)
    local friendsters = {}

    for _, v in pairs(data) do
        local lc = friendster_Lc.new(v.ClubId)

        lc.name             = v.ClubName
        lc.headerUrl        = v.HeadUrl
        lc:loadHeaderTex()
        lc.cards            = v.CurCardNum
        lc.maxMemberCount   = v.MaxMemberCnt
        lc.curMemberCount   = v.CurMemberCnt
        lc.applyCode        = v.ApplyCode
        lc.managerAcId      = v.AcId
        lc.managerNickname  = v.NickName

        table.insert(friendsters, lc)
    end

    table.sort(friendsters, function(a, b)
        return a.id < b.id
    end)

    self.my = {}
    self.joined = {}

    for _, d in pairs(friendsters) do 
        if d.managerAcId == gamepref.acId then
            table.insert(self.my, d)
        else
            table.insert(self.joined, d)
        end
    end 
    
    self:refreshList(self.my)
    self.enterDeskCallback = enterDeskCallback
end

function friendster:refreshList(data)
    self.mList:reset()

    local createItem = function()
        return require("ui.friendster.friendsterItem").new(function(cityType, deskId, loading)
            if self.enterDeskCallback ~= nil then
                self.enterDeskCallback(cityType, deskId, loading)
            end
            self:close()
        end)
    end

    local refreshItem = function(item, index)
        item:set(data[index + 1])
    end
    
    local count = data ~= nil and #data or 0
    self.mList:set(count, createItem, refreshItem)
end

function friendster:onEnterDeskHandler()
    self:close()
end

function friendster:onDestroy()
    signalManager.unregisterSignalHandler(signalType.enterDeskSignal, self.onEnterDeskHandler, self)

    self.mList:reset()

    for _, v in pairs(self.my) do
        v:destroy()
    end

    for _, v in pairs(self.joined) do
        v:destroy()
    end

    self.my = nil
    self.joined = nil

    self.super.onDestroy(self)
end

return friendster

--endregion
