--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local createDesk = class("createDesk", base)

_RES_(createDesk, "CreateDeskUI", "CreateDeskUI")

function createDesk:ctor(callback)
    self.callback = callback
    self.super.ctor(self)
end

function createDesk:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mCreate:addClickListener(self.onCreateClickedHandler, self)
end

function createDesk:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function createDesk:onCreateClickedHandler()
    playButtonClickSound()

    local loading = require("ui.loading").new()
    loading:show()

    local choose = { }
    local friendsterId = self.friendsterId == nil and 0 or self.friendsterId

    networkManager.createDesk(self.cityType, choose, friendsterId, function(ok, msg)
        if not ok then
            loading:close()
            showMessageUI("网络繁忙，请稍后再试")
            return
        end

        log("create desk, msg = " .. table.tostring(msg))

        if msg.RetCode ~= retc.Ok then
            loading:close()
            showMessageUI(retcText[msg.RetCode])
            return
        end

        if self.callback ~= nil then
            self.callback(msg.GameType, msg.DeskId, loading)
        end

        self:close()
    end)
end

function createDesk:set(cityType, friendsterId)
    self.cityType = cityType
    self.friendsterId = friendsterId
end

return createDesk

--endregion
