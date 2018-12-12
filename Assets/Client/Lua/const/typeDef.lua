--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--------------------------------------------------------------
--
--------------------------------------------------------------
headerType = {
    td = 1, --3D模型
    wc = 2, --微信头像
}

--------------------------------------------------------------
--
--------------------------------------------------------------
language = {
    mandarin    = string.empty,
    sichuan     = "sc",
}

--------------------------------------------------------------
--
--------------------------------------------------------------
sexType = {
    boy  = 1,
    girl = 2,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
retc = {
    ok                              = 0,
    authorFailed                    = 1001,
    kickByOtherLogin                = 1002,
    kickByAlreadyLogout             = 1003,
    kickLongInactive                = 1004,
    enterGSDeskFailed               = 1005,
    enterGSDeskDeskNotFound         = 1006,
    enterGSDeskDeskFull             = 1007,
    enterGSDeskPlaying              = 1008,
    enterGSDeskAlreadyInOtherDesk   = 1009,
    serverIsClosing                 = 1010,
    serverError                     = 1011,
    checkDeskDeskNotFind            = 1012,
    coinNotEnough                   = 1013,
    transferToSelf                  = 1014,
    willClose                       = 1015,
    notSupportGameType              = 1016,
    notInClub                       = 1017,
    playerHasTooMuchClub            = 1018,
    clubIsFull                      = 1019,
    clubNotFound                    = 1020,
    clubPermision                   = 1021,
    clubCoinNotEnough               = 1022,
    playerNotFound                  = 1023,
    clubCardNegative                = 1024,
    clubPlayerInDesk                = 1025,
    applyInfoNotFound               = 1026,
    playerIsAlreadyInClub           = 1027,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
fanXingType = {
    su                  = 0,
    qingYiSe            = 1,
    qiDui               = 2,
    daDuiZi             = 3,
    jinGouDiao          = 4,
    hunYiSe             = 5,
    jiangDui            = 6,
    yaoJiu              = 7,
    menQing             = 8,
    zhongZhang          = 9,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
opType = {
    mo   = { id = 0, },
    chu  = { id = 1, },
    chi  = { id = 2, },
    peng = { id = 3, },
    gang = { id = 4, 
             detail = { angang              = 4, 
                        bagangwithmoney     = 1, 
                        bagangwithoutmoney  = 2, 
                        minggang            = 3, 
	                    zhuanyu             = 32,
                        fanyu               = 33,
             } 
    },
    hu = { id = 5, 
           detail = { zimo          = 10, 
                      dianpao       = 11, 
                      qianggang     = 12, 
                      gangshanghua  = 13, 
                      gangshangpao  = 14, 
                      haidilao      = 15,
                      haidipao      = 16, 
                      tianhu        = 17,
	                  dihu          = 18,
	                  chahuazhu     = 30,
	                  chajiao       = 31,
           } 
    },
    guo  = { id = 6, },
}

--------------------------------------------------------------
--
--------------------------------------------------------------
chatType = { 
    voice = 0,
    text  = 1,
    emoji = 2,
    cmsg  = 3,--输入的文字
}

--------------------------------------------------------------
--
--------------------------------------------------------------
signalType = {
    chatText                            = 1,
    chatEmoji                           = 2,
    chatCMsg                            = 3,
    cardsChanged                        = 4,
    deskDestroy                         = 5,
    friendsterMessageOp                 = 6,
    mail                                = 7,
    headerDownloaded                    = "header|",
    city                                = 9,
    closeAllUI                          = 10,
    refreshFriendsterDetailInfo         = 11,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
cityType = {
    chengdu     = 1000, --成都
    wenjiang    = 1,    --温江
    pixian      = 2,    --郫县
    jintang     = 3,    --金堂
    huayang     = 4,    --华阳
    dayi        = 5,    --大邑
    qionglai    = 6,    --邛崃
    suining     = 7,    --遂宁
    renshou     = 8,    --仁寿
    jianyang    = 9,    --简阳
    zhongjiang  = 10,   --中江
    guanghan    = 11,   --广汉
    xichong     = 12,   --西充
    nanchong    = 13,   --南充
    maoxian     = 14,   --茂县
    anyue       = 15,   --安岳
    tianquan    = 16,   --天泉
    yingjing    = 17,   --荥经
    jiangyou    = 18,   --江油
}

--------------------------------------------------------------
--
--------------------------------------------------------------
cityRegion = {
    [cityType.chengdu]      = "ChengDu",
    [cityType.wenjiang]     = "ChengDu",
    [cityType.pixian]       = "ChengDu",
    [cityType.jintang]      = "ChengDu",
    [cityType.huayang]      = "ChengDu",
    [cityType.dayi]         = "ChengDu",
    [cityType.qionglai]     = "ChengDu",
    [cityType.suining]      = "SuiNing",
    [cityType.renshou]      = "ChengDu",
    [cityType.jianyang]     = "ChengDu",
    [cityType.zhongjiang]   = "DeYang",
    [cityType.guanghan]     = "DeYang",
    [cityType.xichong]      = "NanChong",
    [cityType.nanchong]     = "NanChong",
    [cityType.maoxian]      = "ABa",
    [cityType.anyue]        = "ZiYang",
    [cityType.tianquan]     = "YaAn",
    [cityType.yingjing]     = "YaAn",
    [cityType.jiangyou]     = "MianYang",
}

--------------------------------------------------------------
--
--------------------------------------------------------------
cityTypeSID = {
    [cityType.chengdu]      = "ChengDu",
    [cityType.wenjiang]     = "WenJiang",
    [cityType.pixian]       = "PiXian",
    [cityType.jintang]      = "JinTang",
    [cityType.huayang]      = "HuaYang",
    [cityType.dayi]         = "DaYi",
    [cityType.qionglai]     = "QiongLai",
    [cityType.suining]      = "SuiNing",
    [cityType.renshou]      = "RenShou",
    [cityType.jianyang]     = "JianYang",
    [cityType.zhongjiang]   = "ZhongJiang",
    [cityType.guanghan]     = "GuanHan",
    [cityType.xichong]      = "XiChong",
    [cityType.nanchong]     = "NanChong",
    [cityType.maoxian]      = "MaoXian",
    [cityType.anyue]        = "AnYue",
    [cityType.tianquan]     = "TianQuan",
    [cityType.yingjing]     = "YingJing",
    [cityType.jiangyou]     = "JianYou",
}

--------------------------------------------------------------
--
--------------------------------------------------------------
gameType = {
    doushisi    = 2, --斗十四
    erqishi     = 3, --贰柒拾
    paodekuai   = 4, --跑得快
    mahjong     = 5, --麻将
    doudizhu    = 6, --斗地主
    hundizhu    = 7, --荤地主
    dpd14       = 8, --短牌斗十四
}

--------------------------------------------------------------
--
--------------------------------------------------------------
friendsterNotifyType = {
    createDesk          = 0,
    deskPlayerChanged   = 1,
    deskStart        	= 2,
    deskDestroy      	= 3,
    deskPlayerEnter  	= 4,
    deskPlayerExit   	= 5,
    cardsChanged       	= 6,
    friendsterDestroy   = 7,
    removeMember    	= 8,
    addMember  	        = 9,
    playerOffline 	    = 10,
    playerOnline  	    = 11,
    applyEnterRequest   = 12,
    playerPlayInClub    = 13,
    playerPlayEndClub   = 14,
    deskJuShuChanged    = 15,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
friendsterDeskStatus = {
    wait            = 0,
    playing         = 1,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
friendsterPlayerDeskStatus = {
    idle            = 0,
    indesk          = 1,
    playing         = 2,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
userType = {
    normal      = 0,--普通玩家
    proxy       = 1,--代理
    club        = 2,--仅可开亲友圈
    transfer    = 3,--仅可转账
    operation   = 4,--1 and 2 and 3
}

--------------------------------------------------------------
--
--------------------------------------------------------------
mailStatus = {
    notRead = 0,
    read    = 1,
    claimed = 2,
    deleted = 3,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
errCodeWx = {
    ok         =  0,
    comm       = -1,
    userCancel = -2,
    sentFailed = -3,
    authDenied = -4,
    unsupport  = -5,
    ban        = -6,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
gameMode = {
    normal   = 1,
    playback = 2,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
seatType = {
    mine  = 0,
    right = 1,
    top   = 2,
    left  = 3,
}

--endregion
