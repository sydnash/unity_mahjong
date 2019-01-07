--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local talkingData = {}

local appId = "76A5A32477784D3EAFA378C5ED29AD73"
local channelId = "mahjong.bshy.com"
local account = nil

function talkingData.start()
    if deviceConfig.isMobile then
        log("talkingData.start, channelId = " .. channelId)
        TalkingDataGA.OnStart(appId, channelId)
    end
end

function talkingData.setAccount(accountId)
    if deviceConfig.isMobile then
        log("talkingData.setAccount, accountId = " .. accountId)
        account = TDGAAccount.SetAccount(accountId)
    end
end

function talkingData.setAccountType(accountType)
    if deviceConfig.isMobile then 
        if account ~= nil then
            log("talkingData.setAccountType, accountType = " .. tostring(accountType))
            account:SetAccountType(accountType)
        end
    end
end

function talkingData.event(eventId, args)
    if deviceConfig.isMobile then
        log("talkingData.event, eventId = " .. eventId)
        TalkingDataGA.OnEvent(eventId, args)
    end
end

function talkingData.stop()
    if deviceConfig.isMobile then
        log("talkingData.stop")
        TalkingDataGA.OnEnd()
    end
end

return talkingData

--endregion
