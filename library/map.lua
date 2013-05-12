require 'library.serializable'
Map = Serializable:subclass'Map'

-- Because this is a fully serializable object, there will be no initialization method. Rather,
-- A load function is run upon serialization completed to ensure necessary entries for running
local MAX_DIM = 1024
function Map:load()
	assert(self.width > 0 and self.width < MAX_DIM,"Invalid Width")
	assert(self.height > 0 and self.height < MAX_DIM,"Invalid Height")
	assert(self.unit,"Invalid unit group")
	assert(self.obstacle,"Invalid obstacle definition")
end

function Map:update(dt)
end

function Map:addUnit(unit)
end

function Map:removeUnit(unit)
end

-- the map will be in a x-y plane grid
function Map:setObstacle(x,y,obstacle)
end
