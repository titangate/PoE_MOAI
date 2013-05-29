TransformGestureRecognizer = GestureRecognizer:subclass'TransformGestureRecognizer'


function TransformGestureRecognizer:initialize()
	GestureRecognizer.initialize(self)
	self.numberOfTouchesRequired = 2
	self.numberOfTouchesAllowed = 2
end

function TransformGestureRecognizer:collectTouches()
	assert(self:getNumberOfTouches()>=2,"wrong number of touches")
	touches = {}
	for x,y,_,idx in self:getTouches() do
		table.insert(touches,{idx=idx,x=x,y=y})
	end
	if touches[1].idx > touches[2].idx then
		touches[1],touches[2] = touches[2],touches[1]
	end
	self.collectedTouches = touches
end

function TransformGestureRecognizer:getScale()
	assert(self.initialSize)
	return self:getSize()/self.initialSize
end

function TransformGestureRecognizer:getAngle()
	assert(self.collectedTouches)
	local touchA,touchB = unpack(self.collectedTouches)
	return math.atan2(touchB.y-touchA.y,touchB.x-touchA.x)
end

function TransformGestureRecognizer:getSize()
	assert(self.collectedTouches)
	local touchA,touchB = unpack(self.collectedTouches)
	return magnitude(touchB.y-touchA.y,touchB.x-touchA.x)
end
	
function TransformGestureRecognizer:shouldRecognize()
	if not GestureRecognizer.shouldRecognize(self) then return false end
	return true
end

function TransformGestureRecognizer:startRecognize()
	GestureRecognizer.startRecognize(self)
end

function TransformGestureRecognizer:finish()
	self.pressElapsedTime,self.releaseElapsedTime = nil,nil
	self.posStored = nil
	GestureRecognizer.finish(self)
end

function TransformGestureRecognizer:fail()
	self.pressElapsedTime,self.releaseElapsedTime = nil,nil
	self.posStored = nil
	GestureRecognizer.fail(self)
end

function TransformGestureRecognizer:touchEvent(eventType,id,x,y,touchCount)
	GestureRecognizer.touchEvent(self,eventType,id,x,y,touchCount)
	if self.state == 'readyToRecognize' then
		if (eventType == MOAITouchSensor.TOUCH_DOWN) then
			if not self:shouldRecognize() then
				return
			end
			if self:getNumberOfTouches() < self.numberOfTouchesRequired then
				return
			end
			self:collectTouches()
			self.initialPosition = {self:getPosition()}
			self.initialAngle = self:getAngle()
			self.initialSize = self:getSize()
		elseif eventType == MOAITouchSensor.TOUCH_MOVE then
			if not self:shouldRecognize() then
    			assert(false)
				return
			end
			if self:getNumberOfTouches() < self.numberOfTouchesRequired then
				--print ('touches',self:getNumberOfTouches())
    			--assert(false)
				--return
			end
			self:startRecognize()
		elseif eventType == MOAITouchSensor.TOUCH_UP and self:getNumberOfTouches() < self.numberOfTouchesRequired then
			return
		end
	elseif self.state == 'recognized' then
		if self:getNumberOfTouches() > self.numberOfTouchesAllowed then
			self:fail()
			return
		end
		if (eventType == MOAITouchSensor.TOUCH_MOVE) then
			self:collectTouches()
			self:change()
		elseif (eventType == MOAITouchSensor.TOUCH_UP) then
			if self:getNumberOfTouches() < self.numberOfTouchesRequired then
				self:finish()
			end
		end
	end
end