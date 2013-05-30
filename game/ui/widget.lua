Widget = ActorLayer:subclass'Widget'

local layer = MOAILayer2D.new()
function Widget.init(x,y,w,h)
	Widget.base = Widget()
	layer:setViewport(standardViewport())
	Widget.base.x,Widget.base.y = x,y
	Widget.base.w,Widget.base.h = w,h
	Widget.base:load(Widget.base)
	Widget.layer = layer
	Widget.base:setStyle(require 'ui.defaultstyle') -- default style
	if POE_CONTROLSCHEME == 'mobile' then
		MOAIInputMgr.device.touch:setCallback(function(eventType,id,x,y,touchCount)
	        x,y = translateCoordinatesFormInput(x,y)
	        GestureRecognizer.touchEvent(eventType,id,x,y,touchCount)
	        Widget.base:touchEvent(eventType,id,x,y,touchCount)
	    end)
	else
		MOAIInputMgr.device.mouseLeft:setCallback(function(isDown)
			local x,y = MOAIInputMgr.device.pointer:getLoc()
	        x,y = translateCoordinatesFormInput(x,y)
			if isDown then
				Widget.base:mousePressed('l',x,y)
			else
				Widget.base:mouseReleased('l',x,y)
			end
	    end)
	end
	return Widget.base
end

function Widget:touchEvent(...)
	if self.recognizers then
		for v,_ in pairs(self.recognizers) do
			v:touchEvent(...)
		end
	end
end

function Widget:mousePressed(key,x,y)
	print (key,'pressed at ',x,y)
end

function Widget:mouseReleased(key,x,y)
	print (key,'released at ',x,y)
end

function Widget:load(parent)
	assert (parent, "invalid parent")
	assert (self.w and self.h, "invalid size")
	assert (self.x and self.y, "invalid position")
	self:loadGFX(vp)
	self:setScale(1,1)
	self:setAngle(0)
	self:setPosition(self.x,self.y)
	self.children = self.children or {}
	self.parent = parent
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
	child.layer = self.layer
	ActorLayer.addActor(self,child)
end

function Widget:addWidget(child)
	assert (instanceOf(Widget,child), 'attempt to add non-widget')
	table.insert(self.children,child)
	child.parent = self
	child.layer = self.layer
	ActorLayer.addActor(self,child)
end

function Widget:removeWidget(child)
	local idx
	if type(child) ~= 'number' then
		for i,v in ipairs(self.children) do
			if v == child then
				idx,child = i,v
				break
			end
		end
	end
	child.parent = nil
	table.remove(self.children,idx)
	child:clear()
	ActorLayer.removeActor(self,child)
end

function Widget:clear()
	self:removeActor(self.backgroundImage)
	for i,v in ipairs(self.children) do
		self:removeWidget(v)
	end
end

function Widget:setSize(w,h)
	self.w,self.h = w,h
end
 
function Widget:setPosition(x,y)
	self.x,self.y = x,y
	self.group:setLoc(x,y)
end
 
function Widget:setScale(sx,sy)
	self.sx,self.sy = sx,sy
	self.group:setScl(sx,sy)
end
 
function Widget:setAngle(angle)
	self.angle = angle
	self.group:setRot(0,0,R2D(angle))
end
 
function Widget:getPosition()
	return self.x,self.y
end

function Widget:getSize()
	return self.w,self.h
end
 
function Widget:getScale()
	return self.sx,self.sy
end
 
function Widget:getAngle()
	return self.angle
end

function Widget:inBound(x,y)
	x,y = self.group:worldToModel(x,y)
	return inRect(x,y,0,0,self.w,self.h)
end

function Widget:setStyle(style)
	self.style = style
end

function Widget:getStyle(c)
	c = c or self.class.name
	local style = self.style
	if style then
		assert(style[c],string.format("%s style not found",c))
		return style[c]
	else
		return self.parent:getStyle(c)
	end
end

function Widget:addGestureRecognizer(recognizer)
	ensureEntries(self,'recognizers')
	self.recognizers[recognizer] = true
end

function Widget:setBackgroundImage(image,quad)
	if self.backgroundImage then
		self.ActorLayer:removeActor(self.backgroundImage)
	end
	if not image then return end
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
	--self.backgroundImage.prop:setLoc(self.x,self.y)
	self:updateBackgroundImage()
end
 
function Widget:updateBackgroundImage()
	assert(self.backgroundImage,"no background image set")
	self.backgroundImage.quad = standardQuad(self.w,self.h)
	self.backgroundImage:update()
end


function Widget:getProps()
	return coroutine.wrap(function()
	    coroutine.yield(self.group)
	    if self.debugprop then coroutine.yield(self.debugprop) end
	  end)
end

function Widget:enableDebugProp(debugEnabled)
	if self.debugEnabled == debugEnabled then
		return
	end
	if debugEnabled then
		if not self.debugprop then
			self.debugprop = MOAIProp2D.new()
			local deck = MOAIScriptDeck.new()
			local x,y = 0,0
			local w,h = self:getSize()
			local dx,dy = x-w/2,y-h/2
			local dx2,dy2 = x+w/2,y+h/2
			deck:setRect(x,y,x+w,y+h)
			deck:setDrawCallback(function()
				--assert(false)
				MOAIDraw.drawRect(dx,dy,dx2,dy2)
				MOAIDraw.drawLine(dx,dy,dx2+10,dy)
				MOAIDraw.drawLine(dx,dy,dx,dy2+10)
			end)
			self.debugprop:setDeck(deck)
		end
		self.layer:insertProp(self.debugprop)
		self.debugprop:setAttrLink(MOAIProp.INHERIT_TRANSFORM, self.group, MOAIProp.TRANSFORM_TRAIT)
	end
	for i,v in ipairs(self.children) do
		v:enableDebugProp(debugEnabled)
	end
	self.debugEnabled = debugEnabled
end