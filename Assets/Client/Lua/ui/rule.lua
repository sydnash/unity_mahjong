--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local enableConfig = require("config.enableConfig")

local base = require("ui.common.view")
local rule = class("rule", base)

_RES_(rule, "RuleUI", "RuleUI")

function rule:onInit()
    local title = cityName[gamepref.city.City]
    self.mTitle:setText(title .. "规则")

    local enables = enableConfig[gamepref.city.City]
    local on = false

    local mahjong = enables.mahjong
    if mahjong.enable then
        on = true

        if mahjong.detail ~= nil and mahjong.detail[gameType.mahjong] then
            self.mMahjongTab:setSelected(true)
        else
            self.mMahjongTab:setSelected(false)
        end
    end

    local changpai = enables.changpai
    if changpai.enable then
        self.mDoushisiTab:hide()

        if on then
            self.mDoushisiTab:setSelected(false)
        else
            on = true

            if changpai.detail ~= nil and changpai.detail[gameType.doushisi] then
                self.mDoushisiTab:setSelected(true)
            else
                self.mDoushisiTab:setSelected(false)
            end            
        end
    else
        self.mDoushisiTab:hide()
    end

    local poke = enables.poke
    if poke.enable then
        self.mPaodekuaiTab:hide()

        if not on then
            self.mPaodekuaiTab:setSelected(false)
        else
            on = true

            if poke.detail ~= nil and poke.detail[gameType.paodekuai] then
                self.mPaodekuaiTab:setSelected(true)
            else
                self.mPaodekuaiTab:setSelected(false)
            end
        end
    else
        self.mPaodekuaiTab:hide()
    end

    self.mClose:addClickListener(self.onCloseClickedHandler, self)
    self.mMahjongTab:addChangedListener(self.onTabChangedHandler, self)
    self.mDoushisiTab:addChangedListener(self.onTabChangedHandler, self)
    self.mPaodekuaiTab:addChangedListener(self.onTabChangedHandler, self)

    self.mMahjongTab.page = self.mMahjongPage
    self.mDoushisiTab.page = self.mDoushisiPage
    self.mPaodekuaiTab.page = self.mPaodekuaiPage
end

function rule:onCloseClickedHandler()
    playButtonClickSound()
    self:close()
end

function rule:onTabChangedHandler(sender, selected, clicked)
    if clicked and selected then
        self.mMahjongTab:setSelected(false)
        self.mDoushisiTab:setSelected(false)
        self.mPaodekuaiTab:setSelected(false)

        sender:setSelected(true)
        sender.page:show()

        playButtonClickSound()
    end
end

return rule

--endregion
