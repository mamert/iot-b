-- yellow header 16px 10 for font
-- blue: exactly 7 lines
dofile("util.lua")
dofile("val_stats.lua")
local fw = require "fw"
local hw = require "hw"
local display = require "mod_display"
local wsled = require "mod_ws2812"
local mpu = require "mod_mpu6050"
local mpuTmr = tmr.create()

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
	print(string.format("Ax:%s Ay:%s Az:%s T:%s Gx:%s Gy:%s Gz:%s",
                        tostring(mpuData["AccelX"]),
						tostring(mpuData["AccelY"]),
						tostring(mpuData["AccelZ"]),
						tostring(mpuData["Temperature"]),
						tostring(mpuData["GyroX"]),
						tostring(mpuData["GyroY"]),
						tostring(mpuData["GyroZ"])))
	mpuTmr:start() -- since ALARM_SEMI
end

-- program

--to turn off WS Leds
gpio.mode(4, gpio.OUTPUT)
gpio.write(4, gpio.HIGH)

wifi.setmode(wifi.NULLMODE)

local i2c_id = 0
i2c.setup(i2c_id, hw.SDA, hw.SCL, i2c.FASTPLUS)
	
wsled.init()
display.init(fw, i2c_id)
display.draw()
mpu.init(i2c_id)
mpu.setOndataCb(onMpuData)

mpuTmr:alarm(50, tmr.ALARM_SEMI, mpu.cycle)

