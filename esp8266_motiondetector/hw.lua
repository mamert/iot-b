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
	
	TRIGGER = GPIO[4], -- mislabeled on my ESP-07 as GPIO5
	PIEZO = GPIO[14],
	LED = GPIO[2],
}


return mymodule



