TextBoxActor = Actor:subclass'TextBoxActor'

function TextBoxActor:load()
	assert(self.quad,"invalid quad")
	assert(self.style,"invalid style")

	self.text = MOAITextBox.new()
	self.text:setYFlip(true)
	self.text:setRect(unpack(self.quad))
	local s = self.style
	if s then
		if s.textStyle then
			for k,v in pairs(s.textStyle) do
				self.text:setStyle(k,v)
			end
		end
		self:setTextSize(s.textSize,s.dpi)
		self:setAlignment(s.alignmentHorz,s.alignmentVert)
		self:setFont(s.font)
	end
end

local alignmentmap = {
	left = MOAITextBox.LEFT_JUSTIFY,
	center = MOAITextBox.CENTER_JUSTIFY,
	right = MOAITextBox.RIGHT_JUSTIFY
}
function TextBoxActor:setAlignment(alignmentHorz,alignmentVert)
	local alignHorz = alignmentmap[alignmentHorz]
	local alignVert = alignmentmap[alignmentVert]
	assert(alignHorz,string.format("%s is not a valid alignment mode",alignmentHorz))
	assert(alignVert,string.format("%s is not a valid alignment mode",alignmentVert))
	self.text:setAlignment(alignHorz,alignVert)
end

function TextBoxActor:processString(s)
	return s
end

function TextBoxActor:setString(s)
	s = self:processString(s)
	self.text:setString(s)
end

function TextBoxActor:setTextSize(size,dpi)
	self.text:setTextSize(size,dpi)
end

function TextBoxActor:setFont( font )
	self.text:setFont(font)
end

function TextBoxActor:setHighlight(...)
	self.text:setHighlight(...)
end

function TextBoxActor:getSize()
	local x1,y1,x2,y2 = unpack(self.quad)
	return math.abs(x2-x1),math.abs(y2-y1)
end

function TextBoxActor:getProp()
	return self.text
end

function TextBoxActor:update()
end

function TextBoxActor:loadShader(shader)
	assert(shader,"invalid shader")
	self.prop:setShader(shader)
end