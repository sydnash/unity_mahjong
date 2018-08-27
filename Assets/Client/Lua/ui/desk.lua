--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local desk = class("desk", base)

desk.folder = "deskui"
desk.resource = "deskui"

function desk:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function desk:onInit()
    self.mDeskInfo:setText("房间号：" .. tostring(self.game.deskId))
    self.mReady:addClickListener(self.onReadyClickedHandler, self)
    self.mCancel:addClickListener(self.onCancelClickedHandler, self)
end

function desk:onReadyClickedHandler()
    self.game:ready(true)
end

function desk:onCancelClickedHandler()
    self.game:ready(false)
end

function desk:setReady(acId, ready)
    if acId == gamepref.acId then
        if ready then
            self.mReady:hide()
            self.mCancel:show()
        else
            self.mReady:show()
            self.mCancel:hide()
        end
    else
        --其他的准备状态改变
    end
end

function desk:onGameStart()
    self.mReady:hide()
    self.mCancel:hide()
end

return desk

--endregion
