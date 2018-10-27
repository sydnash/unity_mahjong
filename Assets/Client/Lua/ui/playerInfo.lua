--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local playerInfo = class("playerInfo", base)

_RES_(playerInfo, "PlayerInfoUI", "PlayerInfoUI")

function playerInfo:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    
    self.mIp:hide()
end

function playerInfo:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function playerInfo:set(data)
    self.mIcon:setTexture(data.headerTex)
    self.mSex:setSprite("boy")
    self.mNickname:setText(data.nickname)

    self.mId:setText(string.format("账号:%d", data.acId))

    if not string.isNilOrEmpty(data.ip) then
        self.mIp:show()
        self.mIp:setText(string.format("IP:%s", data.ip))
    end

--    self.mTotalCount:setText(string.format("总局数:%d", data.totalPlayTimes))

--    local winRate = (data.totalPlayTimes == 0) and 0 or math.floor(data.winPlayTimes / data.totalPlayTimes * 100)
--    self.mWinRate:setText(string.format("胜率:%d%%", winRate))
end

return playerInfo

--endregion
