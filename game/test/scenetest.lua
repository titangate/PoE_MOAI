return function()

print("Starting up on:" .. MOAIEnvironment.osBrand  .. " version:" .. (MOAIEnvironment.osVersion or 'UNDEFINED'))

local simpleScene = Map()
simpleScene.width,simpleScene.height = 40,40
simpleScene.ratio = 32
simpleScene:load(viewport)
local unit1 = Unit()
unit1:setPosition(0,0)
simpleScene:addUnit(unit1)
local unit2 = Unit()
unit2:setPosition(300,0)
--simpleScene:addUnit(unit2)

local prevElapsedTime = MOAISim.getDeviceTime()
local elapsedTime = 0
local thread = MOAICoroutine.new()
thread:run(
		function()
			while (true) do
			local currElapsedTime = MOAISim.getDeviceTime()
			elapsedTime = currElapsedTime - prevElapsedTime
			prevElapsedTime = currElapsedTime
			simpleScene:update(elapsedTime)
			coroutine.yield()
		end
	end
	)
end