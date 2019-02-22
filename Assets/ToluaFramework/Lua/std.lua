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
-- Lua Module
---------------------------------------------------------------------------

appConfig = reload("config.appConfig")

reload("utils.string")
reload("utils.table")
reload("utils.utils")

--object              = reload("common.object")
--component           = reload("common.component")
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
signalManager       = reload("manager.signalManager")

--endregion