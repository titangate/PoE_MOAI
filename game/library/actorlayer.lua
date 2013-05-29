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

function ActorLayer:addProp(prop)
	self.layer:insertProp(prop)
	prop:setAttrLink(MOAIProp.INHERIT_TRANSFORM, self.group, MOAIProp.TRANSFORM_TRAIT)
end

function ActorLayer:removeProp(prop)
	self.layer:removeProp(prop)
end

function ActorLayer:addActor(...)
	for k,v in ipairs(arg) do
		table.insert(self.actors,v)
		if v.getProps then
			for prop in v:getProps() do
				self:addProp(prop)
			end
		else
			self:addProp(v:getProp())
		end
	end
end

function ActorLayer:removeActor(...)
	for k,v in ipairs(arg) do
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
end

function ActorLayer:getProp()
	return self.group
end