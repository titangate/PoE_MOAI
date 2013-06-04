Table = Widget:subclass'Table'

function Table:load(parent)
	Widget.load(self,parent)
	self.sc = MOAIScissorRect.new()
	self.sc:setRect(self.x-self.w/2,self.y-self.h/2,self.x+self.w/2,self.y-100+self.h/2)
	local style = self:getStyle()
	self.title = Button()
	self.title.quad = standardQuad(self.w,style.titleHeight)
	self.title.x,self.title.y = 0,self.h/2 - style.titleHeight
	self.title.w,self.title.h = self.w-style.titleHeight,style.titleHeight
	self.title:setStyle(style.titleStyle)
	self.title:load(self)
	self:addWidget(self.title)
end

function Table:addActor(actor,...)
	Widget.addActor(self,actor,...)
	for prop in self:getAllSubProps() do
		-- we don't want to scissor the border or the title
		if self.title and prop == self.title.text:getProp() then
			return
		end
		if self.border and prop == self.border:getProp() then
			return
		end
		assert(prop.setScissorRect,string.format("%s doesn't have scissor property",tostring(prop)))
		prop:setScissorRect(self.sc)
	end
end

function Table:setTitle(title)
	self.title:setTitle(title)
end

function Table:setBorderStyle(style)
	Widget.setBorderStyle(self,style)
end

function Table:setContentOffset(x,y,t,mode)

end