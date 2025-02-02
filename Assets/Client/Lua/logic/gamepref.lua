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
local refreshtoken_key  = "RESFRESHTOKEN_KEY"

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
local function setLanguage(gametype, lan)
    PlayerPrefs.SetString(language_key .. tostring(gametype), lan)
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function getLanguage(gametype)
    local key = language_key .. tostring(gametype)

    if not PlayerPrefs.HasKey(key) then
        return language.mandarin
    end

    return PlayerPrefs.GetString(key)
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function setTablecloth(gametype, tbc)
    PlayerPrefs.SetString(tablecloth_key .. tostring(gametype), tbc)
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function getTablecloth(gametype)
    local key = tablecloth_key .. tostring(gametype)

    if not PlayerPrefs.HasKey(key) then
        if gametype == gameType.doushisi then
            return tablecloth.dft
        elseif gametype == gameType.paodekuai then
            return tablecloth.paodekuai.qsl
        else
            return tablecloth.dft
        end
    end

    return PlayerPrefs.GetString(key)
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

local function setWXRefreshToken(refreshToken)
    PlayerPrefs.SetString(refreshtoken_key, refreshToken)
end
local function getWXRefreshToken()
    if not PlayerPrefs.HasKey(refreshtoken_key) then
        return nil
    end
    return PlayerPrefs.GetString(refreshtoken_key)
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function save()
    PlayerPrefs.Save()
end

local selectedGameType = {
    [0] = gameType.mahjong,
}

-------------------------------------------------------------
--
-------------------------------------------------------------
local function setSelectedGameType(friendsterId, gameType)
    selectedGameType[math.max(0, friendsterId)] = gameType
end

-------------------------------------------------------------
--
-------------------------------------------------------------
local function getSelectedGameType(friendsterId)
    local gt = selectedGameType[math.max(0, friendsterId)]
    if gt == nil then
        gt = gameType.mahjong
        setSelectedGameType(friendsterId, gt)
    end

    return gt
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
    setWXRefreshToken = setWXRefreshToken,
    getWXRefreshToken = getWXRefreshToken,

    save = save,

    setSelectedGameType = setSelectedGameType,
    getSelectedGameType = getSelectedGameType,
}

--endregion
