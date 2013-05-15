
function Shader.vibrate(obj)
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
	shader:setAttr(1, 0)
	shader:moveAttr(1, 5.0,5)
	shader:setVertexAttribute ( 1, 'position' )
	shader:setVertexAttribute ( 2, 'uv' )
	shader:setVertexAttribute ( 3, 'color' )
	shader:load ( vsh, fsh )
	obj.prop:seekScl(5,1,5)
	return shader
end