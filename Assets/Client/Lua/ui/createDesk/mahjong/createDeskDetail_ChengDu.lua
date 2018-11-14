--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local createDeskDetail = class("createDeskDetail", base)

_RES_(createDeskDetail, "CreateDeskUI/Mahjong", "CreateDeskDetialUI_ChengDu")
local filepath = ""

function createDeskDetail:onInit()
    self.mRenShu4.n = "RenShu"
    self.mRenShu4.v = 1
    self.mRenShu3.n = "RenShu"
    self.mRenShu3.v = 2
    self.mRenShu2.n = "RenShu"
    self.mRenShu2.v = 3

    self.mJuShu08.n = "JuShu"
    self.mJuShu08.v  = 1
    self.mJuShu12.n = "JuShu"
    self.mJuShu12.v = 2
    self.mJuShu16.n = "JuShu"
    self.mJuShu16.v = 3

    self.mFangShu3.n = "FangShu"
    self.mFangShu3.v = 1
    self.mFangShu2.n = "FangShu"
    self.mFangShu2.v = 2

    self.mFengDing3.n = "FengDing"
    self.mFengDing3.v = 1
    self.mFengDing4.n = "FengDing"
    self.mFengDing4.v = 2
    self.mFengDing5.n = "FengDing"
    self.mFengDing5.v = 3

    self.mZiMoJiaDi.n = "ZiMoJiaX"
    self.mZiMoJiaDi.v = 1
    self.mZiMoJiaFan.n = "ZiMoJiaX"
    self.mZiMoJiaFan.v = 2

    self.mDianGangHuaPao.n = "DianGangHuaX"
    self.mDianGangHuaPao.v = 1
    self.mDianGangHuaMo.n = "DianGangHuaX"
    self.mDianGangHuaMo.v = 2

    self.mRenShu4:addChangedListener(self.onRadioboxChangedHandler, self)
    self.mRenShu3:addChangedListener(self.onRadioboxChangedHandler, self)
    self.mRenShu2:addChangedListener(self.onRadioboxChangedHandler, self)
    self.mJuShu08:addChangedListener(self.onRadioboxChangedHandler, self)
    self.mJuShu12:addChangedListener(self.onRadioboxChangedHandler, self)
    self.mJuShu16:addChangedListener(self.onRadioboxChangedHandler, self)
    self.mFangShu3:addChangedListener(self.onRadioboxChangedHandler, self)
    self.mFangShu2:addChangedListener(self.onRadioboxChangedHandler, self)
    self.mFengDing3:addChangedListener(self.onRadioboxChangedHandler, self)
    self.mFengDing4:addChangedListener(self.onRadioboxChangedHandler, self)
    self.mFengDing5:addChangedListener(self.onRadioboxChangedHandler, self)
    self.mZiMoJiaDi:addChangedListener(self.onRadioboxChangedHandler, self)
    self.mZiMoJiaFan:addChangedListener(self.onRadioboxChangedHandler, self)
    self.mDianGangHuaPao:addChangedListener(self.onRadioboxChangedHandler, self)
    self.mDianGangHuaMo:addChangedListener(self.onRadioboxChangedHandler, self)

    self.mHuanSanZhang.n = "HuanNZhang"
    self.mHuanSanZhang.v = 2
    self.mHuanSiZhang.n = "HuanNZhang"
    self.mHuanSiZhang.v = 3

    self.mHuanSanZhang:addChangedListener(self.OnHuanNZhangChangedHandler, self)
    self.mHuanSiZhang:addChangedListener(self.OnHuanNZhangChangedHandler, self)

    self.mYaoJiu.n = "YaoJiu"
    self.mZhongZhang.n = "ZhongZhang"
    self.mJiangDui.n = "JiangDui"
    self.mMenQing.n = "MenQIng"
    self.mTianDiHu.n = "TianDiHu"

    self.mYaoJiu:addChangedListener(self.onCheckboxChangedHandler, self)
    self.mZhongZhang:addChangedListener(self.onCheckboxChangedHandler, self)
    self.mJiangDui:addChangedListener(self.onCheckboxChangedHandler, self)
    self.mMenQing:addChangedListener(self.onCheckboxChangedHandler, self)
    self.mTianDiHu:addChangedListener(self.onCheckboxChangedHandler, self)
end

function createDeskDetail:set(config)
    self.config = config
    self:refreshUI()
end

function createDeskDetail:refreshUI()
    self.mRenShu4:setSelected(self.config.RenShu == self.mRenShu4.v)
    self.mRenShu3:setSelected(self.config.RenShu == self.mRenShu3.v)
    self.mRenShu2:setSelected(self.config.RenShu == self.mRenShu2.v)

    self.mJuShu08:setSelected(self.config.JuShu == self.mJuShu08.v)
    self.mJuShu12:setSelected(self.config.JuShu == self.mJuShu12.v)
    self.mJuShu16:setSelected(self.config.JuShu == self.mJuShu16.v)

    self.mFangShu3:setSelected(self.config.FangShu == self.mFangShu3.v)
    self.mFangShu2:setSelected(self.config.FangShu == self.mFangShu2.v)

    self.mFengDing3:setSelected(self.config.FangShu == self.mFengDing3.v)
    self.mFengDing4:setSelected(self.config.FangShu == self.mFengDing4.v)
    self.mFengDing5:setSelected(self.config.FangShu == self.mFengDing5.v)

    self.mZiMoJiaDi:setSelected(self.config.ZiMoJiaX == self.mZiMoJiaDi.v)
    self.mZiMoJiaFan:setSelected(self.config.ZiMoJiaX == self.mZiMoJiaFan.v)

    self.mDianGangHuaPao:setSelected(self.config.ZiMoJiaX == self.mDianGangHuaPao.v)
    self.mDianGangHuaMo:setSelected(self.config.ZiMoJiaX == self.mDianGangHuaMo.v)

    self.mHuanSanZhang:setSelected(self.config.HuanNZhang == self.mHuanSanZhang.v)
    self.mHuanSiZhang:setSelected(self.config.HuanNZhang == self.mHuanSiZhang.v)
    

    self.mYaoJiu:setSelected(self.config.YaoJiu == 1)
    self.mZhongZhang:setSelected(self.config.ZhongZhang == 1)
    self.mJiangDui:setSelected(self.config.JiangDui == 1)
    self.mMenQing:setSelected(self.config.MenQing == 1)
    self.mTianDiHu:setSelected(self.config.TianDiHu == 1)
end

function createDeskDetail:onRadioboxChangedHandler(sender, selected, clicked)
    if clicked and selected then
        playButtonClickSound()
        self.config[sender.n] = sender.v
    end
end

function createDeskDetail:onCheckboxChangedHandler(sender, selected, clicked)
    if clicked then
        playButtonClickSound()
        self.config[sender.n] = selected and 1 or 2
    end
end

function createDeskDetail:OnHuanNZhangChangedHandler(sender, selected, clicked)
    if clicked then
        playButtonClickSound()
        self.config[sender.n] = selected and sender.v or 1
    end
end

function createDeskDetail:onDestroy()
    self.mScrollRect:reset()
    self.super.onDestroy(self)
end

return createDeskDetail

--endregion
