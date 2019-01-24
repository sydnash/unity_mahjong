--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

---------------------------------------------------------------------------
-- reload lua module
---------------------------------------------------------------------------
function reload(packageName)
    package.loaded[packageName] = nil
    return require(packageName)
end

Application = UnityEngine.Application

appConfig = reload("config.appConfig")
reload("utils.class")

require("utils.string")
require("utils.table")
require("utils.utils")

time                = require("utils.time")
json                = require("utils.json")
viewManager         = require("manager.viewManager")
eventManager        = require("manager.eventManager")
soundManager        = require("manager.soundManager")
sceneManager        = require("manager.sceneManager")
tweenManager        = require("manager.tweenManager")
modelManager        = require("manager.modelManager")
textureManager      = require("manager.textureManager")
animationManager    = require("manager.animationManager")
preloadManager      = require("manager.preloadManager")
signalManager       = require("manager.signalManager")

require("const.typeDef")
require("const.textDef")
require("const.statusDef")
require("config.deskConfig")

deviceConfig    = require("config.deviceConfig")
gameConfig      = require("config.gameConfig")
enableConfig    = require("config.enableConfig")
networkConfig   = require("config.networkConfig")
gamepref        = require("logic.gamepref")
platformHelper  = require("platform.platformHelper")
networkManager  = require("network.networkManager")
gvoiceManager   = require("logic.manager.gvoiceManager")
locationManager = require("logic.manager.locationManager")
talkingData     = require("platform.talkingData")

local waiting       = require("ui.waiting")
local messagebox    = require("ui.messagebox")
local mahjongType   = require("logic.mahjong.mahjongType")
local doushisiType  = require("logic.doushisi.doushisiType")

reload("network.httpAsync")
local http = reload("network.http")

----------------------------------------------------------------
-- 断开连接后的回调
----------------------------------------------------------------
local function networkDisconnectedCallback(idx)
    log("[test for reconnect] networkDisconnectedCallback : " .. tostring(idx))
    if idx ~= nil and idx > 5 then
        closeWaitingUI()

        if clientApp.currentDesk ~= nil then
            clientApp.currentDesk:destroy()
            clientApp.currentDesk = nil
        end
        gamepref.player.currentDesk = nil

        closeAllUI()
        networkManager.disconnect()

        showMessageUI("与服务器失去连接，请重新登录。", 
                      function()--确定：回到登录界面
                          local ui = require("ui.login").new()
                          ui:show()
                      end)
        return
    end

    local idx = idx or 1
    showWaitingUI(string.format("正在尝试重连(%d/5)，请稍候...", idx))

    networkManager.reconnect(gamepref.host, gamepref.port, function(connected, curCoin, cityType, deskId)
        if not connected then
            networkDisconnectedCallback(idx + 1)
            return
        end

        closeWaitingUI()

        networkManager.startPingPong()
        signalManager.signal(signalType.refreshFriendsterDetailInfo)

        if deskId <= 0 then
            gamepref.player.currentDesk = nil
            if clientApp.currentDesk and not clientApp.currentDesk:isPlayback() and not clientApp.currentDesk.isGameOverUIShow then
                showMessageUI("牌局已经结束，请点击确定并去战绩查看详情", function()
                    clientApp.currentDesk:exitGame()
                end)
            end
            return
        end

        if clientApp.currentDesk ~= nil and clientApp.currentDesk:isPlayback() then
            return
        end

        enterDesk(cityType, deskId, function(ok, func)
            if not ok then
                local ui = require("ui.lobby").new()
                ui:show()
            end
            if func then
                func()
            end
        end)
    end)
end

