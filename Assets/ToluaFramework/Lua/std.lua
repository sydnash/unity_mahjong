--region *.lua
---------------------------------------------------------------------------
-- Unity Engine
---------------------------------------------------------------------------

Application     = UnityEngine.Application
MonoBehaviour	= UnityEngine.MonoBehaviour
GameObject  	= UnityEngine.GameObject
Transform   	= UnityEngine.Transform
RectTransform   = UnityEngine.RectTransform
BoxCollider 	= UnityEngine.BoxCollider

---------------------------------------------------------------------------
-- reload lua module
---------------------------------------------------------------------------
function reload(packageName)
    package.loaded[packageName] = nil
    return require(packageName)
end

---------------------------------------------------------------------------
-- Lua Module
---------------------------------------------------------------------------

appConfig = reload("config.appConfig")

reload("utils.string")
reload("utils.table")
reload("utils.utils")

object              = reload("common.object")
component           = reload("common.component")
time                = reload("utils.time")
json                = reload("utils.json")
viewManager         = reload("manager.viewManager")
eventManager        = reload("manager.eventManager")
soundManager        = reload("manager.soundManager")
sceneManager        = reload("manager.sceneManager")
tweenManager        = reload("manager.tweenManager")
modelManager        = reload("manager.modelManager")
textureManager      = reload("manager.textureManager")
animationManager    = reload("manager.animationManager")
preloadManager      = reload("manager.preloadManager")
signalManager       = reload("manager.signalManager")

--endregion