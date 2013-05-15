function Shader.blur()
	local file
	file = assert ( io.open ( 'shader/tex2d.vsh', mode ),"fail to read fragment shader")
	local vsh = file:read ( '*all' )
	file:close ()

	file = assert ( io.open ( 'shader/blur.fsh', mode ),"fail to read vertex shader")
	local fsh = file:read ( '*all' )
	file:close ()
	local shader = MOAIShader.new()
	shader:reserveUniforms(2)
	shader:declareUniform(1,'blurSize',MOAIShader.UNIFORM_FLOAT)
	shader:declareUniform(2,'xOverY',MOAIShader.UNIFORM_FLOAT)
	
	shader:setVertexAttribute ( 1, 'position' )
	shader:setVertexAttribute ( 2, 'uv' )
	shader:setVertexAttribute ( 3, 'color' )
	shader:load ( vsh, fsh )
	return shader
end
