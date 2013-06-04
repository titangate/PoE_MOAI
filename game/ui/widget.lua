Widget = ActorLayer:subclass'Widget'
local layer = MOAILayer2D.new()
local clearColor = MOAIColor.new()
clearColor:setColor(0,0,0,0)
layer:setClearColor(clearColor)
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

function Widget:touchEvent(eventType,id,x,y,touchCount)
	if self.invis or self.disableInteractivity then return end
	if not self:inBound(x,y) then return end
	if self.recognizers then
		for v,_ in pairs(self.recognizers) do
			v:touchEvent(eventType,id,x,y,touchCount)
		end
	end
	for i,v in ipairs(self.children) do
		v:touchEvent(eventType,id,x,y,touchCount)
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

function Widget:setBorderStyle(style)
	if style == 'none' then
		-- do nothing
	elseif style == 'box' or style == 'edge' then
		local box = GlowBoxActor()
		box.style = self:getStyle('GlowBoxActor')
		box.x,box.y = self.x,self.y
		box.w,box.h = self.w,self.h
		box.borderStyle = style
		box:load()
		self.border = box
		self.border:getProp():setPriority(-1)
		self:addActor(box)
	end
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

function Widget:enablePreRender(enable)
	if enable then
		local img = ActorLayer.enablePreRender(self,enable)
		self._preRendered = StaticImageActor()
		self._preRendered.image = img
		self._preRendered.quad = standardQuad(self.w,self.h)
		self._preRendered:load()
		self:addActor(self._preRendered)
	else
		self:removeActor(self._preRendered)
		ActorLayer.enablePreRender(self,enable)
	end
end

function Widget:setBackgroundImage(image,quad)
	if self.backgroundImage then
		self:removeActor(self.backgroundImage)
	end
	if not image then return end
	self.backgroundImage = StaticImageActor()
	self.backgroundImage.image = image
	if quad then
		self.backgroundImage.quad = quad
	else
		self.backgroundImage.quad = standardQuad(self.w,self.h)
	end
	self.backgroundImage:load()
	self:addActor(self.backgroundImage)
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
		self.debugprop:setAttrLink(MOAIColor.INHERIT_COLOR, self.group, MOAIColor.COLOR_TRAIT)
	end
	for i,v in ipairs(self.children) do
		v:enableDebugProp(debugEnabled)
	end
	self.debugEnabled = debugEnabled
end

function Widget:transitionIn()
	local r,g,b,a = unpack(self:getStyle().color or {1,1,1,1})
	self.group:setColor(r,g,b,0)
	self.group:seekColor(r,g,b,a,.5)
	self.group:setScl(self.sx*1.5,self.sy*1.5)
	self.group:seekScl(self.sx,self.sy,1,.5)
end

function Widget:transitionOut()
	local r,g,b,a = unpack(self:getStyle().color or {1,1,1,1})
	self.group:setColor(r,g,b,a)
	self.group:seekColor(r,g,b,0,.5)
	self.group:setScl(self.sx,self.sy)
	self.group:seekScl(self.sx*1.5,self.sy*1.5,1,.5)
end

function Widget:vibrateIn()
	local shader = Shader.Vibrate()
	local thread = MOAIThread.new ()
	thread:run (function()
		self:enablePreRender(true)
		local r,g,b,a = unpack(self:getStyle().color or {1,1,1,1})
		self.group:setColor(r,g,b,0)
		self.group:seekColor(r,g,b,a,.5)
		self._preRendered:loadShader(shader)
		shader:setAttr('intensity',5)
		self._preRendered:setScale(2,1)
		self._preRendered:setScale(1,1,.5)
		MOAICoroutine.blockOnAction(shader:moveAttr('intensity',-5,.5))
		self:enablePreRender()
	end)
end