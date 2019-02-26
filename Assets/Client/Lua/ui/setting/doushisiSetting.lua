--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.setting.setting")
local doushisiSetting = class("doushisiSetting", base)

_RES_(doushisiSetting, "SettingUI", "DoushisiSettingUI")

local LABEL_S_COLOR = Color.New(12  / 255, 138 / 255, 33 / 255, 1)
local LABEL_U_COLOR = Color.New(146 / 255, 84  / 255, 46 / 255, 1)

local function setTextColor(node, selection)
    if node.label then
        node.label:setColor(selection and LABEL_S_COLOR or LABEL_U_COLOR)
    end
end

local function initLable(node)
    node.label = findText(node.transform, "Label")
end

function doushisiSetting:ctor(game)
    self.game = game
    base.ctor(self)
end

function doushisiSetting:onInit()
    base.onInit(self)

    self.mMandarin.key = language.mandarin
    self.mSichuan.key  = language.sichuan

    local languages = {
        self.mMandarin,
        self.mSichuan
    }

    local lan = gamepref.getLanguage()
    self.languagesNodes = languages
    for _, v in pairs(languages) do
        v:setSelected(v.key == lan)
        initLable(v)
        setTextColor(v, v.key == lan)
        v:addChangedListener(self.onLanguageChangedHandler, self)
    end

    self.mTableclothDFT.key = tablecloth.dft
    self.mTableclothQXL.key = tablecloth.qxl
    self.mTableclothMHW.key = tablecloth.mhw
    self.mTableclothHJ.key  = tablecloth.hj

    local tableclothes = { 
        self.mTableclothDFT,
        self.mTableclothQXL,
        self.mTableclothMHW,
        self.mTableclothHJ,
    }

    local tbc = gamepref.getTablecloth(gameType.doushisi)
    self.tableclothesNodes = tableclothes
    for _, v in pairs(tableclothes) do
        v:setSelected(v.key == tbc)
        initLable(v)
        setTextColor(v, v.key == tbc)
        v:addChangedListener(self.onTableclothChangedHandler, self)
    end

    self.mLayoutDFT.key = doushisiStyle.traditional
    self.mLayoutXD.key = doushisiStyle.modern

    local tablelayouts = { 
        self.mLayoutDFT,
        self.mLayoutXD,
    }

    local tbl = gamepref.getTablelayout()
    self.tablelayoutsNodes = tablelayouts
    for _, v in pairs(tablelayouts) do
        v:setSelected(v.key == tbl)
        initLable(v)
        setTextColor(v, v.key == tbl)
        v:addChangedListener(self.onTablelayoutChangedHandler, self)
    end

    local cpzt = gamepref.getChiPengZiTi()
    self.mCPZT:setSelected(cpzt)
    self.mCPZT:addChangedListener(self.onChiPengZiTiChangedHandler, self)
    initLable(self.mCPZT)
    setTextColor(self.mCPZT, cpzt)

    if self.game:isCreator(gamepref.player.acId) or self.game:isPlaying() then
        self.mDissolveText:setSprite("js")
    else
        self.mDissolveText:setSprite("tc")
    end

    if self.game:canBackToLobby() then
        self.mBack:setInteractabled(true)
        self.mBackText:setSprite("enable")
    else
        self.mBack:setInteractabled(false)
        self.mBackText:setSprite("disable")
    end

    self.mDissolve:addClickListener(self.onDissolveClickedHandler, self)
    self.mBack:addClickListener(self.onBackClickedHandler, self)
end

function doushisiSetting:onChiPengZiTiChangedHandler()
    local selected = self.mCPZT:getSelected()
    gamepref.setChiPengZiTi(selected)
    setTextColor(self.mCPZT, selected)
end

function doushisiSetting:onLanguageChangedHandler(sender, selected, clicked)
    if clicked then
        if selected then
            gamepref.setLanguage(sender.key)
        end

        for _, v in pairs(self.languagesNodes) do
            setTextColor(v, false)
        end

        setTextColor(sender, selected)
        playButtonClickSound()
    end
end

function doushisiSetting:onTableclothChangedHandler(sender, selected, clicked)
    if clicked then
        if selected then
           self.game.operationUI:changeBG(sender.key)
           gamepref.setTablecloth(gameType.doushisi, sender.key)
        end

        for _, v in pairs(self.tableclothesNodes) do
            setTextColor(v, false)
        end
        setTextColor(sender, selected)
        playButtonClickSound()
    end
end

function doushisiSetting:onTablelayoutChangedHandler(sender, selected, clicked)
    if clicked then
        if selected then
            gamepref.setTablelayout(sender.key)
        end
        if self.game:isPlaying() then
            showMessageUI("修改布局风格需要重连游戏，是否修改？", function()
                self.game.operationUI:setDoushisiStyle(sender.key)
                enterDesk(clientApp.currentDesk.cityType, clientApp.currentDesk.deskId)
                self:close()
            end, function()
            end)
        else
            self.game.operationUI:setDoushisiStyle(sender.key)
        end
        for _, v in pairs(self.tablelayoutsNodes) do
            setTextColor(v, false)
        end

        setTextColor(sender, selected)
        playButtonClickSound()
    end
end

function doushisiSetting:onDissolveClickedHandler()
    if self.game ~= nil then
        self.game:endGame()
        self:close()
    end

    playButtonClickSound()
end

function doushisiSetting:onBackClickedHandler()
    if self.game ~= nil then
        self.game:exitGame()
    end

    self:close()
    playButtonClickSound()
end

function doushisiSetting:onDestroy()
    signalManager.unregisterSignalHandler(signalType.closeAllUI, self.onCloseAllUIHandler, self)
    base.onDestroy(self)
end

return doushisiSetting

--endregion
