MyClass = Object:subclass'MyClass'
MyClass.eventListened = {
	hello = true,
	yolo = true,
	funk = true,
}

return function()
local a = MyClass()
a.name = 'A'
a:registerEventHandler('funk',function(obj,event)
		assert(obj == a)
		Logger.log('funked! %d',event.id)
	end)
a:pushNotification('funk',{id = 1234})

Notification.registerGlobalEventHandler('yolo',function(obj,event)
		Logger.log('YOLO! %d %s',event.id,obj.name)
	end)
a:pushNotification('yolo',{id = 4321})
local b = MyClass
b.name = 'B'
b:pushNotification('yolo',{id = 1111})
end