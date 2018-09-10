--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local messagebox    = require("ui.messagebox")
local mahjongType   = require("logic.mahjong.mahjongType")
local opType        = require("const.opType")
local sexType       = require("const.sexType")

local K = 1024
local M = K * K
local G = K * M
local T = G * K

----------------------------------------------------------------
--
----------------------------------------------------------------
function BKMGT(bytes)
    assert(type(bytes) == "number")

    if bytes == nil then bytes = 0 end
    if bytes < K then return string.format("%dB",   bytes) end
    if bytes < M then return string.format("%.1fKB", bytes / K) end
    if bytes < G then return string.format("%.1fMB", bytes / M) end
    if bytes < T then return string.format("%.1fGB", bytes / G) end

    return string.format("%.1fT", bytes / T)
end

-------------------------------------------------------------
-- 显示消息界面
-------------------------------------------------------------
function showMessage(text, confirmCallback, cancelCallback)
    local ui = messagebox.new(text, confirmCallback, cancelCallback)
    ui:show()
end

-------------------------------------------------------------
-- 播放点击按钮的音效
-------------------------------------------------------------
function playButtonClickSound()
    soundManager.playUI(string.empty, "click")
end

-------------------------------------------------------------
-- 播放麻将的音效
-------------------------------------------------------------
function playMahjongSound(mahjongId, sex)
    local folder = (sex == sexType.boy) and "mahjong/boy" or "mahjong/girl"
    local resource = mahjongType[mahjongId].audio

    return soundManager.playGfx(folder, resource)
end

local opsounds = {
    [opType.mo.id]   = "",
    [opType.chu.id]  = "",
    [opType.chi.id]  = "",
    [opType.peng.id] = "peng",
    [opType.gang.id] = "gang",
    [opType.hu.id]   = "hu",
    [opType.guo.id]  = "",
}

-------------------------------------------------------------
-- 播放麻将操作音效
-------------------------------------------------------------
function playMahjongOpSound(optype, sex)
    local folder = (sex == sexType.boy) and "mahjong/boy" or "mahjong/girl"
    local resource = opsounds[optype]

    return soundManager.playGfx(folder, resource)
end

local function writeIcon(bytes)
    return nil
end

-------------------------------------------------------------
-- 下载玩家头像
-------------------------------------------------------------
function downloadIcon(url, callback)
    local hash = MD5.GetHash(url)
    local path = ""
    --先本地查找，没找到再从网上下载
    http.getBytes(path, 5, function(ok, bytes)
        if not ok then
            http.getBytes(url, 20, function(ok, bytes)
                if not ok then

                else

                end
            end)
        else
            
        end
    end)
end

-------------------------------------------------------------
-- 登录服务器
-------------------------------------------------------------
function loginServer(callback)
    local waiting = require("ui.waiting").new("正在登录中，请稍候...")
    waiting:show()

    networkManager.login(function(ok, msg)
        waiting:close()

        if not ok then
            showMessage("网络繁忙，请稍后再试", function()
                callback(false)
            end)
            return
        end

        if msg.RetCode ~= retc.Ok then
            showMessage(retText[msg.RetCode], function()
                callback(false)
            end)
            return
        end

        callback(true)
        log("login, msg = " .. table.tostring(msg))

        local loading = require("ui.loading").new()
        loading:show()

        local deskInfo = msg.DeskInfo

        if deskInfo == nil or deskInfo.DeskId == 0 then
            sceneManager.load("scene", "LobbyScene", function(completed, progress)
                loading:setProgress(progress)

                if completed then
                    local lobby = require("ui.lobby").new()
                    lobby:show()

                    loading:close()
                end
            end)
        else -- 如有在房间内则跳过大厅直接进入房间
            local cityType = deskInfo.GameType
            local deskId = deskInfo.DeskId

            networkManager.checkDesk(cityType, deskId, function(ok, msg)
                if not ok then
                    loading:close()
                    showMessage("网络繁忙，请稍后再试", function()
                        callback(false)
                    end)
                    return
                end

                log("check desk, msg = " .. table.tostring(msg))
                loading:setProgress(0.2)

                networkManager.enterDesk(cityType, deskId, function(ok, msg)
                    if not ok then
                        log("enter desk error")
                        loading:close()
                        showMessage("网络繁忙，请稍后再试", function()
                            callback(false)
                        end)
                        return
                    end

                    if msg.RetCode ~= retc.Ok then
                        loading:close()
                        showMessage(retcText[msg.RetCode], function()
                            callback(false)
                        end)
                        return
                    end

                    log("enter desk, msg = " .. table.tostring(msg))
                    loading:setProgress(0.4)

                    sceneManager.load("scene", "MahjongScene", function(completed, progress)
                        loading:setProgress(0.4 + 0.6 * progress)

                        if completed then
                            msg.Reenter = table.fromjson(msg.Reenter)
                            msg.Config = table.fromjson(msg.Config)

                            local desk = require("logic.mahjong.mahjongGame").new(msg)
                            loading:close()
                        end
                    end)
                end)
            end)
        end
    end)
end

--
local mahjongIdToSprite = {
    [0]  = "1tiao",
    [1]  = "2tiao",
    [2]  = "3tiao",
    [3]  = "4tiao",
    [4]  = "5tiao",
    [5]  = "6tiao",
    [6]  = "7tiao",
    [7]  = "8tiao",
    [8]  = "9tiao",
    [9]  = "1tong",
    [10] = "2tong",
    [11] = "3tong",
    [12] = "4tong",
    [13] = "5tong",
    [14] = "6tong",
    [15] = "7tong",
    [16] = "8tong",
    [17] = "9tong",
    [18] = "1wan",
    [19] = "2wan",
    [20] = "3wan",
    [21] = "4wan",
    [22] = "5wan",
    [23] = "6wan",
    [24] = "7wan",
    [25] = "8wan",
    [26] = "9wan",
    [27] = "hongzhong",
    [28] = "facai",
    [29] = "baiban",
}

-------------------------------------------------------------
-- 麻将Id转sprite名字
-------------------------------------------------------------
function convertMahjongIdToSpriteName(mahjongId)
    mahjongId = math.floor(mahjongId / 4)
    return mahjongIdToSprite[mahjongId]
end

--endregion
