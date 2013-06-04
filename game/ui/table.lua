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

function Table:enablePreRender(...)
	Widget.enablePreRender(self,...)
	--self._preRendered:getProp():setScissorRect(self.sc)
end

function Table:setTitle(title)
	self.title:setTitle(title)
end

function Table:setBorderStyle(style)
	Widget.setBorderStyle(self,style)
end

function Table:setContentOffset(x,y,t,mode)
	self:enablePreRender(true)
	--self.group:seekLoc(x,y,0,t,mode)
	--self.sc:seekLoc(x,y,0,t,mode)
end