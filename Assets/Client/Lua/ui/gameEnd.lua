--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mahjongGame = require("logic.mahjong.mahjongGame")

local base = require("ui.common.view")
local gameEnd = class("gameEnd", base)

_RES_(gameEnd, "GameEndUI", "GameEndUI")

function gameEnd:ctor(game, datas)
    self.game  = game
    self.datas = datas

    self.super.ctor(self)
end

function gameEnd:onInit()
    local items = { 
        self.mItemM, 
        self.mItemR, 
        self.mItemT, 
        self.mItemL, 
    }

    local i = 1
    for _, v in pairs(self.datas.players) do
        local item = items[i]
        item:setPlayerInfo(v)
        i = i + 1
    end
    for j = i,4 do
        items[j]:hide()
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

    self.mSharePanel:hide()

    self.mOk:addClickListener(self.onOkClickedHandler, self)
    self.mNext:addClickListener(self.onNextClickedHandler, self)
    self.mShare:addClickListener(self.onShareClickedHandler, self)
    self.mSharePanel:addClickListener(self.onSharePanelClickedHandler, self)
    self.mRecord:addClickListener(self.onRecordClickedHandler, self)
    self.mShareWX:addClickListener(self.onShareWXClickedHandler, self)
    self.mShareQYQ:addClickListener(self.onShareQYQClickedHandler, self)
    self.mShareXL:addClickListener(self.onShareXLClickedHandler, self)
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
    self.mSharePanel:show()
end

function gameEnd:onSharePanelClickedHandler()
    playButtonClickSound()
    self.mSharePanel:hide()
end

function gameEnd:onRecordClickedHandler()
    playButtonClickSound()
end

function gameEnd:onShareWXClickedHandler()
    playButtonClickSound()
    self.mSharePanel:hide()

    if deviceConfig.isMobile then
        local tex = captureScreenshotUI()

        if tex ~= nil then
            local thumb = getSizedTexture(tex, gameConfig.thumbSize, gameConfig.thumbSize)
            platformHelper.shareImageWx(tex, thumb, false)
        end
    end
end

function gameEnd:onShareQYQClickedHandler()
    playButtonClickSound()
    self.mSharePanel:hide()

    if deviceConfig.isMobile then
        local tex = captureScreenshotUI()

        if tex ~= nil then
            local thumb = getSizedTexture(tex, gameConfig.thumbSize, gameConfig.thumbSize)
            platformHelper.shareImageWx(tex, thumb, true)
        end
    end
end

function gameEnd:onShareXLClickedHandler()
    playButtonClickSound()
    self.mSharePanel:hide()

    if deviceConfig.isMobile then
        local tex = captureScreenshotUI()

        if tex ~= nil then
            platformHelper.shareImageSg(tex)
        end
    end
end

return gameEnd

--endregion
