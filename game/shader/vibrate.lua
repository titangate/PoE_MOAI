Shader.Vibrate = Shader:subclass'Shader.Vibrate'

local Vibrate = Shader.Vibrate
function Vibrate:initialize()
	local obj = self:getSharedObject()
	if not obj.shader then
		local file
		file = assert ( io.open ( 'shader/tex2d.vsh', mode ),"fail to read fragment shader")
		local vsh = file:read ( '*all' )
		file:close ()

		file = assert ( io.open ( 'shader/vibrate.fsh', mode ),"fail to read vertex shader")
		local fsh = file:read ( '*all' )
		file:close ()
		local shader = MOAIShader.new()
		shader:reserveUniforms(1)
		shader:declareUniform(1,'intensity',MOAIShader.UNIFORM_FLOAT)
		shader:setVertexAttribute ( 1, 'position' )
		shader:setVertexAttribute ( 2, 'uv' )
		shader:setVertexAttribute ( 3, 'color' )
		shader:load ( vsh, fsh )
		obj.shader = shader
	end
	if not obj.att2idx then
		obj.att2idx = {
			intensity = 1,
		}
	end
end

function Vibrate:getShader()
	local obj = self:getSharedObject()
	return obj.shader
end