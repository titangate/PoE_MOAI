if screenWidth == nil then screenWidth = 1280 end
if screenHeight == nil then screenHeight = 768 end


MOAISim.openWindow("Window",screenWidth,screenHeight)

viewport = MOAIViewport.new()
viewport:setSize(screenWidth,screenHeight)
viewport:setScale(screenWidth,screenHeight)