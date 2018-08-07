--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local component = class("component")

----------------------------------------------------------------
--
----------------------------------------------------------------
function component:ctor()
    self.gameObject = nil
    self.transform = nil
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function component:start(gameObject)
    assert(gameObject ~= nil, "gameObject of component can't be nil")

    self.gameObject = gameObject
    self.transform = gameObject.transform

    if self.update ~= nil and type(self.update) == "function" then
        self.updateHandler = UpdateBeat:CreateListener(self.update, self)
        UpdateBeat:AddListener(self.updateHandler)
    end
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function component:destroy()
    if self.updateHandler ~= nil then
        UpdateBeat:RemoveListener(self.updateHandler)
    end

    self.gameObject = nil
    self.transform = nil
end

return component

--endregion
