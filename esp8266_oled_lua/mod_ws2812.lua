local _buf

local function init()
	ws2812.init()
	_buf = ws2812.newBuffer(6, 3) --GRB
end

local function getColor(val)
	ret = {}
	ret[1] = math.max(0,val)
	ret[2] = math.max(0,-val)
	ret[3] = math.abs(val)>255 and 128 or 0
	return ret
end

local function show(dataSource, mpuData)
	local s = {"AccelX", "AccelY", "AccelZ", "Temperature", "GyroX", "GyroY", "GyroZ"}
	s = s[dataSource+1]
	local d = {"AccelX", "AccelY", "AccelZ", "GyroX", "GyroY", "GyroZ"}
	for i = 1,6 do
		x = d[i]
		local val = x==s and mpuData[x].val or 0
		_buf:set(i,getColor(val))
	end
	ws2812.write(_buf)
end



local mymodule = {
	init = init,
	show = show
}
return mymodule