----------------------------------------------------------------
-- 闲聊邀请的回调
----------------------------------------------------------------
local function inviteSgCallback(params)
    if clientApp.currentDesk == nil then
        closeAllUI()

        local t = table.fromjson(params)

        local cityType = t.cityType
        local deskId = t.deskId

        if clientApp.currentDesk ~= nil and clientApp.currentDesk:isPlayback() then
            return
        end

        enterDesk(cityType, deskId, function(ok)
            if not ok then
                local ui = require("ui.lobby").new()
                ui:show()
            end
        end)
    end

    platformHelper.clearSGInviteParam()
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function clientAppSetup()
    networkManager.setup(networkDisconnectedCallback)

    soundManager.setup()
    viewManager.setup()
    modelManager.setup()
    textureManager.setup()
    animationManager.setup()
    eventManager.setup()
    sceneManager.setup()

    local headerManager = require("logic.manager.headerManager")
    headerManager.setup()

    locationManager.checkEnabled()
    locationManager.start()

    platformHelper.registerInviteSgCallback(inviteSgCallback)
    talkingData.start()

    gamepref.city = readCityConfig()
end

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
        waiting_ui:setAsLastSibling()
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
    ui:setAsLastSibling()
end

-------------------------------------------------------------
-- 播放点击按钮的音效
-------------------------------------------------------------
function playButtonClickSound()
    soundManager.playUI(string.empty, "click")
end

local chatConfig = reload("config.chatConfig")

-------------------------------------------------------------
-- 播放聊天的音效
-------------------------------------------------------------
function playChatTextSound(key, sex)
    local folder = (sex == sexType.boy) and "chat/text/boy" or "chat/text/girl"
    local prefix = gamepref.getLanguage()
    if not string.isNilOrEmpty(prefix) then
        prefix = prefix .. "_"
    end
    local resource = prefix .. chatConfig.text[key].audio

    return soundManager.playGfx(folder, resource)
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
    local resource = prefix .. mahjongType.getMahjongTypeById(mahjongId).audio

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
-- 播放斗十四的音效
-------------------------------------------------------------
local d14sound = {
    ["sc_pai_yaoliu"] = {
        [cityType.jintang] = "sc_pai_gaojiao",
    },
    ["sc_pai_erliu"] = {
        [cityType.jintang] = "sc_pai_erpang",
    },
    ["sc_pai_zhuzhu"] = {
        [cityType.jintang] = "sc_pai_maomao",
    },
}
function playDoushisiSound(cityType, doushisiId, sex)
    local folder = (sex == sexType.boy) and "doushisi/boy" or "doushisi/girl"
    local prefix = gamepref.getLanguage()
    if not string.isNilOrEmpty(prefix) then
        prefix = prefix .. "_"
    end
    local resource = prefix .. doushisiType.getDoushisiTypeById(doushisiId).audio
    
    local cfg = d14sound[resource]
    if cfg then
        cfg = cfg[cityType]
    end
    if cfg then
        resource = cfg
    end

    return soundManager.playGfx(folder, resource)
end

local d14opsound = {
    [opType.doushisi.an]            = {
        default = "action_anpai",
    },
    [opType.doushisi.baGang]        = {
        default = "action_dengpai",
    },
    [opType.doushisi.bao]           = {
        default = "action_baopai",
    },
    [opType.doushisi.baoJiao]       = {
        default = "",
    },
    [opType.doushisi.caiShen]       = {
        default = "",
    },
    [opType.doushisi.che]           = {
        default = "action_pengpai",
    },
    [opType.doushisi.chi]           = {
        default = "action_chipai",
    },
    [opType.doushisi.chiChengSan]   = {
        default = "action_chichengsanzhang",
    },
    [opType.doushisi.chu]           = {
        default = "",
    },
    [opType.doushisi.dang]          = {
        default = "action_dangpai",
        [cityType.jintang]  = "action_zuozhuang",
    },
    [opType.doushisi.fan]           = {
        default = "",
    },
    [opType.doushisi.gang]          = {
        default = "",
    },
    [opType.doushisi.gen]           = {
        default = "",
    },
    [opType.doushisi.hu]            = {
        default = "action_hupai",
    },
    [opType.doushisi.hua]           = {
        default = "action_huapai",
        [cityType.jintang] = "action_anpai",
    },
    [opType.doushisi.mo]            = {
        default = "",
    },
    [opType.doushisi.pass]          = {
        default = "",
    },
    [opType.doushisi.shou]          = {
        default = "action_shoupai",
    },
    [opType.doushisi.weiGui]        = {
        default = "status_weigui",
    },
    [opType.doushisi.zhao]          = {
        default = "",
    },
    [opType.doushisi.budang]          = {
        default = "action_guopai",
        [cityType.jintang]  = "action_huazhuang",
    },
}

