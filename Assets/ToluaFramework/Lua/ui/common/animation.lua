--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("common.object")
local animation = class("animation", base)

local Animation = UnityEngine.Animation

----------------------------------------------------------------
--
----------------------------------------------------------------
function animation:ctor(gameObject)
    self:init(gameObject)
    self.component = getComponentU(gameObject, typeof(Animation))
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function animation:play()
    self.component:Rewind()
    self.component:Play()
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function animation:playAnimation(animationName)
    self.component:Rewind()
    self.component:Play(animationName)
end

----------------------------------------------------------------
--
----------------------------------------------------------------
function animation:addTrigger(triggerKey, callback, args)
    eventManager.registerAnimationTrigger(triggerKey, function()
        if callback ~= nil then
            callback(args)
        end
    end)
end

return animation

--endregion
