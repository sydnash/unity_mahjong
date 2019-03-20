--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local gameOver = class("gameOver", base)

_RES_(gameOver, "GameOverUI", "GameOverUI")

function gameOver:ctor(game, datas)
    self.game  = game
    self.datas = datas
    base.ctor(self)
end

function gameOver:onInit()
    if self.game.friendsterId <= 0 then
        self.mTextL:setText(string.format("%s%s:%d  第%d/%d局", cityName[self.game.cityType], gameName[self.game.cityType].games[self.game.gameType], self.datas.deskId, self.datas.finishGameCount, self.datas.totalGameCount))
    else
        self.mTextL:setText(string.format("俱乐部:%d\n%s%s:%d  第%d/%d局", self.game.friendsterId, cityName[self.game.cityType], gameName[self.game.cityType].games[self.game.gameType], self.datas.deskId, self.datas.finishGameCount, self.datas.totalGameCount))
    end
    self.mDateTime:setText(time.formatDateTimeWithoutSecond())

    local eventName = "gameover_" .. tostring(self.game.cityType) .. "_" .. tostring(self.game.gameType)
    talkingData.event(eventName, {play = self.datas.finishGameCount, total = self.datas.totalGameCount}, true)


    local info = self.game:convertConfigToString(true, true, "，")
    self.mTextR:setText(info)

    self.game:markWinners(self.datas.players)
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
    self.mShareCN:addClickListener(self.onShareCNClickedHandler, self)

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

function gameOver:onShareCNClickedHandler()
    playButtonClickSound()
    self.mSharePanel:hide()

    if deviceConfig.isMobile then
        local tex = captureScreenshotUI()
        if tex ~= nil then
            local texpath = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "gameover.jpg")
            saveTextureToJPG(texpath, tex)

            platformHelper.shareImageCn(tex, texpath)
        end
    end
end

function gameOver:onCloseAllUIHandler()
    self:close()
end

function gameOver:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    base.onDestroy(self)
end

return gameOver

--endregion
