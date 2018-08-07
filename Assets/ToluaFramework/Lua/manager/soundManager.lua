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
function soundManager.playBGM()
    AudioManager.instance:PlayBGM("bgm")
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
function soundManager.playButtonClickedSound()
    AudioManager.instance:PlayUI("click")
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function soundManager.playUISound(soundName)
    AudioManager.instance:PlayUI(soundName)
end

return soundManager

--endregion
