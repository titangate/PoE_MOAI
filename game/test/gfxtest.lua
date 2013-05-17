return function()

print("Starting up on:" .. MOAIEnvironment.osBrand  .. " version:" .. (MOAIEnvironment.osVersion or 'UNDEFINED'))


local AL = ActorLayer()
AL:clear()
AL:loadGFX(viewport)

MOAIRenderMgr.pushRenderPass(AL.layer)

local SIA = StaticImageActor()
SIA.image = 'banner.png'
SIA.quad = {-468, -144, 468, 144}
SIA:load()
AL:addActor(SIA)
SIA:loadShader(Shader.vibrate(SIA))
local c = Camera()
c:load()
c:follow(SIA)
AL.layer:setCamera(c.camera)
c:update(1)
end