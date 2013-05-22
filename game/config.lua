

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
	POE_CONTROLSCHEME = 'mobile'
	viewport:setRotation(90)
	if MOAIEnvironment.iosRetinaDisplay then
		POE_GLOBALSCALE = 2.0
	end
else
	POE_CONTROLSCHEME = 'desktop'
end