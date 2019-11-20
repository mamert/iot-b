dofile("util.lua")
dofile("val_stats.lua")
local hw = require "hw"
local mpuTmr = tmr.create()

local DEADZONE_R = 200000
local VAL_NOLOAD = 157000
local VAL_MIN = VAL_NOLOAD
local VAL_MAX = 1390000
local VAL_CENTER = VAL_NOLOAD + (VAL_MAX - VAL_MIN) / 2
local VAL_RADIUS = VAL_CENTER - VAL_MIN - DEADZONE_R
local MOTOR_MIN_PWM = 150 -- least value that results in motion at the chosen PWM frequency
local MOTOR_MAX_PWM = 950

data = Stats:new()

function moveMotorByAxis(data)
	v = data.val - VAL_CENTER
	local isDown = v < 0
	v = math.abs(v)
	v = v-DEADZONE_R
	if v > 0 then
		v = math.max(0, v)
		-- curve it
		v = v/VAL_RADIUS -- 0-1 range
		v = v*v -- square, so low values are easier to select
		v = v*VAL_RADIUS
		v = map(v, 0,VAL_RADIUS, MOTOR_MIN_PWM,MOTOR_MAX_PWM)
	else
		v = 0
	end
	local zeroPin = isDown and hw.MOTOR_PWM1 or hw.MOTOR_PWM2
	local valPin = isDown and hw.MOTOR_PWM2 or hw.MOTOR_PWM1
	pwm.setduty(zeroPin, 0)
	pwm.setduty(valPin, v)
	print(string.format("%.3g %.3s", v, tostring(isDown)))
end

function onTick()
	data:update(hx711.read())
	-- TODO: hardware: RATE pin pullup not pulldown, for 80Hz rather than 10
	print(tostring(data))
	moveMotorByAxis(data)
	mpuTmr:start() -- since ALARM_SEMI
end


-- program

wifi.setmode(wifi.NULLMODE)

pwm.setup(hw.MOTOR_PWM1, 222, 0)
pwm.setup(hw.MOTOR_PWM2, 222, 0)
pwm.start(hw.MOTOR_PWM1)
pwm.start(hw.MOTOR_PWM2)

hx711.init(hw.HX711_CLK, hw.HX711_DT)
--for i=1,4 do -- to stabilize filters
--	data:update(hx711.read())
--end

mpuTmr:alarm(20, tmr.ALARM_SEMI, onTick)
