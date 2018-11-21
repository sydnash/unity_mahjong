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
        gvoiceManager.stopPlay()

        GVoiceEngine.instance:StartRecord(filename)
    end
end

function gvoiceManager.stopRecord(cancel)
    if gvoiceManager.status then
        GVoiceEngine.instance:StopRecord()
        isRecording = false

        if not cancel then
            if recordFinishedCallback ~= nil then
                recordFinishedCallback(filename)
            end

            GVoiceEngine.instance:Upload(recordFilename, timeout)
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

function gvoiceManager.play(filename)
    if gvoiceManager.status then
        isPlaying = true

        soundManager.setBGMVolume(0)
        soundManager.setSFXVolume(0)

        if playStartedCallback ~= nil then
            playStartedCallback(filename)
        end

        GVoiceEngine.instance:StartPlay(filename)
    end
end

function gvoiceManager.startPlay(filename, fileid)
    if gvoiceManager.status then
        playDownloaded = true
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
    if gvoiceManager.status then
        networkManager.sendChatMessage(chatType.voice, fileid, function(ok, msg)
        
        end)
    end
end

function gvoiceManager.onDownloadedHandler(ok, filename, fileid)
    if gvoiceManager.status then
        if playDownloaded and (not isRecording) then
            gvoiceManager.play(filename)
        else
            LFS.RemoveFile(filename)--语音下载完后如果不播放就立即删除对应的文件
            isPlaying = false
        end
    end
end

function gvoiceManager.onPlayFinishedHandler(ok, filename)
    if gvoiceManager.status and playFinishedCallback ~= nil then
        playFinishedCallback(filename)
        --语音播放完后立即删除对应的文件
        LFS.RemoveFile(filename)
        isPlaying = false

        soundManager.setBGMVolume(gamepref.getBGMVolume())
        soundManager.setSFXVolume(gamepref.getSFXVolume())
    end
end

return gvoiceManager

--endregion
