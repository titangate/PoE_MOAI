Table = Widget:subclass'Table'

function Table:load(parent)
	Widget.load(self,parent)

	local style = self:getStyle()
	self.title = Button()
	self.title.quad = standardQuad(self.w,style.titleHeight)
	self.title.x,self.title.y = 0,self.h/2 - style.titleHeight
	self.title.w,self.title.h = self.w-style.titleHeight,style.titleHeight
	self.title:setStyle(style.titleStyle)
	self.title:load(self)
	self:addWidget(self.title)
end

function Table:setTitle(title)
	self.title:setTitle(title)
end