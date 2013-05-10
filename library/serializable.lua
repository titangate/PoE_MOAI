Serializable = Object:subclass'Serializable'

local ser = Serializable

local function getIDForObject(obj)
	if (ser._objectToId[obj] == nil) then
		ser._objectToId[obj] = ser._idToSave.objectCount
		ser._idToObject[ser._idToSave.objectCount] = obj
		ser._idToSave.objectCount = ser._idToSave.objectCount + 1
	end
	return ser._objectToId[obj]
end

local function getObjectWithID(id)
	if (ser._idToObject[id] == nil) then
		if ser._idToSave[id] then
			ser._idToObject[id] = ser.load(ser._idToSave[id])
		end
	end
	return ser._idToObject[id]
end

local function deregisterObject(obj)
	local id
	if type(obj) == 'number' then
		id = obj
		obj = getObjectWithID(id)
	else
		id = getIDForObject(obj)
	end
	ser._objectToId[obj] = nil
	ser._idToSave[id] = nil
	ser._idToObject[id] = nil
end

local function loadSerizalizationTable(path)
	local t = path
end

local function saveSerizalizationTable(t)
	t = t or ser._idToSave
	local head = '{\n'
	for k,v in pairs(t)
		do
		if type(k) == 'string' then
			k = '[['..k..']]'
		end

		if type(v) == 'function' then
			head = head .. "[ ".. k .. " ] = function() return "..v().. " end, \n"
		elseif type(v) == 'string' then
			head = head .. "[ ".. k .. " ] = [[" ..v.. ']], \n'
		elseif type(v) == 'table' then
			head = head.. "[ ".. k .. " ] = " .. saveSerizalizationTable(v)
		else
			head = head .. "[ ".. k .. " ] = " .. tostring(v) .. ', \n'
		end
	end

	head = head .. '},\n'
	return head
end

local function saveTable(t)
	local selfid = getIDForObject(t)
	if (ser._idToSave[selfid]) then
		return ser._idToSave[selfid], selfid -- mark the table so it wont try to serialize itself repeatedly
	end
	ser._idToSave[selfid] = true
	local head = {}
		for k,v in pairs(t) do
		if k=='class' then -- TODO: add test for non-sers
			head.class = v.name
		elseif type(v)=='table' then
			local data, id
			if instanceOf(v,ser) then
				data, id = v:save()
			else
				data, id = saveTable(v)
			end
			ser._idToSave[id] = data
			head[k] = function() return id end
		else
			head[k] = v
		end
	
	end
	return head,getIDForObject(t)
end

local function loadTable(data,obj)
	local t = data
	assert(t,"Error loading serialized table")
	if t.class then
		assert(_G[t.class],t.class.." does not exist")
		obj = _G[t.class] () -- create a object of given class
	else
		obj = {}
	end
	t.class = nil
	for k,v in pairs(t) do
		if type(v) == 'function' then
			obj[k] = getObjectWithID(v())
		else
			obj[k] = v
		end
	end
	
	return obj
end

function ser:save() -- return a string that represents this object
	local data,id = saveTable(self)
	self._idToSave[id] = data
	return data,id
end

function ser:saveToFile(path)
end

function ser._loadFromFile(path)
end

function ser.clear()
	ser._objectToId = {}
	ser._idToObject = {}
	ser._idToSave = {}
	ser._idToSave.objectCount = 1
end

function ser.dump(stream)
	stream:write("return "..saveSerizalizationTable()..'1')
end

function ser.loadObject(data) -- load a object with the given string
	-- determine wether data is a path or a serialized object
	return loadTable(data)
end

function ser.load(t)
	if type(t) == 'number' then
		assert(ser._idToSave[t])
		t = ser._idToSave[t]
	end
	return loadTable(t)
end

function ser.loadConf(t)
	local s = loadTable(loadstring(t)())
	assert(s,'Error loading table')
	ser._idToSave = s
end

function ser:_print()
	for k,v in pairs(self) do
		print (k,v)
	end
end 

ser.clear()