--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local gvoiceManager = {}
gvoiceManager.status = false
gvoiceManager.path = LFS.CombinePath(LFS.DOWNLOAD_DATA_PATH, "gvoice")

local playQueue = {}
local recordFilename = string.empty
local recordFinishedCallback = nil
local playStartedCallback = nil
local playFinishedCallback = nil
local isPlaying = false
local isRecording = false
local isFirstPlay = true
local tmpRecordFile
local startTime = 0
local hasSetup = false

local networkConfig = require("config.networkConfig")
local timeout = networkConfig.gvoiceTimeout * 1000

function gvoiceManager.setup(userId)
    if deviceConfig.isMacOSX then
        --
    else
        if not hasSetup then
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

                hasSetup = true
            end
        end
    end

    LFS.MakeDir(gvoiceManager.path)
end

function gvoiceManager.update()
    if deviceConfig.isMacOSX then
        --
    else
        GVoiceEngine.instance:Update()
    end
    
    if gvoiceManager.status then
        gvoiceManager.checkHasNewFileNeedPlay()
    end

    gvoiceManager.stopTmpRecord()
end

function gvoiceManager.stopTmpRecord(force)
    if tmpRecordFile then
        if not force then
            local curT = time.realtimeSinceStartup()
            if curT - startTime > 1 then
                force = true
            end
        end
        if not force then
            return
        end
        if deviceConfig.isMacOSX then
            --
        else
            GVoiceEngine.instance:StopRecord()
        end
        LFS.RemoveFile(tmpRecordFile)
        tmpRecordFile = nil
    end
end

function gvoiceManager.registerRecordFinishedHandler(callback)
    recordFinishedCallback = callback
end

function gvoiceManager.unregisterRecordFinishedHandler()
    recordFinishedCallback = nil
end

function gvoiceManager.startRecord(filename)
    if gvoiceManager.status then
        gvoiceManager.stopTmpRecord(true)
        isRecording = true
        recordFilename = filename

        soundManager.setBGMVolume(0)
        soundManager.setSFXVolume(0)
        --gvoiceManager.stopPlay()

        if deviceConfig.isMacOSX then
            --
        else
            GVoiceEngine.instance:StartRecord(filename)
        end
    end
end

function gvoiceManager.stopRecord(cancel)
    if gvoiceManager.status then
        if deviceConfig.isMacOSX then
            --
        else
            GVoiceEngine.instance:StopRecord()
        end
        isRecording = false

        if not cancel then
            if recordFinishedCallback ~= nil then
                recordFinishedCallback(recordFilename)
            end

            local bytes = LFS.ReadBytes(recordFilename)
            if bytes and bytes.Length > 0 then
                if deviceConfig.isMacOSX then
                    --
                else
                    log("gvoiceManager.stopRecord, begin upload")
                    GVoiceEngine.instance:Upload(recordFilename, timeout)
                end
            else
                LFS.RemoveFile(recordFilename)
            end
        end

        soundManager.setBGMVolume(gamepref.getBGMVolume())
        soundManager.setSFXVolume(gamepref.getSFXVolume())
    end
end

function gvoiceManager.registerPlayStartedHandler(callback)
    playStartedCallback = callback
end

function gvoiceManager.unregisterPlayStartedHandler()
    playStartedCallback = nil
end

function gvoiceManager.registerPlayFinishedHandler(callback)
    playFinishedCallback = callback
end

function gvoiceManager.unregisterPlayFinishedHandler()
    playFinishedCallback = nil
end

