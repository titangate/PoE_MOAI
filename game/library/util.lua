
function assertSameObject(a,b)
	if (a==b) then return end
	assert(a and b,'object(s) is nil')
	local keys = {}
	for k,v in pairs(a) do
		keys[#keys+1] = k
	end
	for i,v in ipairs(keys) do
		local k = keys[i]
		assert(type(a[k]) == type(b[k]), string.format("%s[%s] = %s while %s[%s] = %s. ",
				tostring(a),tostring(k),tostring(a[k]),
				tostring(b),tostring(k),tostring(b[k])))
		if type(a[k]) == 'table' and k ~= 'class' then
			assertSameObject(a[k],b[k])
		else
			assert(a[k]==b[k],string.format("%s[%s] = %s while %s[%s] = %s. ",
				tostring(a),tostring(k),tostring(a[k]),
				tostring(b),tostring(k),tostring(b[k])))
		end
	end
end

function quadgetSize(q)
	return math.abs(q[3]-q[1]),math.abs(q[4]-q[2])
end

function ensureEntries(t,...)
	for i,v in ipairs(arg) do
		if t[v] then
			assert (type(t[v]) == 'table')
		else
			t[v] = {}
		end
		t = t[v]
	end
end

function magnitude(x1,y1)
	return (x1*x1+y1*y1)^.5
end

function distanceSquare(x1,y1,x2,y2)
	if x2 == nil then
		x2 = y1
		x1,y1 = unpack(x1)
		x2,y2 = unpack(x2)
	end
	return (x1-x2)^2+(y1-y2)^2
end

function findAveragePoint(t)
	local tx,ty = 0,0
	for i,v in ipairs(t) do
		local x,y = unpack(v)
		tx = tx + x
		ty = ty + y
	end
	return {tx/#t,ty/#t}
end

 
function standardQuad(w,h)
	return {-w/2,-h/2,w/2,h/2}
end
 
function R2D(r)
	return r*57.2957795
end