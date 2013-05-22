TileLayerActor = Actor:subclass'TileLayerActor'

function TileLayerActor:load()
	assert(self.image,"invalid image")
	assert(self.grid,"invalid grid")
	assert(self.quad,"invalid quad")
	self.sprite = MOAITileDeck2D.new()
	self.sprite:setTexture(requireTexture(self.image))
	local w,h = quadGetDimension(self.quad)
	self.sprite:setSize(math.floor(w/self.wGrid),math.floor(h/self.hGrid))

	
	-- TODO: load definition
end

function TileLayerActor:getProp()
	if self.prop == nil then
		self.prop = MOAIProp2D.new()
	end
	self.prop:setDeck(self.sprite)
	self.prop:setGrid(self.grid)
	if self.delegate then
		--self.prop:setLoc(self.delegate:getPosition())
	end
	return self.prop
end

function TileLayerActor:update()
	self.sprite:setRect(unpack(self.quad))
	if self.delegate then
		self.prop:setLoc(self.delegate:getPosition())
		self.prop:setRot(self.delegate:getAngle())
	end
end

function TileLayerActor:loadShader(shader)
	assert(shader,"invalid shader")
	self.prop:setShader(shader)
end