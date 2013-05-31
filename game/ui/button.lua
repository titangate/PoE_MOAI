Button = Widget:subclass'Button'

function Button:load(parent)
	Widget.load(self,parent)
	self.text = TextBoxActor()
	self.text.quad = standardQuad(self.w,self.h)
	self.text.style = self:getStyle().text
--[[
	local text = MOAITextBox.new()
	text:setString(b.title or 'BUTTON')
	text:setTextSize(60,72)
	text:setYFlip(true)
	assert(style.font)
	text:setFont(style.font)
	text:setRect(-320,-240,320,240)
	text:setAlignment(MOAITextBox.CENTER_JUSTIFY,MOAITextBox.CENTER_JUSTIFY)
	b.layer:insertProp(text)
	b.textbox = text]]
	--[[local box = GlowBoxActor()
	box.style = self:getStyle('GlowBoxActor')
	box.x,box.y = self.x,self.y
	box.w,box.h = self.w,self.h
	box:load()]]

	self:setBorderStyle'edge'
	self.text:load()
	self:addActor(self.text)
end

function Button:setTitle(title)
	self.text:setString(title)
end