function gvoiceManager.play(filename, acId)
    if gvoiceManager.status then
        gvoiceManager.stopPlay()
        local bytes = LFS.ReadBytes(filename)
        if not bytes or bytes.Length <= 0 then
            LFS.RemoveFile(filename)
            return false
        end
        isPlaying = true

        soundManager.setBGMVolume(0)
        soundManager.setSFXVolume(0)

        local ret
        if deviceConfig.isMacOSX then
            --
        else
            ret = GVoiceEngine.instance:StartPlay(filename)
        end
        log("gvoicemanager= start play: " .. filename .. "play ret: " .. tostring(ret))
        if ret and playStartedCallback ~= nil then
            if not acId then
                acId = gvoiceManager.fileNameToAcId[filename]
            else
                gvoiceManager.fileNameToAcId[filename] = acId
            end
            playStartedCallback(filename, acId)
        else 
            LFS.RemoveFile(filename)
            gvoiceManager.fileNameToAcId[filename] = nil
            isPlaying = false
        end

        return ret
    end

    return false
end

function gvoiceManager.startPlay(filename, fileid, acId)
    if gvoiceManager.status then
        log("gvoicemanager.startPlay")
        gvoiceManager.fileNameToAcId[filename] = acId
        if fileid == nil then
            gvoiceManager.onDownloadedHandler(true, filename)
            return
        end
        if deviceConfig.isMacOSX then
        else
            GVoiceEngine.instance:Download(fileid, filename, timeout)
        end
    end
end

function gvoiceManager.stopPlay()
    if gvoiceManager.status then
        isPlaying = false
        log("gvoicemanager= stop all: ")
        playFinishedCallback("", acId)
        if deviceConfig.isMacOSX then
        else
            GVoiceEngine.instance:StopPlay()
        end
    end
end

function gvoiceManager.reset()
    playQueue = {}
    recordFilename = string.empty
    recordFinishedCallback = nil
    playStartedCallback = nil
    playFinishedCallback = nil
    isPlaying = false
    isRecording = false
end

function gvoiceManager.onUploadedHandler(ok, filename, fileid)
    log("gvoiceManager.onUploadedHandler, ok = " .. tostring(ok) .. ", status = " .. tostring(gvoiceManager.status) .. ", fileid = " .. tostring(fileid))
    if gvoiceManager.status and ok then
        networkManager.sendChatMessage(chatType.voice, fileid, function(msg)
        end)
    end
end

function gvoiceManager.onDownloadedHandler(ok, filename, fileid)
    log("gvoiceManager.onDownloadedHandler, ok = " .. tostring(ok) .. ", status = " .. tostring(gvoiceManager.status) .. ", filename = " .. tostring(filename))
    if gvoiceManager.status then
        local acId = gvoiceManager.fileNameToAcId[filename]
        log("gvoiceManager.onDownloadedHandler, acId = " .. tostring(acId))
        table.insert(gvoiceManager.downloadFileQueue, {filename = filename, acId = acId})
        gvoiceManager.checkHasNewFileNeedPlay()
    end
end

function gvoiceManager.checkHasNewFileNeedPlay()
--    log("gvoiceManager.checkHasNewFileNeedPlay   11")
    if isPlaying then
        return
    end
--    log("gvoiceManager.checkHasNewFileNeedPlay   22")
    if isRecording then
        return
    end
--    log("gvoiceManager.checkHasNewFileNeedPlay   33")
    if #gvoiceManager.downloadFileQueue == 0 then
        return
    end
    
    local msg = gvoiceManager.downloadFileQueue[1]
    log("gvoiceManager.checkHasNewFileNeedPlay, filename = " .. msg.filename .. ", acId = " .. tostring(msg.acId))
    table.remove(gvoiceManager.downloadFileQueue, 1)
    gvoiceManager.play(msg.filename, msg.acId)
end

function gvoiceManager.onPlayFinishedHandler(ok, filename)
    if gvoiceManager.status and playFinishedCallback ~= nil then
        log("gvoicemanager= play finish: " .. filename)
        local acId = gvoiceManager.fileNameToAcId[filename]
        playFinishedCallback(filename, acId)
        gvoiceManager.fileNameToAcId[filename] = nil
        --语音播放完后立即删除对应的文件
--        LFS.RemoveFile(filename)
        isPlaying = false

        soundManager.setBGMVolume(gamepref.getBGMVolume())
        soundManager.setSFXVolume(gamepref.getSFXVolume())
    end
end

return gvoiceManager

--endregion
