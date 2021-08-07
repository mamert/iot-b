-- yellow header 16px 10 for font
-- tmr.now is in microseconds
local fw = require "fw"
local hw = require "hw"
local display = require "mod_display"
--local mpu = require "mod_mpu6050"
local oledTmr = tmr.create()

local BTN_THROTTLE_PERIOD = 150000 -- microseconds
local btnLastClick = 0

local dataSource = 0
local DATA_SOURCE_MODES = 7

function cycleMode()
	dataSource = (dataSource+1)%DATA_SOURCE_MODES
end

function onBtnPressed()
	local now = tmr.now()
	local delta = now - btnLastClick
	if delta < 0 then delta = delta + 2147483647 end; -- timer.now() uint31 rollover, see http://www.esp8266.com/viewtopic.php?f=24&t=4833&start=5#p29127
	if delta > BTN_THROTTLE_PERIOD then
		cycleMode()
		btnLastClick = now
	end
end

-- program

--to turn off WS Leds
gpio.mode(hw.BTN, gpio.INT)
gpio.mode(hw.BTN,gpio.INT,gpio.PULLUP)
gpio.trig(hw.BTN,"down",onBtnPressed)

wifi.setmode(wifi.NULLMODE)

local i2c_id = 0
i2c.setup(i2c_id, hw.SDA, hw.SCL, i2c.FASTPLUS)
display.init(fw, i2c_id)
display.draw(0)

oledTmr:alarm(250, tmr.ALARM_SEMI, function()
    display.draw(tmr.now())
	oledTmr:start()
end)

print("main done")

