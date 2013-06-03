Shader = Object:subclass'Shader'
Shader.sharedObject = {}

function Shader:getSharedObject()
	Shader.sharedObject[self.class.name] = Shader.sharedObject[self.class.name] or {}
	return Shader.sharedObject[self.class.name]
end

function Shader:setAttr(attr,target)
	local attidx = self:getSharedObject().att2idx[attr]
	local shader = self:getShader()
	shader:setAttr(attidx,target,duration,mode)
end

function Shader:moveAttr(attr,target,duration,mode)
	local attidx = self:getSharedObject().att2idx[attr]
	local shader = self:getShader()
	if duration then
		return shader:moveAttr(attidx,target,duration,mode)
	else
		return shader:setAttr(attidx,target,duration,mode)
	end
end
require 'shader.blur'
require 'shader.vibrate'