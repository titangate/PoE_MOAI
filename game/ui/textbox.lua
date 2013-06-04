TextBox = Widget:subclass'TextBox'

function TextBox:load(parent)
	Widget.load(self,parent)
	self.text = TextBoxActor()
	self.text.quad = standardQuad(self.w,self.h)
	self.text.style = self:getStyle().text
	self.text:load()
	self:addActor(self.text)
	local style = self:getStyle().editButton
	self.editButton = Button()
	self.editButton.w,self.editButton.h = style.w,style.h
	self.editButton.x = self.w/2 - style.w/2
	self.editButton.y = 0
	self.editButton:load(self)
	self.editButton:setBackgroundImage(style.img)
	self:addActor(self.editButton)
end

function TextBox:setTitle(title)
	self.text:setString(title)
end

function TextBox:setBorderStyle(style)
	Widget.setBorderStyle(self,style)
end

function TextBox:registerEventHandler(event,handler)
	if event == 'Click' then
		if POE_CONTROLSCHEME == 'mobile' and self._tapGestureRecognizer == nil then
			local tg = TapGestureRecognizer()
			self:addGestureRecognizer(tg)
			tg.registerEventHandler(tg,'GestureFinished',function()
				self:pushNotification('Click')
			end)
			self._tapGestureRecognizer = tg
		end
	end
	Widget.registerEventHandler(self,event,handler)
end