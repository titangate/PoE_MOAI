ActorLayer = Serializable:subclass'ActorLayer'

function ActorLayer:load()
	assert(self.actors,"invalid actor group")
end

function ActorLayer:clear()
	-- todo: remove objects on the layer
end

function ActorLayer:loadGFX(viewport)
	self.layer = MOAILayer2D.new()
	self.layer:setViewport(viewport)
	self.actors = {}
end

function ActorLayer:addActor(...)
	for k,v in ipairs(arg) do
		table.insert(self.actors,v)
		if v.getProps then
			for prop in v:getProps() do
				self.layer:insertProp(prop)
				prop:setParent(self.layer)
			end
		else
			self.layer:insertProp(v:getProp())
			v:getProp():setParent(self.layer)
		end
	end
end

function ActorLayer:getProp()
	return self.layer
end