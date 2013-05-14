if screenWidth == nil then screenWidth = 1536 end
if screenHeight == nil then screenHeight = 2048 end


MOAISim.openWindow("Window",screenWidth,screenHeight)

viewport = MOAIViewport.new()
viewport:setSize(screenWidth,screenHeight)
viewport:setScale(screenWidth,screenHeight)
viewport:setRotation(90)