return function()

print("Starting up on:" .. MOAIEnvironment.osBrand  .. " version:" .. (MOAIEnvironment.osVersion or 'UNDEFINED'))


-- tile layer test
local tilelayer = TileLayer()
tilelayer.w = 10
tilelayer.h = 10
tilelayer.wGrid = 64
tilelayer.hGrid = 64
tilelayer.image = 'asset/basicwall.png'
tilelayer.quad = {-256,-32,256,32}
tilelayer.tilesetDef = {
1,1,1,0,1
}
tilelayer:load()

tilelayer:setTile(1,1,5)
tilelayer:setTile(2,1,4)
tilelayer:setTile(3,1,4)
tilelayer:setTile(4,1,4)
tilelayer:setTile(5,1,5)

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