local TAP_INTERVAL_THRESHOLD = 0.2
local TAP_DISTANCE_THRESHOLD = 1000

TapGestureRecognizer = GestureRecognizer:subclass'TapGestureRecognizer'

function TapGestureRecognizer:initialize()
	GestureRecognizer.initialize(self)
	self.numberOfTouchesRequired = 1
	self.numberOfTouchesAllowed = 2
end
	
function TapGestureRecognizer:shouldRecognize()
	if not GestureRecognizer.shouldRecognize(self) then return false end
	return true
end

function TapGestureRecognizer:startRecognize()
	GestureRecognizer.startRecognize(self)
end

function TapGestureRecognizer:finish()
	self.pressElapsedTime,self.releaseElapsedTime = nil,nil
	self.posStored = nil
	GestureRecognizer.finish(self)
end

function TapGestureRecognizer:fail()
	self.pressElapsedTime,self.releaseElapsedTime = nil,nil
	self.posStored = nil
	GestureRecognizer.fail(self)
end

function TapGestureRecognizer:touchEvent(eventType,id,x,y,touchCount)
	if self.state == 'readyToRecognize' then
		if (eventType == MOAITouchSensor.TOUCH_DOWN) then
			if not self:shouldRecognize() then
				return
			end
			if self:getNumberOfTouches() < self.numberOfTouchesRequired then
				return
			end
			self.initialPosition = {self:getPosition()}
			self:startRecognize()
			self.pressElapsedTime = MOAISim.getElapsedTime()
			self.releaseElapsedTime = nil
		end
	elseif self.state == 'recognized' then
		if eventType == MOAITouchSensor.TOUCH_MOVE then
			if not self:shouldRecognize() then
				self:fail()
				return
			end
		end
		if self:getNumberOfTouches() > self.numberOfTouchesAllowed then
			self:fail()
			return
		end
		if (eventType == MOAITouchSensor.TOUCH_DOWN) then
			if MOAISim.getElapsedTime() - self.pressElapsedTime > TAP_INTERVAL_THRESHOLD then
				self:fail()
				return
			end
			self.initialPosition = {self:getPosition()}
		elseif (eventType == MOAITouchSensor.TOUCH_UP) then
			self.releaseElapsedTime = self.releaseElapsedTime or MOAISim.getElapsedTime()
			if MOAISim.getElapsedTime() - self.releaseElapsedTime > TAP_INTERVAL_THRESHOLD then
				self:fail()
				return
			end
			self.posStored = self.posStored or {}
			table.insert(self.posStored,{x,y})
			if (self:getNumberOfTouches() == 0) then
				print(distanceSquare(self.initialPosition,findAveragePoint(self.posStored)))
				if distanceSquare(self.initialPosition,findAveragePoint(self.posStored)) > TAP_DISTANCE_THRESHOLD then
					self:fail()
					return
				end
				self:finish()
			end
		end
	end
end