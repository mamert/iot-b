-- to call:
-- > local fw = require "fw"
-- if need to unload: package.loaded.fw = nil

local FONT = {
	S = u8g.font_5x8r,
	M = u8g.font_7x14r, -- fw.FONT.M
	XL = u8g.font_gdb30r,
	L_DIGITS = u8g.font_gdb30r -- or u8g.font_freedoomr25n
}
		
local mymodule = {
	FONT = FONT
}

return mymodule



