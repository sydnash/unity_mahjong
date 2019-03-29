--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

return {
    --成都
    [cityType.chengdu] = {
        ["mahjong"] = {
            enable = true,
            detail = {
                [gameType.mahjong] = true,
                [gameType.yaotongrenyong] = true,
            }
        },
        ["changpai"] = {
            enable = false,
        },
        ["poke"] = {
            enable = false,
        }
    },
    --温江
    [cityType.wenjiang] = {
        ["mahjong"] = {
            enable = true,
            detail = {
                [gameType.mahjong] = true,
            }
        },
        ["changpai"] = {
            enable = false,
        },
        ["poke"] = {
            enable = false,
        }
    },
    --金堂
    [cityType.jintang] = {
        ["mahjong"] = {
            enable = true,
            detail = {
                [gameType.mahjong] = true,
                [gameType.yaotongrenyong] = true,
            }
        },
        ["changpai"] = {
            enable = true,
            detail = {
                [gameType.doushisi] = true,
            }
        },
        ["poke"] = {
            enable = false,
            detail = {
                [gameType.doudizhu]  = false,
                [gameType.paodekuai] = false,
            }
        }
    },
    --西充
    [cityType.xichong] = {
        ["mahjong"] = {
            enable = true,
            detail = {
                [gameType.mahjong] = true,
            }
        },
        ["changpai"] = {
            enable = false,
        },
        ["poke"] = {
            enable = false,
        }
    },
    --南充
    [cityType.nanchong] = {
        ["mahjong"] = {
            enable = true,
            detail = {
                [gameType.mahjong] = true,
            }
        },
        ["changpai"] = {
            enable = false,
        },
        ["poke"] = {
            enable = false,
        }
    },
    --中江
    [cityType.zhongjiang] = {
        ["mahjong"] = {
            enable = true,
            detail = {
                [gameType.mahjong] = true,
            }
        },
        ["changpai"] = {
            enable = false,
        },
        ["poke"] = {
            enable = false,
        }
    },
    --荥经
    [cityType.yingjing] = {
        ["mahjong"] = {
            enable = true,
            detail = {
                [gameType.mahjong] = true,
            }
        },
        ["changpai"] = {
            enable = false,
        },
        ["poke"] = {
            enable = false,
        }
    },
}

--endregion
