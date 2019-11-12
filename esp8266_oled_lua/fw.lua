-- to call:
-- > local fw = require "fw"
-- if need to unload: package.loaded.fw = nil

local FONT = {
	S = u8g2.font_5x8_tr,
	M = u8g2.font_7x14B_tr, -- fw.FONT.M
	L_DIGITS = u8g2.font_logisoso30_tn
}
		
local mymodule = {
	FONT = FONT
}

return mymodule



