--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

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

    if self.game.mode == gameMode.playback  then
        self.mOk:hide()
        self.mNext:hide()
        self.mClose:show()
    elseif self.datas.totalGameCount > self.datas.finishGameCount then
        self.mOk:hide()
        self.mNext:show()
        self.mClose:hide()
    else
        self.mOk:show()
        self.mNext:hide()
        self.mClose:hide()
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
    self.mClose:addClickListener(self.onCloseClickedHandler, self)

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function gameEnd:endAll()
    if self.gameObject ~= nil then
        self.mOk:show()
        self.mNext:hide()
    end
end

function gameEnd:onOkClickedHandler()
    local ui = require("ui.gameOver").new(self.game, self.datas)
    ui:show()

    self:close() 
    playButtonClickSound()
end

function gameEnd:onNextClickedHandler()
    self:close()
    self.game:ready(true)
    playButtonClickSound()
end

function gameEnd:onShareClickedHandler()
    self.mSharePanel:show()
    playButtonClickSound()
end

function gameEnd:onSharePanelClickedHandler()
    self.mSharePanel:hide()
    playButtonClickSound()
end

function gameEnd:onRecordClickedHandler()
    local ui = require ("ui.GameEnd.ScoreDetail").new(self.datas.scoreChanges)
    ui:show()

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
            destroyTexture(thumb)
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
            destroyTexture(thumb)
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

function gameEnd:onCloseClickedHandler()
    self.game:exitPlayback()
    playButtonClickSound()
end

function gameEnd:onCloseAllUIHandler()
    self:close()
end

function gameEnd:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end

return gameEnd

--endregion
