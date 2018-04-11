
local PIN_M0_PWM = 1
local PIN_M0_DIR = 3
local PIN_M1_PWM = 2
local PIN_M1_DIR = 4



function getOtherCommands()
	return {
		["M0"] = function(x) controlMotor(PIN_M0_DIR, PIN_M0_PWM, x) end,
		["M1"] = function(x) controlMotor(PIN_M1_DIR, PIN_M1_PWM, x) end
	}
end


function controlMotor(pinDir, pinPwm, state)
	local val = tonumber(state)
	print("state="..state.."; val="..val)
	local dir = gpio.HIGH
	if val < 0 then
		dir = gpio.LOW
		val = -val
	end
    gpio.write(pinDir, dir)
    pwm.setduty(pinPwm, val) -- 0~1023
	return true
end

function init()
	gpio.mode(PIN_M0_PWM, gpio.OUTPUT)
	gpio.mode(PIN_M0_DIR, gpio.OUTPUT)
	gpio.mode(PIN_M1_PWM, gpio.OUTPUT)
	gpio.mode(PIN_M1_DIR, gpio.OUTPUT)
	pwm.setup(PIN_M0_PWM, 50, 0) -- 0~1023
	pwm.setup(PIN_M1_PWM, 50, 0)
	pwm.start(PIN_M0_PWM)
	pwm.start(PIN_M1_PWM)
end




return {
  init = init,
  getOtherCommands = getOtherCommands
}
