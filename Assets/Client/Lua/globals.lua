--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

require("const.typeDef")
require("const.textDef")
require("const.statusDef")

deviceConfig    = require("config.deviceConfig")
gameConfig      = require("config.gameConfig")
gamepref        = require("logic.gamepref")
platformHelper  = require("platform.platformHelper")
networkManager  = require("network.networkManager")

local waiting       = require("ui.waiting")
local messagebox    = require("ui.messagebox")
local mahjongType   = require("logic.mahjong.mahjongType")
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

    local hash = Hash.GetHash(url)
    local path = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "wxicons", hash .. ".jpg")

    --先本地查找，没找到再从网上下载
    http.getTexture2D("file:///" .. path, function(ok, tex, bytes)
        if ok and tex ~= nil then
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
-- 进入桌子
-------------------------------------------------------------
function enterDesk(gameType, deskId, callback)
    --开始预加载资源
    local preload = modelManager.preload()

    for _, v in pairs(mahjongType) do
        preload:push(v.folder, v.resource, 4)
    end
    preload:start()

    networkManager.checkDesk(gameType, deskId, function(ok, msg)
        if not ok then
            callback(false, "网络繁忙，请稍后再试", preload, 0, nil)
            return
        end

        log("check desk, msg = " .. table.tostring(msg))
        callback(true, string.empty, preload, 0.5, nil)

        networkManager.enterDesk(gameType, deskId, function(ok, msg)
            if not ok then
                callback(false, "网络繁忙，请稍后再试", preload, 0.5, nil)
                return
            end

            if msg.RetCode ~= retc.ok then
                callback(false, retcText[msg.RetCode], preload, 0.5, nil)
                return
            end

            log("enter desk, msg = " .. table.tostring(msg))
            callback(true, string.empty, preload, 1, msg)
        end)
    end)
end

-------------------------------------------------------------
-- 登录服务器
-------------------------------------------------------------
function loginServer(callback)
    showWaitingUI("正在登录中，请稍候...")

    --登录服务器
    local loginImp = deviceConfig.isMobile and networkManager.loginWx or networkManager.login

    loginImp(function(ok, msg)
        closeWaitingUI()
        platformHelper.setLogined(false)

        if not ok then
            showMessageUI("网络繁忙，请稍后再试", function()
                callback(false)
            end)
            return
        end

        if msg.RetCode ~= retc.ok then
            showMessageUI(retText[msg.RetCode], function()
                callback(false)
            end)
            return
        end

        platformHelper.setLogined(true)
        callback(true)
        log("login, msg = " .. table.tostring(msg))

        local cityType = 0
        local deskId   = 0

        local deskInfo = msg.DeskInfo

        if deskInfo ~= nil and deskInfo.DeskId > 0 then
            cityType = deskInfo.GameType
            deskId = deskInfo.DeskId
            log(string.format("get desk from DeskInfo, cityType = %d, deskId = %d", cityType, deskId))
        else
            local params = platformHelper.getParamsSg()--检查闲聊的邀请数据
            if not string.isNilOrEmpty(params) then
                local t = table.fromjson(params)

                cityType = t.cityType
                deskId = t.deskId
                log(string.format("get desk from XianLiao, cityType = %d", cityType))
                log(string.format("get desk from XianLiao, deskId = %d", deskId))
            end
        end

        if cityType == 0 and deskId == 0 then
            local sceneName = sceneManager.getActivedSceneName()

            if sceneName ~= "lobbyscene" then
                local loading = require("ui.loading").new()
                loading:show()

                sceneManager.load("scene", "lobbyscene", function(completed, progress)
                    loading:setProgress(progress)

                    if completed then
                        local lobby = require("ui.lobby").new()
                        lobby:show()

                        loading:close()
                    end
                end)
            end
        else -- 如有在房间内则跳过大厅直接进入房间
            local loading = require("ui.loading").new()
            loading:show()

            enterDesk(cityType, deskId, function(ok, errText, preload, progress, msg)
                if not ok then
                    loading:close()
                    showMessageUI(errText, function()
                        if callback ~= nil then
                            callback(false)
                        end
                    end)
                    return
                end

                if msg == nil then
                    loading:setProgress(progress * 0.4)
                    return
                end

                msg.Config  = table.fromjson(msg.Config)
                msg.Reenter = table.fromjson(msg.Reenter)

                if clientApp.currentDesk ~= nil then
                    clientApp.currentDesk:onEnter(msg)
                    loading:close()
                else
                    sceneManager.load("scene", "mahjongscene", function(completed, progress)
                        loading:setProgress(0.4 + 0.6 * progress)

                        if completed then
                            if preload ~= nil then
                                preload:stop()
                            end

                            clientApp.currentDesk = require("logic.mahjong.mahjongGame").new(msg)
                            loading:close()
                        end
                    end)

                    loading:setProgress(0.4)
                end

                if callback ~= nil then
                    callback(true)
                end
            end)
        end
    end)
end

-------------------------------------------------------------
-- 
-------------------------------------------------------------
local function stringToChars(str)
	--[[ 
        主要用了Unicode(UTF-8)编码的原理分隔字符串
	    简单来说就是每个字符的第一位定义了该字符占据了多少字节
	    UTF-8的编码：它是一种变长的编码方式
	    对于单字节的符号，字节的第一位设为0，后面7位为这个符号的unicode码。因此对于英语字母，UTF-8编码和ASCII码是相同的。
	    对于n字节的符号（n>1），第一个字节的前n位都设为1，第n+1位设为0，后面字节的前两位一律设为10。
	    剩下的没有提及的二进制位，全部为这个符号的unicode码。
    --]]
    local list = {}
    local len = string.len(str)
    local i = 1 

    while i <= len do
        local c = string.byte(str, i)
        local shift = 1
        if c > 0 and c <= 127 then
            shift = 1
        elseif (c >= 192 and c <= 223) then
            shift = 2
        elseif (c >= 224 and c <= 239) then
            shift = 3
        elseif (c >= 240 and c <= 247) then
            shift = 4
        end
        local char = string.sub(str, i, i+shift-1)
        i = i + shift
        table.insert(list, {char, shift})
    end

	return list, len
end

-------------------------------------------------------------
-- 按给定长度截断字符串并在最后连接“...”
-------------------------------------------------------------
function cutoutString(str, maxLen)
	local tmp = stringToChars(str)
    if #tmp <= maxLen then
        return str
    end
    local ret = ""
    local i = 1
    local maxLen = 2 * maxLen
    local curLen = 0
    while(true) do
        if i > #tmp then
            break
        end
        if tmp[i][2] > 1 then
            curLen = curLen + 2
        else
            curLen = curLen + 1
        end
        if curLen > maxLen then 
            ret = ret .. "..."
            break
        end
        ret = ret .. tmp[i][1]
        i = i + 1
    end

    return ret
end

-------------------------------------------------------------
-- 按给定长宽缩放texture
-------------------------------------------------------------
function getSizedTexture(tex, width, height)
    local size = Vector2.New(width, height)
    return Utils.SizeTextureBilinear(tex, size)
end

-------------------------------------------------------------
-- 截取全屏UI
-------------------------------------------------------------
function captureScreenshotUI()
    local go = find("UIRoot/UICamera")
    if go ~= nil then
        local camera = getComponentU(go.gameObject, typeof(UnityEngine.Camera))
        if camera ~= nil then
            return Utils.CaptureScreenshot(camera)
        end
    end

    return nil
end

--endregion
