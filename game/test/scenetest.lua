return function()

print("Starting up on:" .. MOAIEnvironment.osBrand  .. " version:" .. (MOAIEnvironment.osVersion or 'UNDEFINED'))


-- tile layer test
local tilelayer = TileLayer()
tilelayer.w = 30
tilelayer.h = 20
tilelayer.wGrid = 64
tilelayer.hGrid = 64
tilelayer.image = 'asset/basicwall.png'
tilelayer.quad = {-256,-32,256,32}
tilelayer.tilesetDef = {
1,1,1,0,1
}
tilelayer:load()
local t = require 'map.testmap'.terrain
for j=0,19 do
	for i=1,30 do
		tilelayer:setTile(i,j,t[j*30+i]+4)
	end
end
local layer = MOAILayer2D.new()
local vp = MOAIViewport.new()
local x,y = 0,0
local w,h = screenWidth,screenHeight
vp:setOffset(x,y)
vp:setSize(w,h)
vp:setScale(w,h)
layer:setViewport(vp)
local simpleScene = Map()
simpleScene.width,simpleScene.height = 40,40
simpleScene.ratio = 32
simpleScene.tileLayer = tilelayer
simpleScene:load(layer)
local unit1 = Unit()
unit1:setPosition(300,300)
simpleScene:addUnit(unit1)
local unit2 = Unit()
unit2:setPosition(400,300)
simpleScene:addUnit(unit2)
simpleScene.camera:follow(unit1)

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
			unit1:update(elapsedTime)
			unit2:update(elapsedTime)
			coroutine.yield()
		end
	end
	)
end