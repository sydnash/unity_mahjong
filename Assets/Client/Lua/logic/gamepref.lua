--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local soundConfig = require("config.soundConfig")
local PlayerPrefs = UnityEngine.PlayerPrefs

local bgm_volume_key    = "AUDIO_BGM_VOLUME";
local sfx_volume_key    = "AUDIO_SFX_VOLUME";
local language_key      = "LANGUAGE"
local tablecloth_key    = "TABLECLOTH"
local tablelayout_key   = "TABLELAYOUT"

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
        return language.mandarin
    end

    return PlayerPrefs.GetString(language_key)
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function setTablecloth(tbc)
    PlayerPrefs.SetString(tablecloth_key, tbc)
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function getTablecloth()
    if not PlayerPrefs.HasKey(tablecloth_key) then
        return tablecloth.dft
    end

    return PlayerPrefs.GetString(tablecloth_key)
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function setTablelayout(tbl)
    PlayerPrefs.SetString(tablelayout_key, tbL)
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function getTablelayout()
    if not PlayerPrefs.HasKey(tablelayout_key) then
        return tablelayout.dft
    end

    return PlayerPrefs.GetString(tablelayout_key)
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

    save = save
}

--endregion
