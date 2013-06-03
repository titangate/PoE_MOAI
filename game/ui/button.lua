Button = Widget:subclass'Button'

function Button:load(parent)
	Widget.load(self,parent)
	self.text = TextBoxActor()
	self.text.quad = standardQuad(self.w,self.h)
	self.text.style = self:getStyle().text
	self.text:load()
	self:addActor(self.text)
end

function Button:setTitle(title)
	self.text:setString(title)
end

function Button:setBorderStyle(style)
	Widget.setBorderStyle(self,style)
	sortPropPriorities{self.border:getProp(),self.text:getProp()}
end
end