-- > local hw = require "hw"
-- if need to unload: package.loaded.hw = nil

local GPIO = {
	[16] = 0, -- PULLUP@boot, no PWM etc
	[5] = 1,
	[4] = 2, -- 2 is GPIO4
	[0] = 3, -- PULLUP@boot, DOWN for flashing
	[2] = 4, -- 4 is GPIO2
	[14] = 5,
	[12] = 6,
	[13] = 7,
	[15] = 8, -- PULLDOWN
	[3] = 9,
	[1] = 10,
	[9] = 11,
	[10] = 12
}
		
local mymodule = {
	GPIO = GPIO,
	MOTOR_PWM1 = GPIO[15], -- 8
	MOTOR_PWM2 = GPIO[13], -- 7 -- Fatal exception (28) if we use GPIO[2], -- 4. WHY?
	HX711_CLK = GPIO[4], -- 2
	HX711_DT = GPIO[5], -- 1
}
return mymodule
