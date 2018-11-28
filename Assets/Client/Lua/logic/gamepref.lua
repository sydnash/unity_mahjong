--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local soundConfig = require("config.soundConfig")
local PlayerPrefs = UnityEngine.PlayerPrefs

local bgm_volume_key    = "AUDIO_BGM_VOLUME";
local sfx_volume_key    = "AUDIO_SFX_VOLUME";
local language_key      = "AUDIO_LANGUAGE"
local header_key        = "HEADER_TYPE"

-------------------------------------------------------------
--
-------------------------------------------------------------
local function setBGMVolume(volume)
    PlayerPrefs.SetFloat(bgm_volume_key, volume)
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function getBGMVolume()
    return PlayerPrefs.HasKey(bgm_volume_key) and PlayerPrefs.GetFloat(bgm_volume_key) or soundConfig.defaultBGMVolume;
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function setSFXVolume(volume)
    PlayerPrefs.SetFloat(sfx_volume_key, volume)
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function getSFXVolume()
    return PlayerPrefs.HasKey(sfx_volume_key) and PlayerPrefs.GetFloat(sfx_volume_key) or soundConfig.defaultSFXVolume;
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function setLanguage(lan)
    PlayerPrefs.SetString(language_key, lan)
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function getLanguage()
    if not PlayerPrefs.HasKey(language_key) then
        log("11111111111111111111111111111111111111111111")
        return language.mandarin
    end

    return PlayerPrefs.GetString(language_key)
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function setHeaderType(ht)
    PlayerPrefs.SetInt(header_key, ht)
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function getHeaderType(ht)
    if not PlayerPrefs.HasKey(header_key) then
        return headerType.wc
    end

    return PlayerPrefs.GetInt(header_key)
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function save()
    PlayerPrefs.Save()
end



return {
    acId = 0,
    session = "0",
    host = string.empty,
    prot = 0,

    setBGMVolume = setBGMVolume,
    getBGMVolume = getBGMVolume,
    setSFXVolume = setSFXVolume,
    getSFXVolume = getSFXVolume,
    setLanguage = setLanguage,
    getLanguage = getLanguage,
    setHeaderType = setHeaderType,
    getHeaderType = getHeaderType,

    save = save
}

--endregion
