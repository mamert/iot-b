-- to call:
-- > local hw = require "hw"
-- if need to unload: package.loaded.hw = nil

local GPIO = { -- 2-7 work with everything
	[16] = 0, -- only read/write, nothing else. Also used for flashing.
	[5] = 1,
	[4] = 2, -- 2 is GPIO4
	[0] = 3,
	[2] = 4, -- 4 is GPIO2
	[14] = 5,
	[12] = 6,
	[13] = 7,
	[15] = 8,
	[3] = 9, --RXD0
	[1] = 10, --TXD0
	[9] = 11, --SD2
	[10] = 12, --SD3
}
		
local mymodule = {
	GPIO = GPIO,
	SDA = GPIO[14],
	SCL = GPIO[12],
	-- opt
	SPEAKER = GPIO[5],
	BUTTON = GPIO[13],
	TRIGGER = GPIO[13],
}


return mymodule



