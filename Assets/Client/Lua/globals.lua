--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local waiting       = require("ui.waiting")
local messagebox    = require("ui.messagebox")
local mahjongType   = require("logic.mahjong.mahjongType")
local opType        = require("const.opType")
local sexType       = require("const.sexType")
local http          = require("network.http")

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

local waiting_ui = nil

-------------------------------------------------------------
-- 显示等待界面
-------------------------------------------------------------
function showWaitingUI(text)
    if waiting_ui == nil then
        waiting_ui = waiting.new(text)
    else
        waiting_ui:setText(text)
    end

    waiting_ui:show()
end

-------------------------------------------------------------
-- 关闭等待界面
-------------------------------------------------------------
function closeWaitingUI()
    if waiting_ui~= nil then
        waiting_ui:close()
        waiting_ui = nil
    end
end

-------------------------------------------------------------
-- 显示消息界面
-------------------------------------------------------------
function showMessageUI(text, confirmCallback, cancelCallback)
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
    local resource = gamepref.getLanguage() .. mahjongType[mahjongId].audio

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
    if string.isNilOrEmpty(url) then
        return
    end

    local hash = MD5.GetHash(url)
    local path = LFS.CombinPath(LFS.DOWNLOAD_DATA_PATH, "wxicons", hash .. ".jpg")

    --先本地查找，没找到再从网上下载
    http.getTexture2D("file:///" .. path, function(ok, tex, bytes)
        if ok and tex ~= nil then
            LFS.WriteBytes(path, bytes)

            if callback ~= nil then
                callback(tex)
            end
        else
            http.getTexture2D(url, function(ok, tex, bytes)
                if ok and tex ~= nil then
                    LFS.WriteBytes(path, bytes)

                    if callback ~= nil then
                        callback(tex)
                    end
                end
            end)
        end
    end)
end

-------------------------------------------------------------
-- 登录服务器
-------------------------------------------------------------
function enterDesk(gameType, deskId, callback)
    networkManager.checkDesk(gameType, deskId, function(ok, msg)
        if not ok then
            callback(false, "网络繁忙，请稍后再试", 0, nil)
            return
        end

        log("check desk, msg = " .. table.tostring(msg))
        callback(true, string.empty, 0.5, nil)

        networkManager.enterDesk(gameType, deskId, function(ok, msg)
            if not ok then
                log("enter desk error")
                callback(false, "网络繁忙，请稍后再试", 0.5, nil)
                return
            end

            if msg.RetCode ~= retc.Ok then
                log("enter desk error")
                callback(false, retcText[msg.RetCode], 0.5, nil)
                return
            end

            log("enter desk, msg = " .. table.tostring(msg))
            callback(true, string.empty, 1, msg)
        end)
    end)
end

-------------------------------------------------------------
-- 登录服务器
-------------------------------------------------------------
function loginServer(callback)
    showWaitingUI("正在登录中，请稍候...")

    networkManager.login(function(ok, msg)
        closeWaitingUI()

        if not ok then
            showMessageUI("网络繁忙，请稍后再试", function()
                callback(false)
            end)
            return
        end

        if msg.RetCode ~= retc.Ok then
            showMessageUI(retText[msg.RetCode], function()
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

            enterDesk(cityType, deskId, function(ok, errText, progress, msg)
                if not ok then
                    loading:close()
                    showMessageUI(errText)
                    if callback ~= nil then
                        callback(false)
                    end
                else
                    if msg == nil then
                        loading:setProgress(progress * 0.4)
                    else
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
                    end

                    if callback ~= nil then
                        callback(true)
                    end
                end
            end)
        end
    end)
end

--endregion
