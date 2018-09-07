--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local language = require("const.language")
local headerType = require("const.headerType")

local PlayerPrefs = UnityEngine.PlayerPrefs

local language_key = "_AUDIO_LANGUAGE_"
local header_key = "_HEADER_TYPE_"

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

    setLanguage = setLanguage,
    getLanguage = getLanguage,
    setHeaderType = setHeaderType,
    getHeaderType = getHeaderType,

    save = save
}

--endregion
