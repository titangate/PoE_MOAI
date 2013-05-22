DebugUnitActor = StaticImageActor:subclass'DebugUnitActor'

function DebugUnitActor:load()
	assert(self.imageBody,"invalid image")
	assert(self.imageHead,"invalid image")
	assert(self.quad,"invalid quad")
	assert(self.quadHead,"invalid quad")
	--assert(self.layer,"invalid layer")
	if self.quad == nil then
		-- TODO: build default quad
	end

	self.spriteBody = MOAIGfxQuad2D.new()
	self.spriteBody:setTexture(requireTexture(self.imageBody))
	self.spriteBody:setRect(unpack(self.quad))
	self.spriteHead = MOAIGfxQuad2D.new()
	self.spriteHead:setTexture(requireTexture(self.imageHead))
	self.spriteHead:setRect(unpack(self.quadHead))
	self.prop = {}
	self.r = self.r or 0
	self.rHead = self.rHead or 0
end

function DebugUnitActor:getPosition()
	-- todo: load actual position
	return self.x,self.y
end

function DebugUnitActor:setPosition(x,y)
	self.x,self.y = x,y
	self.prop:setLoc(self:getPosition())
end

function DebugUnitActor:setBodyAngle(angle)
	self.r = angle
end
function DebugUnitActor:setHeadAngle(angle)
	self.rHead = angle
end

function DebugUnitActor:getAngle()
	return self.r
end

function DebugUnitActor:getSize()
	local x1,y1,x2,y2 = unpack(self.quad)
	return math.abs(x2-x1),math.abs(y2-y1)
end

function DebugUnitActor:getProps()
	if self.propHead == nil then
		self.propHead = MOAIProp2D.new()
		self.prop[2] = self.propHead
		self.propHead:setScl(.5)
	end
	self.propHead:setDeck(self.spriteHead)
	self.propHead:setLoc(self:getPosition())
	if self.propBody == nil then
		self.propBody = MOAIProp2D.new()
		self.prop[1] = self.propBody
		self.propBody:setScl(.5)
	end
	self.propBody:setDeck(self.spriteBody)
	self.propHead:setLoc(self:getPosition())
	self.propBody:setLoc(self:getPosition())
	return coroutine.wrap(function()
	    coroutine.yield(self.prop[1])
	    coroutine.yield(self.prop[2])
	  end)
end

function DebugUnitActor:update()
	self.spriteBody:setRect(unpack(self.quad))
	if self.delegate then
		self.propBody:setLoc(self.delegate:getPosition())
		self.propHead:setLoc(self.delegate:getPosition())
	end
	self.propBody:setRot(self.r)
	self.propHead:setRot(self.r + self.rHead)
end

function DebugUnitActor:loadDefaultImage()
	self.imageHead = "asset/testunitactorhead.png"
	self.imageBody = "asset/testunitactorbody.png"
	self.quad = {-32,-64,32,64}
	self.quadHead = {-32,-32,32,32}
end

function DebugUnitActor:loadShader(shader)
	assert(shader,"invalid shader")
	self.prop:setShader(shader)
end