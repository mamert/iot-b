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
	SDA = GPIO[12],--12 / 4
	SCL = GPIO[14] --14 / 5
}


return mymodule



