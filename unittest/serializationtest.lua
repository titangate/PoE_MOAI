return function()
local obj = Serializable()


local function helpTestSerialize(obj)
	-- clear previous dump
	Serializable.clear()
	local dumpdata = obj:save()
	local obj_loaded = Serializable.load(dumpdata)
	assertSameObject(obj,obj_loaded)
end

-- basic test
helpTestSerialize(obj)

-- object that contains itself
obj.t = obj
helpTestSerialize(obj)
-- raw data test
obj.fun = "haha"
obj.int_test = 1
obj.float_test = 2.2345

helpTestSerialize(obj)

-- object that contains table
obj.t = {"yolobear","haha","dude you suck"}

helpTestSerialize(obj)
-- object that contains an object
local subObject = Serializable()
obj.t = subObject
helpTestSerialize(obj)

-- object chain
a = Serializable()
a.name = 'Adam'
b = Serializable()
b.name = 'Bob'
c = Serializable()
c.name = 'Cat'

a.next = b
b.next = c
c.next = a

helpTestSerialize(a)

-- I/O management
testfile = MOAIFileStream.new()
assert(testfile:open("serialization_testfile.lua",MOAIFileStream.READ_WRITE_NEW),
	"Fail to create test file")
Serializable.clear()
local dumpdata = a:save()
testfile:seek(0)
Serializable.dump(testfile)

testfile:seek(0)
Serializable.loadConf(testfile:read())
assertSameObject(Serializable.load(1),a)
assertSameObject(Serializable.load(2),b)
assertSameObject(Serializable.load(3),c)

end