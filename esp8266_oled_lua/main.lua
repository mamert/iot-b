-- yellow header 16px 10 for font
-- blue: exactly 7 lines

local fw = require "fw"
local hw = require "hw"
local display = require "mod_display"
local wsled = require "mod_ws2812"


-- program

wifi.setmode(wifi.NULLMODE)

wsled.init()
wsled.show()
display.init(hw,fw)
display.draw()
