-- yellow header 16px 10 for font
-- blue: exactly 7 lines
dofile("util.lua")
dofile("val_stats.lua")
dofile("serial_out.lua")
local fw = require "fw"
local hw = require "hw"
local display = require "mod_display"
local wsled = require "mod_ws2812"
local mpu = require "mod_mpu6050"
local mpuTmr = tmr.create()

local BTN_THROTTLE_PERIOD = 60000 -- microseconds
local btnLastClick = 0

local dataSource = 0

mpuData = {AccelX=Stats:new(), AccelY=Stats:new(), AccelZ=Stats:new(), Temperature=Stats:new(), GyroX=Stats:new(), GyroY=Stats:new(), GyroZ=Stats:new()}

function onMpuData(AccelX, AccelY, AccelZ, Temperature, GyroX, GyroY, GyroZ)
	mpuData["AccelX"]:update(AccelX)
	mpuData["AccelY"]:update(AccelY)
	mpuData["AccelZ"]:update(AccelZ)
	mpuData["Temperature"]:update(Temperature)
	mpuData["GyroX"]:update(GyroX)
	mpuData["GyroY"]:update(GyroY)
	mpuData["GyroZ"]:update(GyroZ)
	
	wsled.show(AccelX, AccelY, AccelZ, GyroX, GyroY, GyroZ)
	sout(AccelX, AccelY, AccelZ, Temperature, GyroX, GyroY, GyroZ)
						
	mpuTmr:start() -- since ALARM_SEMI
end

function onBtnPressed()
	local now = tmr.now()
	local delta = now - btnLastClick
	if delta < 0 then delta = delta + 2147483647 end; -- timer.now() uint31 rollover, see http://www.esp8266.com/viewtopic.php?f=24&t=4833&start=5#p29127
	if delta > BTN_THROTTLE_PERIOD then
		dataSource = (dataSource+1)%2
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
	
wsled.init()
display.init(fw, i2c_id)
display.draw()
mpu.init(i2c_id)
mpu.setOndataCb(onMpuData)

mpuTmr:alarm(50, tmr.ALARM_SEMI, mpu.cycle)

