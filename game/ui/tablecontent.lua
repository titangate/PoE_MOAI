TableContent = Widget:subclass'TableContent'

function TableContent:load(parent)
	self.sc = MOAIScissorRect.new()
	self.sc:setRect(-self.w/2,-self.h/2,self.w/2,self.h/2)
	Widget.load(self,parent)
end

function TableContent:setPosition(x,y,t,mode)
	Widget.setPosition(self,x,y,t,mode)
end

function TableContent:enablePreRender(...)
	Widget.enablePreRender(self,...)
	self._preRendered:getProp():setScissorRect(self.sc)
	self.sc:setAttrLink(MOAIProp.INHERIT_TRANSFORM, self.parent.group, MOAIProp.TRANSFORM_TRAIT)
end

function TableContent:setBorderStyle(style)
	Widget.setBorderStyle(self,style)
end

function TableContent:setContentOffset(x,y,t,mode)
	self:enablePreRender(true)
	self.group:seekLoc(x,y,0,t,mode)
end