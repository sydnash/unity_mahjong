--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

deskStatus = {
    fapai   = 1, --发牌
    hsz     = 2, --换三张
    dingque = 3, --定缺
    playing = 4, --进行中
    gameend = 5, --结束
}

exitDeskStatus = {
    proposer    = -1, --发起申请
    waiting     =  0, --等待选择
    agree       =  1, --同意
    reject      =  2, --拒绝
}

gameStatus = {
    notBegin = 1,
    playing  = 2,
}

--endregion
