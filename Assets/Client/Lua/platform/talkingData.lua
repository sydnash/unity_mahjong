--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local talkingData = {}

local appId = "76A5A32477784D3EAFA378C5ED29AD73"
local channelId = "mahjong.bshy.com"

function talkingData.onStart()
    TalkingDataGA.OnStart(appId, channelId)
end

function talkingData.onEnd()
    TalkingDataGA.OnEnd()
end

return talkingData

--endregion
