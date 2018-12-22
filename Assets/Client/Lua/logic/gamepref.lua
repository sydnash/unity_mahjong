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
local chipengziti_key   = "CHIPENGZITI"
local lastchatchose_key = "LASTCHATCHOSE"

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
    PlayerPrefs.SetInt(tablelayout_key, tbl)
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function getTablelayout()
    if not PlayerPrefs.HasKey(tablelayout_key) then
        return doushisiStyle.traditional
    end

    return PlayerPrefs.GetInt(tablelayout_key)
end

local function getChiPengZiTi()
    if not PlayerPrefs.HasKey(chipengziti_key) then
        return true
    end

    return PlayerPrefs.GetInt(chipengziti_key) > 0
end
local function setChiPengZiTi(has)
    local save = has and 1 or 0
    PlayerPrefs.SetInt(chipengziti_key, save)
end

local function setLastChatChose(chose)
    PlayerPrefs.SetInt(lastchatchose_key, chose)
end
local function getLastChatChose()
    if not PlayerPrefs.HasKey(lastchatchose_key) then
        return chatType.emoji
    end
    return PlayerPrefs.GetInt(lastchatchose_key)
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
    setTablecloth = setTablecloth,
    getTablecloth = getTablecloth,
    setTablelayout = setTablelayout,
    getTablelayout = getTablelayout,
    getChiPengZiTi = getChiPengZiTi,
    setChiPengZiTi = setChiPengZiTi,
    getLastChatChose = getLastChatChose,
    setLastChatChose = setLastChatChose,

    save = save
}

--endregion
