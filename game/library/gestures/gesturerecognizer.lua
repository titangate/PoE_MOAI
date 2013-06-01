GestureRecognizer = Object:subclass'GestureRecognizer'

function GestureRecognizer.getTouch(idx)
	return MOAIInputMgr.device.touch:getTouch(idx)
end

function GestureRecognizer:getTouches()
	return coroutine.wrap(function()
		for i,idx in ipairs{MOAIInputMgr.device.touch:getActiveTouches()} do
			local x,y,tapCount = GestureRecognizer.getTouch(idx)
			x,y = translateCoordinatesFormInput(x,y)
			coroutine.yield(x,y,tapCount,idx)
		end
	end)
end

function GestureRecognizer:getNumberOfTouches()
	return GestureRecognizer.touchCount
end

function GestureRecognizer:updatePosition()
	local tx,ty = 0,0
	local tapCount = GestureRecognizer.getNumberOfTouches()
	if tapCount == 0 then
		return unpack(GestureRecognizer.lastKnownLocation)
	end
	for x,y,_,idx in GestureRecognizer.getTouches() do
		tx = tx + x
		ty = ty + y
	end
	tx,ty = tx/tapCount,ty/tapCount
	GestureRecognizer.lastKnownLocation = {tx,ty}
	return tx,ty
end

function GestureRecognizer:getPosition()
	return unpack(GestureRecognizer.lastKnownLocation)
end

GestureRecognizer.touchCount = 0
GestureRecognizer.lastKnownLocation = {0,0}

function GestureRecognizer:initialize()
	self.state = 'readyToRecognize'
end

function GestureRecognizer:changeState(state)
	self.state = state
	self:pushNotification('GestureChangedState',{state = state})
end

function GestureRecognizer:recognized()
	return self.state ~= 'readyToRecognize'
end

function GestureRecognizer:shouldRecognize()
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
	
	self:pushNotification('GestureFinished')
	self:changeState'readyToRecognize'
end

function GestureRecognizer:fail()
	
	self:pushNotification('GestureFailed')
	self:changeState'readyToRecognize'
end

function GestureRecognizer:change()
	self:pushNotification('GestureChanged')
end

function GestureRecognizer:requireGesturesToFail(...)
	self.requireFailedGestures = arg
end

function GestureRecognizer.touchEvent(eventType,id,x,y,touchCount)
	if eventType == MOAITouchSensor.TOUCH_DOWN then
		GestureRecognizer.touchCount = GestureRecognizer.touchCount + 1
		GestureRecognizer.updatePosition()
	elseif eventType == MOAITouchSensor.TOUCH_UP then
		GestureRecognizer.updatePosition()
		GestureRecognizer.touchCount = GestureRecognizer.touchCount - 1
	else
		GestureRecognizer.updatePosition()
	end
end

function translateCoordinatesFormInput(x,y)
	assert(INPUT_TRANSFORM_MATRIX)
	return INPUT_TRANSFORM_MATRIX[1] * x + INPUT_TRANSFORM_MATRIX[2] * y + INPUT_TRANSFORM_MATRIX[5]
	, INPUT_TRANSFORM_MATRIX[3] * x + INPUT_TRANSFORM_MATRIX[4] * y + INPUT_TRANSFORM_MATRIX[6]
end