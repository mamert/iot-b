-- to call:
-- > local hw = require "hw"
-- if need to unload: package.loaded.hw = nil

local GPIO = {
	[16] = 0,
	[5] = 1,
	[4] = 2, -- 2 is GPIO4
	[0] = 3,
	[2] = 4, -- 4 is GPIO2
	[14] = 5,
	[12] = 6,
	[13] = 7,
	[15] = 8,
	[3] = 9,
	[1] = 10,
	[9] = 11,
	[10] = 12
}
		
local mymodule = {
	GPIO = GPIO,
	SDA = GPIO[14],
	SCL = GPIO[12],
	-- opt
	TRIG = GPIO[5],
	MODE = GPIO[0],
	PWR = GPIO[0],
	DOT_L = GPIO[4],
	DOT_H = GPIO[2],
}


return mymodule



