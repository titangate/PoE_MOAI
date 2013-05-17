require 'library.serializable'
Unit = Serializable:subclass'Unit'

-- Because this is a fully serializable object, there will be no initialization method. Rather,
-- A load function is run upon serialization completed to ensure necessary entries for running
function Unit:load()
	assert(self.x and self.y,"Invalid position")
	assert(self.bodyAngle,"Invalid angle")
	assert(self.headAngle,"Invalid headAngle")
	assert(self.speed,"Invalid speed")
	assert(self.rotationSpeed,"Invalid rotationSpeed")
end

function Unit:setPosition(x,y)
end

function Unit:setAngle(angle)
end

function Unit:setAngleHead(angle)
end

function Unit:getPosition()
end

function Unit:instructMoveTo(x,y)
end

function Unit:instructTurn(angle)
end

function Unit:instructTurnHead(angle)
end

function Unit:instructStop()
end

function Unit:instructUseAbility(ability)
end

function Unit:instruct(...)
	
end

function Unit:getActor()
	if self.actor == nil then
		self.actor = DebugUnitActor()
		self.actor:loadDefaultImage()
		self.actor:load()
		self.delegate = self
		-- todo: finish configuring actor
	end
	return self.actor
end