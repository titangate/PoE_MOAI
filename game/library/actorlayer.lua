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
	v.parent = self
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
	local x,y,r,sx,sy = self:getOverallTransform()
	t.x,t.y = self:getPosition()
	t.angle = self:getAngle()
	t.sx,t.sy = self:getScale()
	table.insert(self._transformStack,t)
	self.toptransform = {}
	t = self.toptransform
	t.x,t.y = x,y
	t.angle = r
	t.sx,t.sy = sx,sy
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
	local t = self.toptransform --self._transformStack[#self._transformStack]
	self:setPosition(t.x,t.y)
	self:setScale(t.sx,t.sy)
	self:setAngle(t.angle)
end

function ActorLayer:loadStandardTransform()
	local x,y,r,sx,sy = self:getOverallTransform()
	self:setScale(1/sx,1/sy)
	self:setAngle(-r)
	self:setPosition(-x,-y)
end

function ActorLayer:enablePreRender(enable)
	if enable then
		assert(not self._subprops,'pre render is already enabled')
		local vp = MOAIViewport.new()
		vp:setScale(self.w,-self.h)
		vp:setSize(self.w,self.h)
		vp:setRotation(R2D(self:getAngle()))
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
		frameBuffer:setClearColor ( 0, 0, 0, 0 )
		MOAIRenderMgr.setBufferTable ({ frameBuffer })
		self.prelayer = layer

		local group = MOAIProp.new()
		self._group = self.group
		self.group = group

		self._group:clearAttrLink(MOAIProp.INHERIT_TRANSFORM)

		assert(self.parent.group)
		group:setAttrLink(MOAIProp.INHERIT_TRANSFORM, self.parent.group, MOAIProp.TRANSFORM_TRAIT)
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
		self.group:setAttrLink(MOAIProp.INHERIT_TRANSFORM, self.parent.group, MOAIProp.TRANSFORM_TRAIT)
	end
end

function ActorLayer:setSize(w,h)
	self.w,self.h = w,h
end
 
function ActorLayer:setPosition(x,y,...)
	self.x,self.y = x,y
	self.group:seekLoc(x,y,0,...)
end
 
function ActorLayer:setScale(sx,sy,...)
	self.sx,self.sy = sx,sy
	self.group:seekScl(sx,sy,0,...)
end
 
function ActorLayer:setAngle(angle,...)
	self.angle = angle
	self.group:seekRot(0,0,R2D(angle),...)
end
 
function ActorLayer:getPosition()
	return self.group:getLoc()
end

function ActorLayer:getSize()
	return self.w,self.h
end
 
function ActorLayer:getScale()
	return self.group:getScl()
end

function ActorLayer:getAngle()
	return self.angle
end

function ActorLayer:inBound(x,y)
	x,y = self.group:worldToModel(x,y)
	return inRect(x,y,0,0,self.w,self.h)
end


function ActorLayer:getOverallTransform(x,y,r,sx,sy)
	transform = self.group
	x,y = x or 0,y or 0
	r = r or 0
	sx,sy = sx or 1, sy or 1
	r = r + transform:getRot()
	local tsx,tsy = transform:getScl()
	sx,sy = sx/tsx,sy/tsy
	local tx,ty = transform:getLoc()
	x,y = x+tx*tsx, y+ty*tsy
	if self.parent and self.parent ~= self then
		return self.parent:getOverallTransform(x,y,r,sx,sy)
	end
	return x,y,r,sx,sy
end
