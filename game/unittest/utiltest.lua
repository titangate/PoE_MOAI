require 'library.util'
return function()

local a,b

a = {1,2,3,4}
b = {1,2,3,4}
assertSameObject(a,b)

a = {1,'hello',2.2345}
b = {1,'hello',2.2345}
assertSameObject(a,b)

b = a
assertSameObject(a,b)

a = {1,'hello',{2,'world'}}
b = {1,'hello',{2,'world'}}
assertSameObject(a,b)

end