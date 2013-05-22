Actor = Serializable:subclass'Actor'

StaticImageActor = Actor:subclass'StaticImageActor'

function StaticImageActor:load()
	assert(self.image,"invalid image")
	assert(self.quad,"invalid quad")
	--assert(self.layer,"invalid layer")
	if self.quad == nil then
		-- TODO: build default quad
	end

	self.sprite = MOAIGfxQuad2D.new()
	self.sprite:setTexture(requireTexture(self.image))
	self.sprite:setRect(unpack(self.quad))
end

function StaticImageActor:getSize()
	local x1,y1,x2,y2 = unpack(self.quad)
	return math.abs(x2-x1),math.abs(y2-y1)
end

function StaticImageActor:getProp()
	if self.prop == nil then
		self.prop = MOAIProp2D.new()
	end
	self.prop:setDeck(self.sprite)
	if self.delegate then
		self.prop:setLoc(self.delegate:getPosition())
	end
	return self.prop
end

function StaticImageActor:update()
	self.sprite:setRect(unpack(self.quad))
	if self.delegate then
		self.prop:setLoc(self.delegate:getPosition())
		self.prop:setRot(self.delegate:getAngle())
	end
end

function StaticImageActor:loadShader(shader)
	assert(shader,"invalid shader")
	self.prop:setShader(shader)
end