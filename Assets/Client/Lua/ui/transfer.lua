--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local transfer = class("transfer", base)

_RES_(transfer, "PlayerInfoUI", "TransferUI")

function transfer:ctor()
    base.ctor(self)
end

function transfer:onInit()
    --buttons
    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mQuery:addClickListener(self.onQueryClickedHandler, self)
    self.mTransfer:addClickListener(self.onTransferClickedHandler, self)
    --input fields
    self.mId:addChangedListener(self.onIdChangedHandler, self)
    self.mCount:addChangedListener(self.onCountChangeHandler, self)

    self.mId:setText(string.empty)
    self.mCount:setText(string.empty)
    self.mNickname:setText(string.empty)

    signalManager.registerSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
end

function transfer:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function transfer:onQueryClickedHandler()
    playButtonClickSound()

    local id = tonumber(self.mId:getText())
    if id == nil then
        showMessageUI("请输入正确玩家ID")
        return
    end
    
    showWaitingUI("正在查询玩家信息，请稍候")
    networkManager.queryAcId(id, function(msg)
        closeWaitingUI()

        if not msg then
            showMessageUI("网络繁忙，请稍后再试")
            return
        end

        log("query player info, msg = " .. table.tostring(msg))
        if not msg.Ok then
            showMessageUI(string.format("没有找到玩家ID（%d）", id))
            return
        end
        self.mNickname:setText(cutoutString(msg.Nickname, gameConfig.nicknameMaxLength))
    end)
end

function transfer:onTransferClickedHandler()
    playButtonClickSound()

    local id = tonumber(self.mId:getText())
    local vc = tonumber(self.mCount:getText())
    if id == nil then
        showMessageUI("请输入正确的玩家ID")
        return
    end
    if id == gamepref.player.acId then
        showMessageUI("无法给自己转账")
        return
    end
    if vc == nil or vc <= 0 then
        showMessageUI("转账数量必须为正数")
        return
    end
    if vc > gamepref.player.cards then
        showMessageUI("房卡不足")
        return
    end

    showWaitingUI(string.format("正在转账给玩家（%d）", id))
    networkManager.transferCards(id, vc, function(msg)
        closeWaitingUI()

        if not msg then
            showMessageUI("网络繁忙，请稍后再试")
            return
        end

        log("join friendster, msg = " .. table.tostring(msg))
        if msg.RetCode ~= retc.ok then
            if msg.RetCode == retc.coinNotEnough then
                showMessageUI("房卡不足")
            elseif msg.RetCode == retc.transferToSelf then
                showMessageUI("不能给自己转账")
            else
                showMessageUI("转账失败")
            end
            return
        end
        gamepref.player.cards = msg.CurCoin
        signalManager.signal(signalType.cardsChanged)
        showMessageUI(string.format("成功给玩家（%d）转账房卡（%d张）", id, vc))
        self:close()
    end)
end

function transfer:onIdChangedHandler()
    local text = self.mId:getText()
    if text == "-" then
        self.mId:setText(string.empty)
    end
    local id = tonumber(self.mId:getText())
    if id ~= nil and id < 0 then
        self.mId:setText(tostring(-id))
    end
end

function transfer:onCountChangeHandler()
    local text = self.mCount:getText()
    if text == "-" then
        self.mCount:setText(string.empty)
    end
    local count = tonumber(self.mCount:getText())
    if count ~= nil and count < 0 then
        self.mCount:setText(tostring(-count))
    end
end

function transfer:onCloseAllUIHandler()
    self:close()
end

function transfer:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    base.onDestroy(self)
end

return transfer

--endregion
