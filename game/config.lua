

if MOAIEnvironment.osBrand == 'iOS' then
	screenWidth = MOAIEnvironment.horizontalResolution
	screenHeight = MOAIEnvironment.verticalResolution
end

if screenWidth == nil then screenWidth = 1280 end
if screenHeight == nil then screenHeight = 768 end

MOAISim.openWindow("Window",screenWidth,screenHeight)

viewport = MOAIViewport.new()
viewport:setSize(screenWidth,screenHeight)
viewport:setScale(screenWidth,screenHeight)
if MOAIEnvironment.osBrand == 'iOS' then
	viewport:setRotation(90)
end