require 'library.serializable'
Map = Serializable:subclass'Map'

-- Because this is a fully serializable object, there will be no initialization method. Rather,
-- A load function is run upon serialization completed to ensure necessary entries for running
local MAX_DIM = 1024
function Map:load(viewport)
	assert(self.width > 0 and self.width < MAX_DIM,"Invalid Width")
	assert(self.height > 0 and self.height < MAX_DIM,"Invalid Height")
	assert(self.ratio,"Invalid Pixel to grid ratio")
	self.unit = self.unit or {}
	self.layer = ActorLayer()
	self.layer:clear()
	self.layer:load()
	self.layer:loadGFX(viewport)
	if self.tileLayer then
		self:setTileLayer(self.tileLayer)
	end
	MOAIRenderMgr.pushRenderPass(self.layer.layer)


	local c = Camera()
	c:load()
	self.camera = c
	self.layer.layer:setCamera(c.camera)
end

function Map:update(dt)
	self.camera:update(dt)
end

function Map:addUnit(unit)
	self.layer:addActor(unit:getActor())
end

function Map:removeUnit(unit)
end

function Map:setTileLayer(tileLayer)
	self.tileLayer = tileLayer
	if tileLayer then
		self.layer:addActor(tileLayer:getActor())
	end
end

-- the map will be in a x-y plane grid
function Map:setTile(x,y,tileDef)
	assert (self.tileLayer, "invalid tile layer")
	self.tileLayer:setTile(x,y,tileDef)
end

function Map:getObstacle(x,y)
	if self.tileLayer then
		self.tileLayer:getTile(x,y)
	else
		return nil
	end
end