

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
	INPUT_TRANSFORM_MATRIX = {0,1,1,0,-screenHeight/2,-screenWidth/2}
	if MOAIEnvironment.iosRetinaDisplay then
		POE_GLOBALSCALE = 2.0
	end
	function standardViewport()
		local vp = MOAIViewport.new()
		vp:setOffset(0,0)
		vp:setSize(screenWidth,screenHeight)
		vp:setScale(screenWidth,screenHeight)
		vp:setRotation(90)
		return vp
	end
else
	POE_CONTROLSCHEME = 'desktop'
	INPUT_TRANSFORM_MATRIX = {1,0,0,-1,-screenWidth/2,screenHeight/2}
	function standardViewport()
		local vp = MOAIViewport.new()
		vp:setOffset(0,0)
		vp:setSize(screenWidth,screenHeight)
		vp:setScale(screenWidth,screenHeight)
		return vp
	end
end