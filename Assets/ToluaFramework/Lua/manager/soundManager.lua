--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local soundManager = {}
local assetType = "sound"

local BGM_CHANNEL = "bgm"
local UI_CHANNEL  = "ui"
local GFX_CHANNEL = "sfx"

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.setup()
    AssetPoolManager.instance:AddPool(assetType, "sound", true)
    AudioManager.instance:AddChannel(BGM_CHANNEL, 1)
    AudioManager.instance:AddChannel(UI_CHANNEL, 3)
    AudioManager.instance:AddChannel(GFX_CHANNEL, 5)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.playBGM(audioPath, audioName)
    AudioManager.instance:Play(BGM_CHANNEL, string.lower(audioPath), string.lower(audioName), true)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.stopBGM()
    AudioManager.instance:Stop(BGM_CHANNEL)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.setBGMVolume(volume)
    AudioManager.instance:SetVolume(BGM_CHANNEL, volume)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.getBGMVolume()
    return AudioManager.instance:GetVolume(BGM_CHANNEL)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.setSFXVolume(volume)
    AudioManager.instance:SetVolume(UI_CHANNEL,  volume)
    AudioManager.instance:SetVolume(GFX_CHANNEL, volume)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.getSFXVolume()
    return AudioManager.instance:GetVolume(GFX_CHANNEL)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.playUI(audioPath, audioName)
    AudioManager.instance:Play(UI_CHANNEL, string.lower(audioPath), string.lower(audioName), false)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.playGfx(audioPath, audioName)
    AudioManager.instance:Play(GFX_CHANNEL, string.lower(audioPath), string.lower(audioName), false)
end

return soundManager

--endregion
