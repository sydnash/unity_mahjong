--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local messagebox    = require("ui.messagebox")
local mahjongType   = require("logic.mahjong.mahjongType")
local opType        = require("const.opType")
local sexType       = require("const.sexType")

function showMessage(text, confirmCallback, cancelCallback)
    local ui = messagebox.new(text, confirmCallback, cancelCallback)
    ui:show()
end

function playButtonClickSound()
    soundManager.playUI(string.empty, "click")
end

function playMahjongSound(mahjongId, sex)
    local folder = (sex == sexType.boy) and "mahjong/boy" or "mahjong/girl"
    local resource = mahjongType[mahjongId].audio

    return soundManager.playGfx(folder, resource)
end

local opsounds = {
    [opType.mo]   = "",
    [opType.chu]  = "",
    [opType.chi]  = "",
    [opType.peng] = "peng",
    [opType.gang] = "gang",
    [opType.hu]   = "hu",
    [opType.guo]  = "",
}

function playMahjongOpSound(optype, sex)
    local folder = (sex == sexType.boy) and "mahjong/boy" or "mahjong/girl"
    local resource = opsounds[optype]

    return soundManager.playGfx(folder, resource)
end

--endregion
