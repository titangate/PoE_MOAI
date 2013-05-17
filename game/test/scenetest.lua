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

end