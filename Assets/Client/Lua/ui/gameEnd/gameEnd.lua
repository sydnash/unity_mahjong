--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local gameEnd = class("gameEnd", base)

_RES_(gameEnd, "GameEndUI", "GameEndUI")

function gameEnd:ctor(game, datas)
    self.game  = game
    self.datas = datas

    base.ctor(self)
end

function gameEnd:onInit()
    self.items = {}
    for _, v in pairs(self.datas.players) do
        local item = self:createItem()
        item:setPlayerInfo(v, self.datas.scoreChanges)
        item:show()
        item:setParent(self.mList)
        table.insert(self.items, item)
    end

    local info = string.format("第%d/%d局  房号:%d  %s", 
                               self.datas.finishGameCount, 
                               self.datas.totalGameCount, 
                               self.datas.deskId,
                               self.game:convertConfigToString(true, true, "，"))
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
    self.mShareWX:addClickListener(self.onShareWXClickedHandler, self)
    self.mShareQYQ:addClickListener(self.onShareQYQClickedHandler, self)
    self.mShareXL:addClickListener(self.onShareXLClickedHandler, self)
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mShareCN:addClickListener(self.onShareCNClickedHandler, self)

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function gameEnd:endAll()
    if self.gameObject ~= nil then
        self.mOk:show()
        self.mNext:hide()
    end
end

function gameEnd:onOkClickedHandler()
    local ui = require("ui.gameOver.gameOver").new(self.game, self.datas)
    ui:show()

    self.game.isGameOverUIShow = true
    self.game.gameEndUI = nil
    self:close() 
    playButtonClickSound()
end

function gameEnd:onNextClickedHandler()
    self:close()
    self.game:ready(true)
    self.game.gameEndUI = nil
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

function gameEnd:onShareCNClickedHandler()
    playButtonClickSound()
    self.mSharePanel:hide()

    if deviceConfig.isMobile then
        local tex = captureScreenshotUI()
        if tex ~= nil then
            local texpath = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "gameend.jpg")
            saveTextureToJPG(texpath, tex)

            platformHelper.shareImageCn(tex, texpath)
        end
    end
end

function gameEnd:onCloseClickedHandler()
    self.game:exitPlayback()
    playButtonClickSound()
end

function gameEnd:createItem()
    if self.game.gameType == gameType.mahjong then
        return require ("ui.gameEnd.mahjong.gameEndItem").new()
    elseif self.game.gameType == gameType.doushisi then
        return require ("ui.gameEnd.doushisi.gameEndItem").new()
    elseif self.game.gameType == gameType.paodekuai then
        return require ("ui.gameEnd.paodekuai.gameEndItem").new()
    end

    log("unknown game type")
end

function gameEnd:onCloseAllUIHandler()
    self:close()
end

function gameEnd:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    for _, item in pairs(self.items) do
        item:close()
    end
    base.onDestroy(self)
end

return gameEnd

--endregion
