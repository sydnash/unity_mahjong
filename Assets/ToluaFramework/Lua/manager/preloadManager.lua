--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local token = class("token")
local id = 1

-----------------------------------------------------------------------------
-- 构造token
-----------------------------------------------------------------------------
function token:ctor(assetType)
    self.id = id
    self.assetType = assetType
    self.preload = PreloadManager.instance

    id = id + 1
end

-----------------------------------------------------------------------------
-- 压入加载参数
-----------------------------------------------------------------------------
function token:push(assetPath, assetName, maxCount)
    self.preload:Push(self.id, self.assetType, assetPath, assetName, maxCount)
end

-----------------------------------------------------------------------------
-- 开始加载
-----------------------------------------------------------------------------
function token:start()
    self.preload:Load(self.id, appConfig.loadCountPreFrame)
end

-----------------------------------------------------------------------------
-- 停止加载
-----------------------------------------------------------------------------
function token:stop()
    self.preload:End(self.id)
end

-----------------------------------------------------------------------------
-- 预加载管理器
-----------------------------------------------------------------------------

local preloadManager = {}

-----------------------------------------------------------------------------
-- 创建预加载token
-----------------------------------------------------------------------------
function preloadManager.createToken(assetType)
    return token.new(assetType)
end

return preloadManager

--endregion
