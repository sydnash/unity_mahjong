--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local gameEnd = class("gameEnd", base)

gameEnd.folder = "GameEndUI"
gameEnd.resource = "GameEndUI"

function gameEnd:ctor(game, datas)
    self.game  = game
    self.datas = datas

    self.super.ctor(self)
end

function gameEnd:onInit()
    local items = { self.mItemM, self.mItemR, self.mItemT, self.mItemL, }

    for _, v in pairs(self.datas.players) do
        local item = items[v.seat + 1]
        item:setPlayerInfo(v)
    end

    local info = string.format("第%d/%d局  房号:%d", self.datas.finishGameCount, self.datas.totalGameCount, self.datas.deskId)
    self.mInfo:setText(info)

    if self.datas.totalGameCount > self.datas.finishGameCount then
        self.mOk:hide()
        self.mNext:show()
    else
        self.mOk:show()
        self.mNext:hide()
    end

    self.mOk:addClickListener(self.onOkClickedHandler, self)
    self.mNext:addClickListener(self.onNextClickedHandler, self)
    self.mShare:addClickListener(self.onShareClickedHandler, self)
    self.mRecord:addClickListener(self.onRecordClickedHandler, self)
end

function gameEnd:endAll()
    if self.gameObject ~= nil then
        self.mOk:show()
        self.mNext:hide()
    end
end

function gameEnd:onOkClickedHandler()
    playButtonClickSound()

    local ui = require("ui.gameOver").new(self.game, self.datas)
    ui:show()

    self:close() 
end

function gameEnd:onNextClickedHandler()
    playButtonClickSound()

    self:close()
    self.game:ready(true)  
end

function gameEnd:onShareClickedHandler()
    playButtonClickSound()
end

function gameEnd:onRecordClickedHandler()
    playButtonClickSound()
end

function gameEnd:onDestroy()
end

return gameEnd

--endregion
