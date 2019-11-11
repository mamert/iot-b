-- yellow header 16px 10 for font
-- blue: exactly 7 lines

local fw = require "fw"
local hw = require "hw"
local display = require "mod_display"


-- program

wifi.setmode(wifi.NULLMODE)

display.init(hw,fw)
display.draw()
