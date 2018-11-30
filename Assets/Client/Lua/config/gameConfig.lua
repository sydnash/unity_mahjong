--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local ret = {
    fps                     = 30,       --帧率
    patchEnabled            = false,    --是否启用热更
    nicknameMaxLength       = 5,        --玩家昵称可显示的最大长度
    friendsterNameMaxLength = 10,       --亲友圈名称可显示的最大长度
    thumbSize               = 150,      --缩略图尺寸
    gvoiceMaxLength         = 120,      --语音录制最大时长，单位秒
    debug                   = true,
    serverList              = {
        localServer     = true,
        testServer      = true,
        releaseServer   = false,
    },
    errorEmail = {
        from = "",
        to = "",
    }
}

--ret.serverList              = nil

return ret
--endregion
