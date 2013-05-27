Widget = ActorLayer:subclass'Widget'

function Widget.init(x,y,w,h)
	Widget.base = Widget()
	local vp = MOAIViewport.new()
	vp:setOffset(x,y)
	vp:setSize(w,h)
	Widget.base:loadGFX(vp)
	Widget.base:setStyle{} -- default style
	return Widget.base
end

function Widget:load()
	assert (self.w and self.h, "invalid size")
	assert (self.x and self.y, "invalid position")
	local vp = MOAIViewport.new()
	vp:setOffset(self.x,self.y)
	vp:setSize(self.w,self.h)
	self:loadGFX(vp)

	self.children = self.children or {}
end

function Widget:loadGFX(viewport)
	ActorLayer.loadGFX(self,viewport)
end

function Widget:update(dt)
	for i,v in ipairs(self.children) do
		v:update(dt)
	end
end

function Widget:insertWidget(child,index)
	assert (child:isKindOf(Widget), 'attempt to add non-widget')
	table.insert(self.children,index,child)
	child.parent = self
end

function Widget:addWidget(child)
	assert (child:isKindOf(Widget), 'attempt to add non-widget')
	table.insert(self.children,child)
	child.parent = self
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