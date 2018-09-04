--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local desk = class("desk", base)

desk.folder = "DeskUI"
desk.resource = "DeskUI"

function desk:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function desk:onInit()
    self.mDeskInfo:setText("房间号：" .. tostring(self.game.deskId))
    self.mReady:addClickListener(self.onReadyClickedHandler, self)
    self.mCancel:addClickListener(self.onCancelClickedHandler, self)
    self.mExit:addClickListener(self.onExitClickedHandler, self)
end

function desk:onReadyClickedHandler()
    playButtonClickSound()
    self.game:ready(true)
end

function desk:onCancelClickedHandler()
    playButtonClickSound()
    self.game:ready(false)
end

function desk:onExitClickedHandler()
    playButtonClickSound()

    showMessage("确定要离开房间退出游戏吗？", 
        function()
            self.game:endGame()
        end,
        function()
            --
        end)
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

function desk:reset()
    self.mReady:show()
    self.mCancel:hide()
end

return desk

--endregion
