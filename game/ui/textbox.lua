TextBox = Button:subclass'TextBox'

function TextBox:load(parent)
	Button.load(self,parent)	
	local style = self:getStyle().editButton
	self.editButton = Button()
	self.editButton.w,self.editButton.h = style.w,style.h
	self.editButton.x = self.w/2 - style.w/2
	self.editButton.y = 0
	self.editButton:load(self)
	self.editButton:setBackgroundImage(style.img)
	self:addActor(self.editButton)
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
	Button.registerEventHandler(self,event,handler)
end