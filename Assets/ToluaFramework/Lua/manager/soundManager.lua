--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local soundManager = {}
local assetType = 0

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.setup()
    AssetPoolManager.instance:AddPool(assetType, "Sound", true)
    AudioManager.instance:Setup()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.playBGM(audioPath, audioName)
    AudioManager.instance:PlayBGM(audioPath, audioName)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.stopBGM()
    AudioManager.instance:StopBGM()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.setBGMVolume(volume)
    AudioManager.instance:SetBGMVolume(volume)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.getBGMVolume()
    return AudioManager.instance:GetBGMVolume()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.setSFXVolume(volume)
    AudioManager.instance:SetSFXVolume(volume)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.getSFXVolume()
    return AudioManager.instance:GetSFXVolume()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.playUI(audioPath, audioName)
    AudioManager.instance:PlayUI(audioPath, audioName)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.playGfx(audioPath, audioName)
    AudioManager.instance:PlayGfx(audioPath, audioName)
end

return soundManager

--endregion
