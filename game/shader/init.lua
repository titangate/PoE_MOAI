Shader = Object:subclass'Shader'
Shader.sharedObject = {}

function Shader:getSharedObject()
	Shader.sharedObject[self.class.name] = Shader.sharedObject[self.class.name] or {}
	return Shader.sharedObject[self.class.name]
end

function Shader:setAttr(attr,target,duration,mode)
	local attidx = self:getSharedObject().att2idx[attr]
	local shader = self:getShader()
	if duration then
		return shader:seekAttr(attidx,target,duration,mode)
	else
		print 'immediate'
		return shader:setAttr(attidx,target,duration,mode)
	end
end
require 'shader.blur'
require 'shader.vibrate'