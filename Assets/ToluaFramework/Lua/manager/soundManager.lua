--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local soundManager = {}

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.setup()
    AudioManager.instance:Setup()
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.save()
    AudioManager.instance:Save()
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
function soundManager.setSfxVolume(volume)
    AudioManager.instance:SetSEVolume(volume)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.getSfxVolume()
    return AudioManager.instance:GetSEVolume()
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