-------------------------------------------------------------
-- 播放斗十四操作音效
-------------------------------------------------------------
function playDoushisiOpSound(cityType, optype, sex)
    local folder = (sex == sexType.boy) and "doushisi/boy" or "doushisi/girl"

    local prefix = gamepref.getLanguage()
    if not string.isNilOrEmpty(prefix) then
        prefix = prefix .. "_"
    end

    local op = d14opsound[optype][cityType]
    if string.isNilOrEmpty(op) then
        op = d14opsound[optype].default
    end

    local resource = prefix .. op
    return soundManager.playGfx(folder, resource)
end

-------------------------------------------------------------
-- 
-------------------------------------------------------------
function getLogicGame(citytype, gametype)
    if gametype == gameType.mahjong then
        return require("logic.mahjong.mahjongGame")
    elseif gametype == gameType.doushisi then
        if citytype == cityType.jintang then
            return require ("logic.doushisi.doushisiGame_jintang")
        end
        return require("logic.doushisi.doushisiGame")
    end
end

function checkGame(cityType, gameType)
    local cityConfig = enableConfig[cityType]
    if cityConfig == nil then
        return false, string.format("暂不支持%s地区", cityName[cityType])
    end

    for _, v in pairs(cityConfig) do
        if v.detail ~= nil then
            for k, u in pairs(v.detail) do
                if k == gameType and u then
                    return true, string.empty
                end
            end
        end
    end

    return false, string.format("%s地区暂不支持%s", cityName[cityType], gameName[cityType].games[gameType])
end

-------------------------------------------------------------
-- 进入桌子
-------------------------------------------------------------
function enterDesk(cityType, deskId, callback, isFromLogining)
    showWaitingUI("正在进入房间，请稍候...")

    --开始预加载资源
    local preload = modelManager.preload()

    for _, v in pairs(mahjongType.c) do
        for i=1, 4 do
            preload:push(v.folder, v.resource)
        end
    end
    preload:start()

    if callback == nil then
        callback = function(ok) end
    end

    networkManager.checkDesk(cityType, deskId, function(msg)
        if msg == nil then
            closeWaitingUI()
            showMessageUI(NETWORK_IS_BUSY, function()
                callback(false)
            end)
            return
        end

--        log("check desk, msg = " .. table.tostring(msg))

        if msg.RetCode ~= retc.ok then
            closeWaitingUI()
            showMessageUI(retcText[msg.RetCode], function()
                callback(false)
            end)
            return
        end

        msg.Config = table.fromjson(msg.Config)

        local ok, errText = checkGame(msg.GameType, msg.Config.Game)
        if not ok then
            closeWaitingUI()
            if isFromLogining then
                callback(false, function()
                    showMessageUI(string.format("%s, 可点击确定下载<color=red>天地长牌</color>进入游戏", errText), 
                                function()
                                    platformHelper.openExplorer("http://www.cdbshy.com")
                                end,
                                function()
                                end)
                end)
            else
                showMessageUI(string.format("%s, 可点击确定下载<color=red>天地长牌</color>进入游戏", errText), 
                            function()
                                callback(false)
                                platformHelper.openExplorer("http://www.cdbshy.com")
                            end,
                            function()
                                callback(false)
                            end)
            end
            return
        end

        local location = locationManager.getData()
        
        networkManager.enterDesk(cityType, deskId, location, function(msg)
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

            log("enter desk, msg = " .. table.tostring(msg))

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
                local cityType = msg.GameType
                local gameType = msg.Config.Game
                clientApp.currentDesk = getLogicGame(cityType, gameType).new(msg)

                if preload ~= nil then
                    preload:stop()
                end
                    
                if callback ~= nil then
                    callback(true)
                end

                closeAllUI()
                clientApp.currentDesk:startLoop()
            end
        end)
    end)
