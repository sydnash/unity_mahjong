--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterDetail = class("friendsterDetail", base)

_RES_(friendsterDetail, "FriendsterUI", "FriendsterDetailUI")

local function createMemberItem()
    return require("ui.friendster.friendsterDetailMemberItem").new()
end

local function createDeskItem()
    return require("ui.friendster.friendsterDetailDeskItem").new()
end

function friendsterDetail:onInit()
    self.mReturn:addClickListener(self.onCloseClickedHandler, self)

    self.mMail:hide()
    self.mBank:hide()
    self.mStatistics:hide()
end

function friendsterDetail:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function friendsterDetail:set(data, members, desks)
    self.data = data
    self.members = members
    self.desks = {}

    for i=1, #desks, 2 do
        local idx = math.ceil(i / 2)
        self.desks[idx] = { L = desks[i], R = desks[i + 1] }
    end

    self:refreshUI()
end

function friendsterDetail:refreshUI()
    if self.data.AcId == gamepref.acId then
        self.mMail:show()
        self.mBank:show()
        self.mStatistics:show()
    end

    self.mName:setText(self.data.ClubName)
    self.mCards:setText(tostring(self.data.CurCardNum))

    self.mMemberList:set(#self.members, createMemberItem, function(item, index)
        item:set(self.data.AcId, self.members[index + 1])
    end)

    self.mDeskList:set(#self.desks, createDeskItem, function(item, index)
        item:set(self.desks[index + 1])
    end)
end

return friendsterDetail

--endregion
