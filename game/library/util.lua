
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