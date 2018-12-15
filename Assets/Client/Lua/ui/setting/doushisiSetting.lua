--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.setting.setting")
local doushisiSetting = class("doushisiSetting", base)

_RES_(doushisiSetting, "SettingUI", "DoushisiSettingUI")

function doushisiSetting:ctor(game)
    self.game = game
    self.super.ctor(self)
end

function doushisiSetting:onInit()
    self.super.onInit(self)

    self.mMandarin.key = language.mandarin
    self.mSichuan.key  = language.sichuan

    local languages = {
        self.mMandarin,
        self.mSichuan
    }

    local lan = gamepref.getLanguage()
    for _, v in pairs(languages) do
        v:setSelected(v.key == lan)
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

    local tbc = gamepref.getTablecloth()
    for _, v in pairs(tableclothes) do
        v:setSelected(v.key == tbc)
        v:addChangedListener(self.onTableclothChangedHandler, self)
    end

    self.mLayoutDFT.key = tablelayout.dft
    self.mLayoutXD.key = tablelayout.xd

    local tablelayouts = { 
        self.mLayoutDFT,
        self.mLayoutXD,
    }

    local tbl = gamepref.getTablelayout()
    for _, v in pairs(tablelayouts) do
        v:setSelected(v.key == tbl)
        v:addChangedListener(self.onTablelayoutChangedHandler, self)
    end

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

function doushisiSetting:onLanguageChangedHandler(sender, selected, clicked)
    if clicked then
        if selected then
            gamepref.setLanguage(sender.key)
        end

        playButtonClickSound()
    end
end

function doushisiSetting:onTableclothChangedHandler(sender, selected, clicked)
    if clicked then
        if selected then
            local go = find("changpai/table")
            if go ~= nil then
                local render = getComponentU(go, typeof(UnityEngine.SpriteRenderer))
                if render ~= nil then
                    local sprite = render.sprite
                    if sprite ~= nil then
                        textureManager.unload(sprite.texture)
                        UnityEngine.GameObject.Destroy(sprite)
                    end

                    local tex = textureManager.load("doushisi/table", sender.key)
                    render.sprite = convertTextureToSprite(tex)
                end
            end

            gamepref.setTablecloth(sender.key)
        end

        playButtonClickSound()
    end
end

function doushisiSetting:onTablelayoutChangedHandler(sender, selected, clicked)
    if clicked then
        if selected then
            gamepref.setTablelayout(sender.key)
        end

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
    self.super.onDestroy(self)
end

return doushisiSetting

--endregion
