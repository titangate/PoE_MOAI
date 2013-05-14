ActorLayer = Serializable:subclass'ActorLayer'

function ActorLayer:load()
	assert(self.actors,"invalid actor group")
end

function ActorLayer:clear()
	-- todo: remove objects on the layer
	self.actors = {}
end

function ActorLayer:loadGFX(viewport)
	self.layer = MOAILayer2D.new()
	self.layer:setViewport(viewport)
end

function ActorLayer:addActor(actor)
	table.insert(self.actors,actor)
	self.layer:insertProp(actor:getProp())
end