ActorLayer = Serializable:subclass'ActorLayer'

function ActorLayer:load()
end

function ActorLayer:clear()
	-- todo: remove objects on the layer
end

function ActorLayer:loadGFX(viewport)
	self.group = MOAIProp.new()
	--self.layer:setViewport(viewport)
	self.actors = {}
end

function ActorLayer:addProp(prop,linkAttr)
	self.layer:insertProp(prop)
	if linkAttr then
		prop:setAttrLink(MOAIProp.INHERIT_TRANSFORM, self.group, MOAIProp.TRANSFORM_TRAIT)
		prop:setAttrLink(MOAIColor.INHERIT_COLOR, self.group, MOAIColor.COLOR_TRAIT)
	end
end

function ActorLayer:removeProp(prop)
	self.layer:removeProp(prop)
	prop:setScissorRect()
end

function ActorLayer:addActor(v,linkAttr)
	if linkAttr == nil then
		linkAttr = true
	end
	table.insert(self.actors,v)
	if v.getProps then
		for prop in v:getProps() do
			self:addProp(prop,linkAttr)
		end
	else
		self:addProp(v:getProp(),linkAttr)
	end
end

function ActorLayer:removeActor(v)
	for i,actor in pairs(self.actors) do
		if actor == v then
			table.remove(self.actors,i)
			if v.getProps then
				for prop in v:getProps() do
					self:removeProp(prop)
				end
			else
				self:removeProp(v:getProp())
			end
			break
		end
	end
end

function ActorLayer:addActors(...)
	for k,v in ipairs(arg) do
		self:addActor(v)
	end
end

function ActorLayer:removeActors(...)
	for k,v in ipairs(arg) do
		self:removeActor(v)
	end
end

function ActorLayer:getProp()
	return self.group
end

function ActorLayer:_getAllSubProps()
	coroutine.yield(self.group)
	for i,v in ipairs(self.actors) do
		assert(v._getAllSubProps,string.format("%s does not have subprop accessor",tostring(v)))
		v:_getAllSubProps()
	end
end

function ActorLayer:getAllSubProps()
	return coroutine.wrap(function()
		self:_getAllSubProps()
	end)
end

function ActorLayer:pushTransform()
	self._transformStack = self._transformStack or {}
	local t = self._transformStack
	t.x,t.y = self:getPosition()
	t.sx,t.sy = self:getScale()
	t.angle = self:getAngle()
	table.insert(self._transformStack,t)
end

function ActorLayer:popTransform()
	assert (self._transformStack and #self._transformStack > 0, 'transform not pushed')
	local t = table.remove(self._transformStack)
	self:setPosition(t.x,t.y)
	self:setScale(t.sx,t.sy)
	self:setAngle(t.angle)
end

function ActorLayer:applyTopTransform()
	assert (self._transformStack and #self._transformStack > 0, 'transform not pushed')
	local t = self._transformStack[#self._transformStack]
	self:setPosition(t.x,t.y)
	self:setScale(t.sx,t.sy)
	self:setAngle(t.angle)
end

function ActorLayer:loadStandardTransform()
	self:setPosition(0,0)
	self:setScale(self.sx,self.sy)
	self:setAngle(0)
end

function ActorLayer:enablePreRender(enable)
	-- TODO: unlink property for existing objects
	if enable then
		assert(not self._subprops,'pre render is already enabled')
		self:pushTransform()
		self:loadStandardTransform()
		local vp = MOAIViewport.new()
		vp:setScale(self.w,-self.h)
		vp:setSize(self.w,self.h)
		vp:setRotation(R2D(self.angle))
		local layer = MOAILayer2D.new()
		layer:setViewport(vp)
		self._subprops = {}
		for v in self:getAllSubProps() do
			self.layer:removeProp(v)
			layer:insertProp(v)
			table.insert(self._subprops,v)
		end
		local frameBuffer = MOAIFrameBufferTexture.new ()
		
		frameBuffer:setRenderTable({layer})
		frameBuffer:init(self:getSize())
		frameBuffer:setClearColor ( 0, 0, 0, 1 )
		MOAIRenderMgr.setBufferTable ({ frameBuffer })
		self.prelayer = layer

		local group = MOAIProp.new()
		self._group = self.group
		self.group = group

		self:applyTopTransform()
		--group:setAttrLink(MOAIProp.INHERIT_TRANSFORM, self._group, MOAIProp.TRANSFORM_TRAIT)
		--group:setAttrLink(MOAIColor.INHERIT_COLOR, self._group, MOAIColor.COLOR_TRAIT)
		return frameBuffer
	else
		assert(self._subprops,'pre render is not enabled')
		for _,v in ipairs(self._subprops) do
		self.prelayer:removeProp(v)
		self.layer:insertProp(v)
		end
		self._subprops = nil
		self.group = self._group
		self._group = nil
		self:popTransform()
	end
end

function ActorLayer:finishPreRender()
	
end

function ActorLayer:setSize(w,h)
	self.w,self.h = w,h
end
 
function ActorLayer:setPosition(x,y)
	self.x,self.y = x,y
	self.group:setLoc(x,y)
end
 
function ActorLayer:setScale(sx,sy)
	self.sx,self.sy = sx,sy
	self.group:setScl(sx,sy)
end
 
function ActorLayer:setAngle(angle)
	self.angle = angle
	self.group:setRot(0,0,R2D(angle))
end
 
function ActorLayer:getPosition()
	return self.x,self.y
end

function ActorLayer:getSize()
	return self.w,self.h
end
 
function ActorLayer:getScale()
	return self.sx,self.sy
end

function ActorLayer:getAngle()
	return self.angle
end

function ActorLayer:inBound(x,y)
	x,y = self.group:worldToModel(x,y)
	return inRect(x,y,0,0,self.w,self.h)
end