end

function fixInhandCameraParam(originSize, inhandCamera)
    local oriScreenAspect = 16 / 9
    local inhandCameraH = originSize
    local inhandCameraW = inhandCameraH * oriScreenAspect

    local newH = inhandCameraW / inhandCamera.aspect

    local inhandCameraT = inhandCamera.transform
    local inhandCameraP = inhandCameraT.position

    local inhandCameraBottom = inhandCameraP.y - inhandCameraH
    inhandCamera.orthographicSize = newH
    local newy = inhandCameraBottom + newH

    inhandCameraT.position = Vector3.New(inhandCameraP.x, newy, inhandCameraP.z)
end

function fixMainCameraParam(fov, mainCamera)
    local oriW = 12.80
    local aspect = mainCamera.aspect
    local nheight = oriW / aspect
    local dis = math.abs(mainCamera.transform.position.z)

    local newHFov = math.atan(nheight * 0.5 / dis) * 2 / math.pi * 180

    mainCamera.fieldOfView = newHFov
end

function fixMainCameraByFov(fov, mainCamera)
    local oriAspect = 16 / 9
    if oriAspect < mainCamera.aspect then
        return
    end
    local wFov = fov * oriAspect
    local newHFov = wFov / mainCamera.aspect
    mainCamera.fieldOfView = newHFov
end

-------------------------------------------------------------
-- 登录服务器
-------------------------------------------------------------
function loginServer(callback, func)
    local loginImp = func

    loginImp(function(msg)
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

        talkingData.setAccount(tostring(gamepref.player.acId))
        talkingData.setAccountType(AccountType.WEIXIN)

        local cityType = 0
        local deskId   = 0
        local deskInfo = msg.DeskInfo

        if deskInfo ~= nil and deskInfo.DeskId > 0 then
            cityType = deskInfo.GameType
            deskId = deskInfo.DeskId
        else
            local params = platformHelper.getParamsSg()--检查闲聊的邀请数据
            if not string.isNilOrEmpty(params) then
                local t = table.fromjson(params)

                cityType = t.cityType
                deskId = t.deskId
            end
            platformHelper.clearSGInviteParam()
        end

        local loading = require("ui.loading").new()
        loading:setText("正在努力联系服务器，请稍候")
        loading:show()

        sceneManager.load("mahjongscene", function(completed, progress)
            loading:setProgress(progress)

            if completed then
                if cityType == 0 and deskId == 0 then
                    local lobby = require("ui.lobby").new()
                    lobby:show()

                    callback(true)
                    loading:close()
                else -- 如有在房间内则跳过大厅直接进入房间
                    loading:setText("正在进入房间，请稍候")
                    enterDesk(cityType, deskId, function(ok, func)
                        local lobby = require("ui.lobby").new()
                        lobby:show()
                        if func then
                            func()
                        end
                        callback(true)
                        loading:close()
                    end, true)
                end
            end
        end)
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
        UnityEngine.GameObject.DestroyImmediate(tex, true)
    end
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function findSpriteRD(transform, name)
    assert(transform ~= nil, "can't find a child for nil")

    local target = string.isNilOrEmpty(name) and transform or transform:Find(name)
    if target ~= nil then
        local spriteRD = require("scene.common.spriteRD")
        return spriteRD.new(target.gameObject)
    end

    return nil
end

function gc()
--    AssetPoolManager.instance:UnloadUnused()
--    collectgarbage("collect")
end

--endregion
