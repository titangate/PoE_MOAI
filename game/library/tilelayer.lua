TileLayer = Serializable:subclass'TileLayer'

function TileLayer:load()
	assert(self.image,"invalid image")
	assert(self.w and self.h,"invalid size")
	assert(self.wGrid and self.hGrid,"invalid grid size")
	--assert(self.wTile and self.hTile,"invalid tile grid size")
	--assert(self.gridDef,"invalid grid definition")
	self.grid = MOAIGrid.new()
	self.grid:initRectGrid(self.w,self.h,self.wGrid,self.hGrid)
	if self.gridDef then
		self:loadGridDefinition()
	end
end

function TileLayer:loadGridDefinition()
	assert(self.gridDef,"invalid grid definition")
end

function TileLayer:getActor()
	if self.actor == nil then
		self.actor = TileLayerActor()
		self.actor.tileDef = self.tileDef
		self.actor.image = self.image
		self.actor.w = self.w
		self.actor.h = self.h
		self.actor.wGrid = self.wGrid
		self.actor.hGrid = self.hGrid
		self.actor.quad = self.quad
		self.actor.grid = self.grid
		self.actor:load()
		self.actor.delegate = self
		-- todo: finish configuring actor
	end
	return self.actor
end

function TileLayer:setTile(x,y,tileDef)
	self.grid:setTile(x,y,tileDef.tile)
	self.grid:setTileFlags(x,y,tileDef.flags)
end

function TileLayer:getTile(x,y)
	return {tile = self.grid:getTile(x,y),
		flags = self.grid:getTileFlags(x,y)
	}
end