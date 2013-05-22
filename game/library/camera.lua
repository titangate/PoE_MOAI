Camera = Serializable:subclass'Camera'

function Camera:load()
	self.camera = MOAICamera2D.new()
end

function Camera:follow(unit)
	self.followingUnit = unit
end

function Camera:setFollowAngle(followAngle)
	self.followAngle = followAngle
end

function Camera:update(dt)
	if self.followingUnit ~= nil then
		local x,y = self.followingUnit:getPosition()
		self.camera:seekLoc(x,y,0)
		if self.followAngle then
			self.camera:seekRot(self.followingUnit:getAngle(),dt)
		end
	end
end