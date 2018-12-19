--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local gameOver = class("gameOver", base)

_RES_(gameOver, "GameOverUI", "GameOverUI")

function gameOver:ctor(game, datas)
    self.game  = game
    self.datas = datas
    self.super.ctor(self)
end

function gameOver:onInit()
    self.mDeskId:setText(string.format("房号:%d", self.datas.deskId))
    self.mFinishCount:setText(string.format("已打%d/%d局", self.datas.finishGameCount, self.datas.totalGameCount))
    self.mDateTime:setText(time.formatDateTime())

    self.items = { self.mItemA, self.mItemB, self.mItemC, self.mItemD, }

    local i = 0
    for k, v in pairs(self.datas.players) do
        i = i + 1
        local item = self.items[i]
        item:setPlayerInfo(v)
        item:show()
    end
    for j = i + 1, 4 do
        self.items[j]:hide()
    end

    self.mSharePanel:hide()

    self.mConfirm:addClickListener(self.onConfirmClickedHandler, self)
    self.mShare:addClickListener(self.onShareClickedHandler, self)
    self.mSharePanel:addClickListener(self.onSharePanelClickedHandler, self)
    self.mShareWX:addClickListener(self.onShareWXClickedHandler, self)
    self.mShareQYQ:addClickListener(self.onShareQYQClickedHandler, self)
    self.mShareXL:addClickListener(self.onShareXLClickedHandler, self)

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function gameOver:onConfirmClickedHandler()
    playButtonClickSound()
    gamepref.player.currentDesk = nil

    self.game:exitGame() 
    self:close()
end

function gameOver:onShareClickedHandler()
    playButtonClickSound()
    self.mSharePanel:show()
end

function gameOver:onSharePanelClickedHandler()
    playButtonClickSound()
    self.mSharePanel:hide()
end

function gameOver:onShareWXClickedHandler()
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

function gameOver:onShareQYQClickedHandler()
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

function gameOver:onShareXLClickedHandler()
    playButtonClickSound()
    self.mSharePanel:hide()

    if deviceConfig.isMobile then
        local tex = captureScreenshotUI()

        if tex ~= nil then
            platformHelper.shareImageSg(tex)
        end
    end
end

function gameOver:onCloseAllUIHandler()
    self:close()
end

function gameOver:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    
    for _, v in pairs(self.items) do
        v.mIcon:reset()
    end

    self.super.onDestroy(self)
end

return gameOver

--endregion
