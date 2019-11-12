-- yellow header 16px 10 for font
-- blue: exactly 7 lines

local fw = require "fw"
local hw = require "hw"
local display = require "mod_display"
local wsled = require "mod_ws2812"


-- program

--to turn off WS Leds
gpio.mode(4, gpio.OUTPUT)
gpio.write(4, gpio.HIGH)

wifi.setmode(wifi.NULLMODE)

local i2c_id = 0
i2c.setup(i2c_id, hw.SDA, hw.SCL, i2c.FASTPLUS)
	
wsled.init()
wsled.show()
display.init(fw, i2c_id)
display.draw()
