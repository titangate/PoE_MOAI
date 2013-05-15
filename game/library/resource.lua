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

function neartwo(n)
	local r=1
	while r<n do
		r = r*2
	end
	return r
end

local canvasmanager = {}
function requireCanvas(w,h)
	w,h = neartwo(w),neartwo(h)
	w = math.min(w,screen.width)
	h = math.min(h,screen.height)
	if not canvasmanager[w*10000+h] then
		canvasmanager[w*10000+h] = {}
	end
	if #canvasmanager[w*10000+h] < 1 then
		table.insert(canvasmanager[w*10000+h],{canvas = gra.newCanvas(w,h),w=w,h=h})
	end
	assert(#canvasmanager[w*10000+h]>0)
	return table.remove(canvasmanager[w*10000+h])
end

function releaseCanvas(c)
	assert(canvasmanager[c.w*10000+c.h])
	table.insert(canvasmanager[c.w*10000+c.h],c)
end
