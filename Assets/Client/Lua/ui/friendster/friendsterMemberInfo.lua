--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterMemberInfo = class("friendsterMemberInfo", base)

_RES_(friendsterMemberInfo, "FriendsterUI", "FriendsterMemberInfoUI")

function friendsterMemberInfo:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mExit:addClickListener(self.onExitClickedHandler, self)
    self.mDissolve:addClickListener(self.onDissolveClickedHandler, self)

    self.mIp:hide()
    self.mQz:hide()
    self.mExit:hide()
    self.mDissolve:hide()
end

function friendsterMemberInfo:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function friendsterMemberInfo:onExitClickedHandler()
    playButtonClickSound()
    self:close()
end

function friendsterMemberInfo:onDissolveClickedHandler()
    playButtonClickSound()
    self:close()
end

function friendsterMemberInfo:set(managerId, data)
    self.mIcon:setTexture(data.headerTex)
    self.mSex:setSprite("boy")
    self.mNickname:setText(data.nickname)

    if managerId == data.acId then
        self.mQz:show()

        if data.acId == gamepref.acId then
            self.mDissolve:show()
        else
            self.mExit:show()
        end
    end

    self.mId:setText(string.format("账号:%d", data.acId))

    if data.ip ~= nil then
        self.mIp:show()
        self.mIp:setText(string.format("IP:", data.ip))
    end

    self.mTotalCount:setText(string.format("总局数:%d", data.totalPlayTimes))

    local winRate = (data.totalPlayTimes == 0) and 0 or math.floor(data.winPlayTimes / data.totalPlayTimes * 100)
    self.mWinRate:setText(string.format("胜率:%d%%", winRate))
end

return friendsterMemberInfo

--endregion
