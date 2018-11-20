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
        GVoiceEngine.instance:ApplyMessageKey(timeout)
    end

    LFS.MakeDir(gvoiceManager.path)
end

function gvoiceManager.update()
    GVoiceEngine.instance:Update()
    
    if gvoiceManager.status then
        if #playQueue > 0 then
            local o = playQueue[1]
            table.remove(playQueue, 1)

            GVoiceEngine.instance:Download(o.filename, o.fileid, timeout)
        end
    end
end

function gvoiceManager.registerRecordFinishedHandler(callback)
    recordFinishedCallback = callback
end

function gvoiceManager.startRecord(filename)
    if gvoiceManager.status then
        recordFilename = filename
        log("gvoiceManager.startRecord, filename = " .. filename)
        GVoiceEngine.instance:StartRecord(filename)
    end
end

function gvoiceManager.stopRecord()
    if gvoiceManager.status then
        log("gvoiceManager.stopRecord, filename = " .. recordFilename)
        GVoiceEngine.instance:StopRecord()
        GVoiceEngine.instance:Upload(recordFilename, timeout)
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
        playQueue = {}
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
end

function gvoiceManager.onUploadedHandler(ok, filename, fileid)
    if gvoiceManager.status then
        log("gvoiceManager.onUploadedHandler, filename = " .. filename)
        local data = { filename = filename, fileid = fileid }
        networkManager.sendChatMessage(chatType.voice, fileid, function(ok, msg)
        
        end)

        if recordFinishedCallback ~= nil then
            recordFinishedCallback(filename)
        end
    end
end

function gvoiceManager.onDownloadedHandler(ok, filename, fileid)
    if gvoiceManager.status then
        if playDownloaded then
            gvoiceManager.play(filename)
        else
            LFS.RemoveFile(filename)--语音下载完后如果不播放就立即删除对应的文件
        end
    end
end

function gvoiceManager.onPlayFinishedHandler(ok, filename)
    if gvoiceManager.status and playFinishedCallback ~= nil then
        playFinishedCallback(filename)
        --语音播放完后立即删除对应的文件
        LFS.RemoveFile(filename)
    end
end

return gvoiceManager

--endregion
