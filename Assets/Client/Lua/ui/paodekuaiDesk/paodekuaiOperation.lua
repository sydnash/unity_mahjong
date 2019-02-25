--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local base = require("ui.common.view")
local paodekuaiOperation = class("paodekuaiOperation", base)

_RES_(paodekuaiOperation, "PaodekuaiDeskUI", "DeskOperationUI")

local mainCameraParams = {
    position = Vector3.New(2000, 0, -13.43),
    rotation = Quaternion.Euler(0, 0, 0),
    hWidth   = 12.80,
}

local inhandCameraParams = {
    position = Vector3.New(2000, 0, -0.9),
    size = 3.6
}

function paodekuaiOperation:ctor(game)
    self.game = game
    base.ctor(self)
end

function paodekuaiOperation:onInit()
    local mainCamera = UnityEngine.Camera.main
    mainCamera.transform.position = mainCameraParams.position
    mainCamera.transform.rotation = mainCameraParams.rotation
    fixMainCameraParam(mainCameraParams.hWidth, mainCamera)
    local bl = Vector3.New(0, 0, math.abs(mainCamera.transform.position.z))
    local tr = Vector3.New(1, 1, math.abs(mainCamera.transform.position.z))

    local wbl = mainCamera:ViewportToWorldPoint(bl)
    local wtr = mainCamera:ViewportToWorldPoint(tr)

    self.safeArea = {}
    self.safeArea.bottom    = wbl.y
    self.safeArea.right     = wtr.x - 1000
    self.safeArea.left      = wbl.x - 1000
    self.safeArea.top       = wtr.y
    self.safeArea.cx        = 0
    self.safeArea.cy        = 0

    local camera = GameObjectPicker.instance.camera
    camera.transform.position = inhandCameraParams.position
    camera.orthographicSize = inhandCameraParams.size
    fixInhandCameraParam(inhandCameraParams.size, camera)

    local inhandCameraT = camera.transform
    inhandCameraT.position = Vector3.New(inhandCameraT.position.x, self.safeArea.bottom + camera.orthographicSize, inhandCameraT.position.z)

end

function paodekuaiOperation:reset()
    
end

return paodekuaiOperation

--endregion
