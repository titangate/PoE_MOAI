return function()

print("Starting up on:" .. MOAIEnvironment.osBrand  .. " version:" .. (MOAIEnvironment.osVersion or 'UNDEFINED'))


-- tile layer test
local tilelayer = TileLayer()
tilelayer.w = 10
tilelayer.h = 10
tilelayer.wGrid = 64
tilelayer.hGrid = 64
tilelayer.image = 'asset/basicwall.png'
tilelayer.quad = {-128,-32,128,32}
tilelayer:load()

tilelayer:setTile(1,1,{tile=3,flags=0})
tilelayer:setTile(2,1,{tile=1,flags=0})
tilelayer:setTile(3,1,{tile=2,flags=0})

local simpleScene = Map()
simpleScene.width,simpleScene.height = 40,40
simpleScene.ratio = 32
simpleScene.tileLayer = tilelayer
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