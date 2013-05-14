if screenWidth == nil then screenWidth = 640 end
if screenHeight == nil then screenHeight = 1136 end

MOAISim.openWindow("Window",screenWidth,screenHeight)

viewport = MOAIViewport.new()
viewport:setSize(screenWidth,screenHeight)
viewport:setScale(screenWidth,screenHeight)
viewport:setRotation(90)