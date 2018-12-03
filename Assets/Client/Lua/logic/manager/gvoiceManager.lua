--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gvoiceManager = {}
gvoiceManager.status = false
gvoiceManager.path = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "gvoice")

local playQueue = {}
local recordFilename = string.empty
local playDownloaded = false
local recordFinishedCallback = nil
local playStartedCallback = nil
local playFinishedCallback = nil
local isPlaying = false
local isRecording = false

local networkConfig = require("config.networkConfig")
local timeout = networkConfig.gvoiceTimeout * 1000

function gvoiceManager.setup(userId)
    if GVoiceEngine.instance:Setup(userId) then
        GVoiceEngine.instance:RegisterApplyMessageKeyCallback(function(ok)
            if ok then
                GVoiceEngine.instance:RegisterUploadedCallback(gvoiceManager.onUploadedHandler)
                GVoiceEngine.instance:RegisterDownloadedCallback(gvoiceManager.onDownloadedHandler)
                GVoiceEngine.instance:RegisterPlayFinishedCallback(gvoiceManager.onPlayFinishedHandler)
            end

            gvoiceManager.status = ok
            gvoiceManager.fileNameToAcId = {}
            gvoiceManager.downloadFileQueue = {}
        end)

        GVoiceEngine.instance:SetMaxMessageLength(gameConfig.gvoiceMaxLength * 1000)
        GVoiceEngine.instance:ApplyMessageKey(timeout)
    end

    LFS.MakeDir(gvoiceManager.path)
end

function gvoiceManager.update()
    GVoiceEngine.instance:Update()
    
    if gvoiceManager.status then
        if #playQueue > 0 and (not isPlaying) and (not isRecording) then
            local o = playQueue[1]
            table.remove(playQueue, 1)
            GVoiceEngine.instance:Download(o.fileid, o.filename, timeout)
        end

        gvoiceManager.checkHasNewFileNeedPlay()
    end
end

function gvoiceManager.registerRecordFinishedHandler(callback)
    recordFinishedCallback = callback
end

function gvoiceManager.startRecord(filename)
    if gvoiceManager.status then
        isRecording = true
        recordFilename = filename

        soundManager.setBGMVolume(0)
        soundManager.setSFXVolume(0)
        --gvoiceManager.stopPlay()

        GVoiceEngine.instance:StartRecord(filename)
    end
end

function gvoiceManager.stopRecord(cancel)
    if gvoiceManager.status then
        GVoiceEngine.instance:StopRecord()
        isRecording = false

        if not cancel then
            if recordFinishedCallback ~= nil then
                recordFinishedCallback(recordFilename)
            end

            local bytes = LFS.ReadBytes(recordFilename)
            if bytes and bytes.Length > 0 then
                GVoiceEngine.instance:Upload(recordFilename, timeout)
            end
        end

        soundManager.setBGMVolume(gamepref.getBGMVolume())
        soundManager.setSFXVolume(gamepref.getSFXVolume())
    end
end

function gvoiceManager.registerPlayStartedHandler(callback)
    playStartedCallback = callback
end

function gvoiceManager.registerPlayFinishedHandler(callback)
    playFinishedCallback = callback
end

function gvoiceManager.play(filename, acId)
    if gvoiceManager.status then
        local bytes = LFS.ReadBytes(filename)
        if not bytes or bytes.Length <= 0 then
            return false
        end
        isPlaying = true

        log("gvoice start play : "  .. tostring(bytes.Length) .. " " .. tostring(acId) .. " " .. filename)
        soundManager.setBGMVolume(0)
        soundManager.setSFXVolume(0)

        local ret = GVoiceEngine.instance:StartPlay(filename)
        if ret and playStartedCallback ~= nil then
            if not acId then
                acId = gvoiceManager.fileNameToAcId[filename]
            else
                gvoiceManager.fileNameToAcId[filename] = acId
            end
            playStartedCallback(filename, acId)
        end
        return ret
    end
    return false
end

function gvoiceManager.startPlay(filename, fileid, acId)
    if gvoiceManager.status then
        playDownloaded = true
        gvoiceManager.fileNameToAcId[filename] = acId
        if fileid == nil then
            gvoiceManager.onDownloadedHandler(true, filename)
            return
        end
        table.insert(playQueue, { filename = filename, fileid = fileid })
    end
end

function gvoiceManager.stopPlay()
    if gvoiceManager.status then
        isPlaying = false
        playDownloaded = false

        GVoiceEngine.instance:StopPlay()
    end
end

function gvoiceManager.reset()
    playQueue = {}
    recordFilename = string.empty
    playDownloaded = false
    recordFinishedCallback = nil
    playStartedCallback = nil
    playFinishedCallback = nil
    isPlaying = false
    isRecording = false
end

function gvoiceManager.onUploadedHandler(ok, filename, fileid)
    if gvoiceManager.status and ok then
        networkManager.sendChatMessage(chatType.voice, fileid, function(msg)
        end)
    end
end

function gvoiceManager.onDownloadedHandler(ok, filename, fileid)
    if gvoiceManager.status then
        table.insert(gvoiceManager.downloadFileQueue, {filename = filename})
        gvoiceManager.checkHasNewFileNeedPlay()
    end
end

function gvoiceManager.checkHasNewFileNeedPlay()
    if gvoiceManager.isPlaying then
        return
    end
    if #gvoiceManager.downloadFileQueue == 0 then
        return
    end
    local msg = gvoiceManager.downloadFileQueue[1]
    table.remove(gvoiceManager.downloadFileQueue, 1)
    gvoiceManager:play(msg.filename)
end

function gvoiceManager.onPlayFinishedHandler(ok, filename)
    if gvoiceManager.status and playFinishedCallback ~= nil then
        log("gvoice finishd handler " .. filename)
        log("gvoice " .. table.tostring(gvoiceManager.fileNameToAcId))
        local acId = gvoiceManager.fileNameToAcId[filename]
        playFinishedCallback(filename, acId)
        gvoiceManager.fileNameToAcId[filename] = nil
        --语音播放完后立即删除对应的文件
        LFS.RemoveFile(filename)
        isPlaying = false

        soundManager.setBGMVolume(gamepref.getBGMVolume())
        soundManager.setSFXVolume(gamepref.getSFXVolume())
    end
end

return gvoiceManager

--endregion
