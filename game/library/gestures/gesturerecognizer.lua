GestureRecognizer = Object:subclass'GestureRecognizer'

function GestureRecognizer:getTouch(idx)
	return MOAIInputMgr.device.touch:getTouch(idx)
end

function GestureRecognizer:getTouches()
	return coroutine.wrap(function()
		for i,idx in ipairs{MOAIInputMgr.device.touch:getActiveTouches()} do
			local x,y,tapCount = self:getTouch(idx)
			coroutine.yield(x,y,tapCount,idx)
		end
	end)
end

function GestureRecognizer:getNumberOfTouches()
	return self.touchCount
end

function GestureRecognizer:updatePosition()
	local tx,ty = 0,0
	local tapCount = self:getNumberOfTouches()
	if tapCount == 0 then
		return unpack(self.lastKnownLocation)
	end
	for x,y,_,idx in self:getTouches() do
		tx = tx + x
		ty = ty + y
	end
	tx,ty = tx/tapCount,ty/tapCount
	self.lastKnownLocation = {tx,ty}
	return tx,ty
end

function GestureRecognizer:getPosition()
	return unpack(self.lastKnownLocation)
end

function GestureRecognizer:initialize()
	self.state = 'readyToRecognize'
	self.touchCount = 0
	self.lastKnownLocation = {0,0}
end

function GestureRecognizer:changeState(state)
	self.state = state
	if self.delegate and self.delegate.gestureRecognizerChangedState then
		self.delegate:gestureRecognizerChangedState(self,state)
	end
end

function GestureRecognizer:recognized()
	return self.state ~= 'readyToRecognize'
end

function GestureRecognizer:shouldRecognize()
	if self:recognized() then return end
	if self.requireFailedGestures then
		for i,v in ipairs(self.requireFailedGestures) do
			if v:recognized() then
				return false
			end
		end
	end
	if self.delegate then
		for v,_ in pairs(self.delegate.recognizers) do
			if v ~= self then
				if self.delegate.shouldRecognizeSimutanously then
					if not self.delegate:shouldRecognizeSimutanously(self,v) then
						return false
					end
				end
			end
		end
	end
	return true
end

function GestureRecognizer:startRecognize()
	self:changeState'recognized'
end

function GestureRecognizer:finish()
	local x,y = self:getPosition()
	if self.delegate and self.delegate.gestureRecognizerFinished then
		self.delegate:gestureRecognizerFinished(self)
	end
	self:changeState'readyToRecognize'
end

function GestureRecognizer:fail()
	if self.delegate and self.delegate.gestureRecognizerFailed then
		self.delegate:gestureRecognizerFailed(self)
	end
	self:changeState'readyToRecognize'
end

function GestureRecognizer:change()
	if self.delegate and self.delegate.gestureRecognizerChanged then
		self.delegate:gestureRecognizerChanged(self)
	end
end

function GestureRecognizer:requireGesturesToFail(...)
	self.requireFailedGestures = arg
end

function GestureRecognizer:touchEvent(eventType,id,x,y,touchCount)
	if eventType == MOAITouchSensor.TOUCH_DOWN then
		self.touchCount = self.touchCount + 1
		self:updatePosition()
	elseif eventType == MOAITouchSensor.TOUCH_UP then
		self:updatePosition()
		self.touchCount = self.touchCount - 1
	else
		self:updatePosition()
	end
end