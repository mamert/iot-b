-- yellow header 16px 10 for font
-- blue: exactly 7 lines

local fw = require "fw"
local hw = require "hw"
local display = require "mod_display"
local wsled = require "mod_ws2812"
local mpu = require "mod_mpu6050"

function onMpuData(AccelX, AccelY, AccelZ, Temperature, GyroX, GyroY, GyroZ)
	print(string.format("Ax:%.3g Ay:%.3g Az:%.3g T:%.3g Gx:%.3g Gy:%.3g Gz:%.3g",
                        AccelX, AccelY, AccelZ, Temperature, GyroX, GyroY, GyroZ))
end

-- program

--to turn off WS Leds
gpio.mode(4, gpio.OUTPUT)
gpio.write(4, gpio.HIGH)

wifi.setmode(wifi.NULLMODE)

local i2c_id = 0
i2c.setup(i2c_id, hw.SDA, hw.SCL, i2c.FASTPLUS)
	
wsled.init()
wsled.show()
display.init(fw, i2c_id)
display.draw()
mpu.init(i2c_id)
mpu.setOndataCb(onMpuData)
mpu.cycle()
