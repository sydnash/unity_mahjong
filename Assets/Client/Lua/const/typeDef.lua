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
-- 桌布
--------------------------------------------------------------
tablecloth = {
    dft = "zm_zb01",
    qxl = "zm_zb02",
    mhw = "zm_zb03",
    hj  = "zm_zb04",
    paodekuai = { 
        qsl = "pdk_zb01", 
        bsl = "pdk_zb02", 
    },
}

--------------------------------------------------------------
--
--------------------------------------------------------------
sexType = {
    boy  = 1,
    girl = 2,
}

friendsterMemberDeskStatus = {
    idle     = 0,
    indesk   = 1,
    playing  = 2,
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
    jiangQiDui          = 10,
    jiaXinWu            = 11,
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
                      bijiao        = 34,
           } 
    },
    guo  = { id = 6 },
    dui  = { id = 8 },
    --
    doushisi = {
        dang        = { id = 0   },
	    hua         = { id = 1   },
	    chu         = { id = 2   },
	    chi         = { id = 3   },
	    che         = { id = 4   },
	    hu          = { id = 5   },
	    gang        = { id = 6   },
	    pass        = { id = 7   },
	    fan         = { id = 8   },
	    mo          = { id = 9   },
	    an          = { id = 10  },
	    zhao        = { id = 11  },
	    shou        = { id = 12  },
	    bao         = { id = 13  },
	    baGang      = { id = 14  },
	    chiChengSan = { id = 15  },
	    caiShen     = { id = 16  },
	    baoJiao     = { id = 17  },
	    gen         = { id = 18  },
        weiGui      = { id = 19  },
        budang      = { id = 100 },
	},
    --
    paodekuai = {
        chu      = { id = 1 },
	    tianGuan = { id = 2 },
	    pass     = { id = 3 },
	    buChu    = { id = 4 },
    },
}

--------------------------------------------------------------
--
--------------------------------------------------------------
chatType = { 
    voice       = 0,
    text        = 1,
    emojimsg    = 2, --交互表情
    cmsg        = 3, --输入的文字
    emoji       = 4, --普通头像表情
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
    city                                = 9,
    closeAllUI                          = 10,
    refreshFriendsterDetailInfo         = 11,
    cityForClub                         = 12,
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
    doushisi        = 2, --斗十四
    erqishi         = 3, --贰柒拾
    paodekuai       = 4, --跑得快
    mahjong         = 5, --血战到底
    doudizhu        = 6, --斗地主
    hundizhu        = 7, --荤地主
    dpd14           = 8, --短牌斗十四
    yaotongrenyong  = 9, --幺筒任用
}

--------------------------------------------------------------
--
--------------------------------------------------------------
friendsterNotifyType = {
    createDesk              = 0,
    deskPlayerChanged       = 1,
    deskStart        	    = 2,
    deskDestroy      	    = 3,
    deskPlayerEnter  	    = 4,
    deskPlayerExit   	    = 5,
    cardsChanged       	    = 6,
    friendsterDestroy       = 7,
    removeMember    	    = 8,
    addMember  	            = 9,
    playerOffline 	        = 10,
    playerOnline  	        = 11,
    applyEnterRequest       = 12,
    playerPlayInClub        = 13,
    playerPlayEndClub       = 14,
    deskJuShuChanged        = 15,
    supportGameIdChanged    = 16,
    gameIdCfgChanged        = 17,
    changeMemberPermission  = 18,
    applyDeleted            = 19,
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

--------------------------------------------------------------
--
--------------------------------------------------------------
doushisiStyle = {
    traditional = 1,
    modern      = 2,
}

--------------------------------------------------------------
--
--------------------------------------------------------------
doushisiColor = {
    red     = 1,
    black   = 2,
    none    = 3,
}

defaultFriendsterSupporCityGames = {
    [cityType.chengdu] = {
        gameType.mahjong, gameType.yaotongrenyong,
    },
    [cityType.wenjiang] = {
        gameType.mahjong, gameType.doushisi, gameType.hundizhu, gameType.yaotongrenyong,
    },
    [cityType.jintang] = {
        gameType.doushisi, gameType.paodekuai, gameType.mahjong, gameType.doudizhu, gameType.yaotongrenyong,
    },
    [cityType.yingjing] = {
        gameType.mahjong, gameType.erqishi, gameType.yaotongrenyong,
    },
    [cityType.zhongjiang] = {
        gameType.mahjong, gameType.doushisi, gameType.yaotongrenyong,
    },
    [cityType.nanchong] = {
        gameType.mahjong, gameType.doushisi, gameType.doudizhu, gameType.hundizhu, gameType.yaotongrenyong,
    },
    [cityType.xichong] = {
        gameType.mahjong, gameType.doushisi, gameType.doudizhu, gameType.hundizhu, gameType.yaotongrenyong,
    },
}

gameClassify = {
    {
        id = 1,
        name = "麻将",
        games = {gameType.mahjong, gameType.yaotongrenyong},
    },
    {
        id = 2,
        name = "长牌",
        games = {gameType.doushisi, gameType.erqishi},
    },
    {
        id = 3,
        name = "扑克",
        games = {gameType.doudizhu, gameType.paodekuai, gameType.hundizhu},
    },
}

function getGameClassify(gt)
    for _, v in pairs(gameClassify) do
        if table.indexOf(v.games, gt) then
            return v.id, v.name
        end
    end
    return nil, nil
end

--endregion
