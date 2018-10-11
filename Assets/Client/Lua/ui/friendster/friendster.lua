--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendster = class("friendster", base)

_RES_(friendster, "FriendsterUI", "FriendsterUI")

local function createItem()
    return require("ui.friendster.friendsterItem").new()
end

function friendster:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mTabMyU:addClickListener(self.onMyClickedHandler, self)
    self.mTabJoinedU:addClickListener(self.onJoinedClickedHandler, self)
    self.mTabGuideU:addClickListener(self.onGuideClickedHandler, self)
    self.mCreate:addClickListener(self.onCreateClickedHandler, self)
    
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

    local ui = require("ui.friendster.createFriendster").new()
    ui:show()
end

function friendster:set(datas)
    self.my = {}
    self.joined = {}

    for _, d in pairs(datas) do 
        if d.AcId == gamepref.acId then
            table.insert(self.my, d)
        else
            table.insert(self.joined, d)
        end
    end 
    
    self:refreshList(self.my)
end

function friendster:refreshList(data)
    self.mList:reset()
    local count = data ~= nil and #data or 0
    
    self.mList:set(count, createItem, function(item, index)
        item:set(data[index + 1])
    end)
end

return friendster

--endregion
