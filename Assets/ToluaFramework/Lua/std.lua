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

appConfig = require("config.appConfig")

require("utils.string")
require("utils.table")
require("utils.utils")

object              = require("common.object")
component           = require("common.component")
time                = require("utils.time")
json                = require("utils.json")
viewManager         = require("manager.viewManager")
eventManager        = require("manager.eventManager")
soundManager        = require("manager.soundManager")
sceneManager        = require("manager.sceneManager")
tweenManager        = require("manager.tweenManager")
modelManager        = require("manager.modelManager")
textureManager      = require("manager.textureManager")
animationManager    = require("manager.animationManager")
preloadManager      = require("manager.preloadManager")
signalManager       = require("manager.signalManager")

--endregion