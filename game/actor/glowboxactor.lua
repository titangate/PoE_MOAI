GlowBoxActor = Actor:subclass'GlowBoxActor'

function GlowBoxActor:load()
	assert(self.w,self.h,"invalid dimension")
	assert(self.style,"invalid style")
	self.grid = MOAIGfxQuadListDeck2D.new()
	self.grid:setTexture(requireTexture(self.style.edgeimage))
	self.grid:reserveQuads(9)
	local style = self.style
	local halfW,halfH = self.w/2,self.h/2
	local marg = style.margin
	self.grid:setRect(1,-halfW-marg,-halfH-marg,-halfW,-halfH) -- top left
	self.grid:setRect(2,-halfW,-halfH-marg,halfW,-halfH) -- top
	self.grid:setRect(3,halfW,-halfH-marg,halfW+marg,-halfH) -- top right

	self.grid:setRect(4,-halfW-marg,-halfH,-halfW,halfH) -- left
	self.grid:setRect(5,-halfW,-halfH,halfW,halfH) -- center
	self.grid:setRect(6,halfW,-halfH,halfW+marg,halfH) -- right

	self.grid:setRect(7,-halfW-marg,halfH,-halfW,halfH+marg) -- bot left
	self.grid:setRect(8,-halfW,halfH,halfW,halfH+marg) -- bot
	self.grid:setRect(9,halfW,halfH,halfW+marg,halfH+marg) -- bot right

	self.grid:reserveUVQuads(9)
	local idx = 0
	for j=1,3 do
		for i=1,3 do
			self.grid:setUVRect(i+j*3-3,(i-1)/3,(j-1)/3,i/3,j/3)
		end
	end
	self.grid:reservePairs(9)
	for i=1,9 do
		self.grid:setPair(i,i,i)
	end
	self.grid:reserveLists(9)
	self.grid:setList(1,1,9)
end

function GlowBoxActor:getSize()
	local x1,y1,x2,y2 = unpack(self.quad)
	return math.abs(x2-x1),math.abs(y2-y1)
end

function GlowBoxActor:loadStyle(style)
	self.edgeimage = style.edgeimage
	self.quads = style.quads
end

function GlowBoxActor:getProp()
	if self.prop == nil then
		self.prop = MOAIProp2D.new()
	end
	self.prop:setDeck(self.grid)
	return self.prop
end

function GlowBoxActor:update()
end

function GlowBoxActor:loadShader(shader)
	assert(shader,"invalid shader")
	self.prop:setShader(shader)
end