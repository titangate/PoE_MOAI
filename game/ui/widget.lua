Widget = ActorLayer:subclass'Widget'

function Widget.init(x,y,w,h)
	Widget.base = Widget()
	local vp = MOAIViewport.new()
	Widget.base.x,Widget.base.y = x,y
	Widget.base.w,Widget.base.h = w,h
	Widget.base:load()
	Widget.base:setStyle{} -- default style
	return Widget.base
end

function Widget:load()
	assert (self.w and self.h, "invalid size")
	assert (self.x and self.y, "invalid position")
	local vp = MOAIViewport.new()
	vp:setOffset(self.x,self.y)
	vp:setSize(self.w,self.h)
	vp:setScale(self.w,self.h)
	self:loadGFX(vp)
	self:setScale(1,1)
	self:setAngle(0)
	self.children = self.children or {}
end

function Widget:loadGFX(viewport)
	ActorLayer.loadGFX(self,viewport)
end

function Widget:update(dt)
	for i,v in ipairs(self.children) do
		v:update(dt)
	end
	if self.backgroundImage then
		self.backgroundImage:update()
	end
end

function Widget:insertWidget(child,index)
	assert (instanceOf(Widget,child), 'attempt to add non-widget')
	table.insert(self.children,index,child)
	child.parent = self
	ActorLayer.addActor(self,child)
end

function Widget:addWidget(child)
	assert (instanceOf(Widget,child), 'attempt to add non-widget')
	table.insert(self.children,child)
	child.parent = self
	ActorLayer.addActor(self,child)
end

function Widget:removeWidget(child)
	if type(child) ~= 'number' then
		for i,v in ipairs(self.children) do
			if v == child then
				child = i
				break
			end
		end
	end
	child.parent = nil
	table.remove(self.children,child)
end
function Widget:setSize(w,h)
	self.w,self.h = w,h
end
 
function Widget:setPosition(x,y)
	self.x,self.y = x,y
	self.layer:setLoc(x,y)
	local vp = self.layer:getViewport()
	vp:setOffset(x,y)
	self.layer:setViewport(vp)
end
 
function Widget:setScale(sx,sy)
	self.sx,self.sy = sx,sy
	self.layer:setScl(sx,sy)
end
 
function Widget:setAngle(angle)
	self.angle = angle
	self.layer:setRot(R2D(angle))
end
 
function Widget:getPosition()
	return self.x,self.y
end
 
function Widget:getScale()
	return self.sx,self.sy
end
 
function Widget:getAngle()
	return self.angle
end

function Widget:setStyle(style)
	self.style = style
end

function Widget:getStyle()
	return self.style or self.parent:getStyle()
end

function Widget:addGestureRecognizer(recognizer)
	ensureEntries(self,'recognizers')
	self.recognizers[recognizer] = true
end

function Widget:setBackgroundImage(image,quad)
	if self.backgroundImage then
		self.ActorLayer:removeActor(self.backgroundImage)
	end
	self.backgroundImage = StaticImageActor()
	self.backgroundImage.image = image
	if quad then
		self.backgroundImage.quad = quad
	else
		self.backgroundImage.quad = standardQuad(self.w,self.h)
	end
	--self.backgroundImage.delegate = self
	self.backgroundImage:load()
	self:addActor(self.backgroundImage)
	self:updateBackgroundImage()
end
 
function Widget:updateBackgroundImage()
	assert(self.backgroundImage,"no background image set")
	self.backgroundImage.quad = standardQuad(self.w,self.h)
	self.backgroundImage:update()
end