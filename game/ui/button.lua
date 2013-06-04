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
end

function Button:registerEventHandler(event,handler)
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