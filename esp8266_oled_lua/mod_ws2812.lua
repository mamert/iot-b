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

local function show(AccelX, AccelY, AccelZ, GyroX, GyroY, GyroZ)
	_buf:set(1,getColor(AccelX))
	_buf:set(2,getColor(AccelY))
	_buf:set(3,getColor(AccelZ))
	_buf:set(4,getColor(GyroX))
	_buf:set(5,getColor(GyroY))
	_buf:set(6,getColor(GyroZ))
	ws2812.write(_buf)
end



local mymodule = {
	init = init,
	show = show
}
return mymodule



