--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local share = class("share", base)

_RES_(share, "ShareUI", "ShareUI")

local imagePath = "sharetex"
local imageName = "lobby_share_image"

function share:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mHY:addClickListener(self.onHyClickedHandler, self)
    self.mPYQ:addClickListener(self.onPyqClickedHandler, self)
    self.mCN:addClickListener(self.onCnClickedHandler, self)

    self:updateTips()
    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function share:updateTips()
    local cnt = gamepref.player.shareConfig.count
    local curCnt = gamepref.player.shareFKTimes
    local text = string.format("每日不足%d张可以获得%d次分享补充房卡的机会（%d/%d）", gamepref.player.shareConfig.lowLimit, cnt, curCnt, cnt)
    self.mTips:setText(text)
end

function share:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function share:onHyClickedHandler()
    playButtonClickSound()

    local tex = textureManager.load(imagePath, imageName)
    if tex ~= nil then
        local thumb = getSizedTexture(tex, gameConfig.thumbSize, gameConfig.thumbSize)
        platformHelper.shareImageWx(tex, thumb, false)
        textureManager.unload(tex)
        destroyTexture(thumb)
    end
end

function share:claimShareCardsReward()
    if gamepref.player.cards >= gamepref.player.shareConfig.lowLimit then
        return
    end
    if gamepref.player.shareFKTimes >= gamepref.player.shareConfig.count then
        return
    end

    showWaitingUI("正在领取房卡，请稍候")
    networkManager.claimShareReward(function(msg)
        closeWaitingUI()
        if not msg then
            showMessageUI("领取失败")
        end

        gamepref.player.cards = msg.CurCoin
        signalManager.signal(signalType.cardsChanged)
        local claimedCnt = msg.ClaimedCnt
        gamepref.player.shareFKTimes = claimedCnt

        self:updateTips()
        if not msg.Ok then
            showMessageUI("领取失败")
            return
        end
        self:updateTips()
        showMessageUI(string.format("成功领取%d张房卡", msg.AddCoin))
    end)
end

function share:onPyqClickedHandler()
    playButtonClickSound()

    self:claimShareCardsReward()
    local tex = textureManager.load(imagePath, imageName)
    if tex ~= nil then
        local thumb = getSizedTexture(tex, gameConfig.thumbSize, gameConfig.thumbSize)
        platformHelper.registerShareWXCallback(function(jsonstr)
            platformHelper.registerShareWXCallback(nil)
            local obj = json.decode(jsonstr)
            self:claimShareCardsReward()
        end)
        platformHelper.shareImageWx(tex, thumb, true)
        textureManager.unload(tex)
        destroyTexture(thumb)
    end
end

function share:onCnClickedHandler()
    playButtonClickSound()

    local texpath = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, imageName .. ".jpg")
    if not LFS.FileExist(texpath) then
        local tex = textureManager.load(imagePath, imageName)
        if tex ~= nil then
            saveTextureToJPG(texpath, tex)
            textureManager.unload(tex)
        end
    end
        
    platformHelper.shareImageCn(texpath)
end

function share:onCloseAllUIHandler()
    self:close()
end

function share:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    base.onDestroy(self)
end

return share

--endregion
