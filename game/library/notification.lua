Notification = Object:subclass'Notification'

Notification._handlers = {}
-- global observer
function Notification.registerGlobalEventHandler(event,handler)
	local N = Notification._handlers
	if not N[event] then
		N[event] = {} --createWeakReferencedTable('k')
	end
	N[event][handler] = true
end

function Notification.deregisterGlobalEventHandler(event,handler)
	local N = Notification._handlers
	if not N[event] then return end
	if handler then
		N[event][handler] = nil
	else
		N[event] = nil
	end
end

-- local observer
function Object:registerEventHandler(event,handler)
	ensureEntries(self,'_handlers')
	local N = self._handlers
	if not N[event] then
		N[event] = {} --reateWeakReferencedTable('k')
	end
	N[event][handler] = true
	warning(self.class.eventListened,'No event list defined for this object')
	if self.class.eventListened then
		warning(self.class.eventListened[event],'%s not listened by this object',event)
	end
end

function Object:deregisterEventHandler(event,handler)
	local N = self._handlers
	if not N or not N[event] then return end
	if handler then
		N[event][handler] = nil
	else
		N[event] = nil
	end
end

function Notification._getAllHandlers(event,object)
	object = object or nil
	coroutine.wrap(function()
			for i,v in ipairs(table_name) do
				print(i,v)
			end
		end)
end

-- send notification API
function Object:pushNotification(event,eventmeta)
	local t = {Notification._handlers,self._handlers}
	for _,N in ipairs(t) do
		if N and N[event] then
			for handler,_ in pairs(N[event]) do
				handler(self,eventmeta)
			end
		end
	end
end
