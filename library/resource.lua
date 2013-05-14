local textureRepo = {}
setmetatable( textureRepo , {
	__mode = "k"
	}) -- weak reference, unused texture is collected

function requireTexture(tex)
	if textureRepo[tex] == nil then
		textureRepo[tex] = MOAIImage.new()
		textureRepo[tex]:load(tex)
		-- feature: default image
	end
	return textureRepo[tex]
end