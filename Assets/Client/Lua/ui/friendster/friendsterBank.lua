--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local friendsterBank = class("friendsterBank", base)

_RES_(friendsterBank, "FriendsterUI", "FriendsterBankUI")

function friendsterBank:ctor(data)
    self.data = data
    self.super.ctor(self)
end

function friendsterBank:onInit()
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mTabDeposit:addClickListener(self.onTabDepositClickedHandler, self)
    self.mTabTakeout:addClickListener(self.onTabTakeoutClickedHandler, self)
    self.mDeposit:addClickListener(self.onDepositClickedHandler, self)
    self.mTakeout:addClickListener(self.onTakeoutClickedHandler, self)

    self.mTabDeposit:hide()
    self.mTabDepositS:show()
    self.mTabTakeout:show()
    self.mTabTakeoutS:hide()

    self.mTotalLabel:setText("房卡总数")
    self.mCurrentLabel:setText("存入数量")
    self.mTotal:setText(tostring(gamepref.player.cards))
    self.mCurrent:setText(string.empty)

    self.mDeposit:show()
    self.mTakeout:hide()

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function friendsterBank:onCloseClickedHandler()
    self:close()
    playButtonClickSound()
end

function friendsterBank:onTabDepositClickedHandler()
    self.mTabDeposit:hide()
    self.mTabDepositS:show()
    self.mTabTakeout:show()
    self.mTabTakeoutS:hide()

    self.mTotalLabel:setText("房卡总数")
    self.mCurrentLabel:setText("存入数量")
    self.mTotal:setText(tostring(gamepref.player.cards))
    self.mCurrent:setText(string.empty)

    self.mDeposit:show()
    self.mTakeout:hide()

    playButtonClickSound()
end

function friendsterBank:onTabTakeoutClickedHandler()
    self.mTabDeposit:show()
    self.mTabDepositS:hide()
    self.mTabTakeout:hide()
    self.mTabTakeoutS:show()

    self.mTotalLabel:setText("亲友圈房卡")
    self.mCurrentLabel:setText("取出数量")
    self.mTotal:setText(tostring(self.data.cards))
    self.mCurrent:setText(string.empty)

    self.mDeposit:hide()
    self.mTakeout:show()

    playButtonClickSound()
end

function friendsterBank:onDepositClickedHandler()
    local value = math.min(gamepref.player.cards, tonumber(self.mCurrent:getText()))

    showWaitingUI("正在存入房卡，请稍候")
    networkManager.depositToFriendsterBank(self.data.id, value, function(msg)
        closeWaitingUI()

        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY)
            return
        end

--        log("deposit to friendster bank, msg = " .. table.tostring(msg))
        self.data.cards = self.data.cards + value
        gamepref.player.cards = gamepref.player.cards - value

        signalManager.signal(signalType.cardsChanged)
        self:close()
    end)

    playButtonClickSound()
end

function friendsterBank:onTakeoutClickedHandler()
    local value = math.min(self.data.cards, tonumber(self.mCurrent:getText()))

    showWaitingUI("正在取出房卡，请稍候")
    networkManager.takeoutFromFriendsterBank(self.data.id, value, function(msg)
        closeWaitingUI()

        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY)
            return
        end

--        log("takeout from friendster bank, msg = " .. table.tostring(msg))
        self.data.cards = self.data.cards - value
        gamepref.player.cards = gamepref.player.cards + value

        signalManager.signal(signalType.cardsChanged)
        self:close()
    end)

    playButtonClickSound()
end

function friendsterBank:onCloseAllUIHandler()
    self:close()
end

function friendsterBank:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    self.super.onDestroy(self)
end

return friendsterBank

--endregion
