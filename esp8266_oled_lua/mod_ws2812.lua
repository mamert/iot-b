local _buf

local function init()
	ws2812.init()
	_buf = ws2812.newBuffer(6, 3)
	ws2812_effects.init(_buf)
	--ws2812_effects.set_speed(20) -- what?
	ws2812_effects.set_delay(200) -- min 10
	ws2812_effects.set_brightness(16)
end


local function show()
	ws2812_effects.set_mode("rainbow_cycle")
	ws2812_effects.start()
	--ws2812.write(string.char(32, 0, 0, 64, 0, 32, 0, 64, 0, 0, 32, 64, 16, 16, 0, 64, 0, 16, 16, 64, 16, 0, 16, 64))
end



local mymodule = {
	init = init,
	show = show
}
return mymodule



