--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

require("const.typeDef")
require("const.textDef")
require("const.statusDef")

require("config.deskDetailConfig")

deviceConfig    = require("config.deviceConfig")
gameConfig      = require("config.gameConfig")
networkConfig   = require("config.networkConfig")
gamepref        = require("logic.gamepref")
platformHelper  = require("platform.platformHelper")
networkManager  = require("network.networkManager")
gvoiceManager   = require("logic.manager.gvoiceManager")
locationManager = require("logic.manager.locationManager")

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
    local prefix = gamepref.getLanguage()
    if not string.isNilOrEmpty(prefix) then
        prefix = prefix .. "_"
    end
    local resource = prefix .. mahjongType[mahjongId].audio

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
    local prefix = gamepref.getLanguage()
    if not string.isNilOrEmpty(prefix) then
        prefix = prefix .. "_"
    end
    local resource = prefix .. opsounds[optype]

    return soundManager.playGfx(folder, resource)
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
    http.getTexture2D("file:///" .. path, function(tex, bytes)
        if tex ~= nil then
            if callback ~= nil then
                callback(tex)
            end
        else
            http.getTexture2D(url, function(tex, bytes)
                if tex ~= nil then
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
    showWaitingUI("正在进入房间，请稍候...")

    --开始预加载资源
    local preload = modelManager.preload()

    for _, v in pairs(mahjongType) do
        preload:push(v.folder, v.resource, 4)
    end
    preload:start()

    if callback == nil then
        callback = function(ok) end
    end

    networkManager.checkDesk(gameType, deskId, function(msg)
        if msg == nil then
            closeWaitingUI()
            showMessageUI(NETWORK_IS_BUSY, function()
                callback(false)
            end)
            return
        end

        if msg.RetCode ~= retc.ok then
            closeWaitingUI()
            showMessageUI(retcText[msg.RetCode], function()
                callback(false)
            end)
            return
        end

        local location = locationManager.getData()
        
        networkManager.enterDesk(gameType, deskId, location, function(msg)
            closeWaitingUI()

            if msg == nil then
                showMessageUI(NETWORK_IS_BUSY, function()
                    callback(false)
                end)
                return
            end

            if msg.RetCode ~= retc.ok then
                showMessageUI(retcText[msg.RetCode], function()
                    callback(false)
                end)
                return
            end

            msg.Config  = table.fromjson(msg.Config)
            msg.Reenter = table.fromjson(msg.Reenter)
            msg.Players = msg.Others
            msg.Others  = nil

            local me = {
                AcId        = gamepref.player.acId,
                Nickname    = gamepref.player.nickname,
                HeadUrl     = gamepref.player.headerUrl,
                Ip          = gamepref.player.ip,
                Sex         = gamepref.player.sex,
                IsConnected = true,
                IsLaoLai    = msg.IsLaoLai,
                Ready       = msg.Ready,
                Score       = msg.Score,
                Turn        = msg.Turn,
            }
            if gamepref.player.location then 
                me.HasPosition = gamepref.player.location.status
                me.Latitude    = gamepref.player.location.latitude
                me.Longitude   = gamepref.player.location.longitude
            end
            table.insert(msg.Players, me)

            if clientApp.currentDesk ~= nil then
                clientApp.currentDesk:onEnter(msg)
                clientApp.currentDesk:startLoop()
            else
                clientApp.currentDesk = require("logic.mahjong.mahjongGame").new(msg)

                local loading = require("ui.loading").new()
                loading:show()

                sceneManager.load("scene", "mahjongscene", function(completed, progress)
                    loading:setProgress(progress)

                    if completed then
                        if preload ~= nil then
                            preload:stop()
                        end

                        loading:close()
                    
                        if callback ~= nil then
                            callback(true)
                        end

                        closeAllUI()
                        clientApp.currentDesk:startLoop()
                    end
                end)
            end
        end)
    end)
end

-------------------------------------------------------------
-- 登录服务器
-------------------------------------------------------------
function loginServer(callback, func)
    showWaitingUI("正在登录中，请稍候...")

    --登录服务器
    local loginImp = func

    loginImp(function(msg)
        closeWaitingUI()
        platformHelper.setLogined(false)

        if msg == nil then
            showMessageUI(NETWORK_IS_BUSY, function()
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
        gvoiceManager.setup(tostring(gamepref.player.acId))

--        log("login, msg = " .. table.tostring(msg))

        local cityType = 0
        local deskId   = 0
        local deskInfo = msg.DeskInfo

        if deskInfo ~= nil and deskInfo.DeskId > 0 then
            cityType = deskInfo.GameType
            deskId = deskInfo.DeskId
--            log(string.format("get desk from DeskInfo, cityType = %d, deskId = %d", cityType, deskId))
        else
            local params = platformHelper.getParamsSg()--检查闲聊的邀请数据
            if not string.isNilOrEmpty(params) then
                local t = table.fromjson(params)

                cityType = t.cityType
                deskId = t.deskId
--                log(string.format("get desk from XianLiao, cityType = %d, deskId = %d", cityType, deskId))
            end
            platformHelper.clearSGInviteParam()
        end

        if cityType == 0 and deskId == 0 then
            local loading = require("ui.loading").new()
            loading:show()

            sceneManager.load("scene", "lobbyscene", function(completed, progress)
                loading:setProgress(progress)

                if completed then
                    local lobby = require("ui.lobby").new()
                    lobby:show()

                    callback(true)
                    loading:close()
                end
            end)
        else -- 如有在房间内则跳过大厅直接进入房间
            enterDesk(cityType, deskId, function(ok)
                callback(ok)
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

local cityFilename = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "city.txt")

----------------------------------------------------------------
--
----------------------------------------------------------------
function readCityConfig()
    local text = LFS.ReadText(cityFilename, LFS.UTF8_WITHOUT_BOM)

    if string.isNilOrEmpty(text) then
        return {
            ["Region"] = "ChengDu",
            ["City"] = 1000,
        }
    end

    return loadstring(text)()
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function writeCityConfig(config)
    local text = "return " .. table.tostring(config)
    LFS.WriteText(cityFilename, text, LFS.UTF8_WITHOUT_BOM)
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function closeAllUI()
    signalManager.signal(signalType.closeAllUI)
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function commitError(subject, body, attachment)
    local from = gameConfig.errorEmail.from
    local to   = gameConfig.errorEmail.to
    local psw  = "Forwork123"

    Utils.CommitError(from, to, subject, body, attachment, psw)
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function destroyTexture(tex)
    if tex ~= nil then
        GameObject.DestroyImmediate(tex, true)
    end
end

--endregion
