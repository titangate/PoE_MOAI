return function()

screenWidth = MOAIEnvironment.screenWidth
screenHeight = MOAIEnvironment.screenHeight
print("Starting up on:" .. MOAIEnvironment.osBrand  .. " version:" .. (MOAIEnvironment.osVersion or '1'))

if screenWidth == nil then screenWidth = 1280 end
if screenHeight == nil then screenHeight = 768 end

MOAISim.openWindow("Window",screenWidth,screenHeight)

viewport = MOAIViewport.new()
viewport:setSize(screenWidth,screenHeight)
viewport:setScale(screenWidth,screenHeight)

local AL = ActorLayer()
AL:clear()
AL:loadGFX(viewport)

MOAIRenderMgr.pushRenderPass(AL.layer)

local SIA = StaticImageActor()
SIA.image = 'banner.png'
SIA.quad = {-468, -144, 468, 144}
SIA:load()
AL:addActor(SIA)

end