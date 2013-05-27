require 'ui.widget'
return function()
local base = Widget.init(0,0,screenWidth,screenHeight)
local tg = TransformGestureRecognizer()
base:addGestureRecognizer(tg)
tg.delegate = base
MOAIInputMgr.device.touch:setCallback(function(...)
	tg:touchEvent(...)
end)
end