
local PIN_M0_PWM_L = 1
local PIN_M0_PWM_R = 2



function getOtherCommands()
	return {
		["M0"] = function(x) controlMotor(PIN_M0_PWM_L, PIN_M0_PWM_R, x) end
	}
end


function controlMotor(pinL, pinR, state)
	local val = tonumber(state)
	if val < 0 then
		pwm.setduty(pinL,  0)
		pwm.setduty(pinR, -val)
	else
		pwm.setduty(pinL, val)
		pwm.setduty(pinR, 0)
	end
	return true
end

function init()
	gpio.mode(PIN_M0_PWM_L, gpio.OUTPUT)
	gpio.mode(PIN_M0_PWM_R, gpio.OUTPUT)
	pwm.setup(PIN_M0_PWM_L, 50, 0) -- 0~1000 Hz
	pwm.setup(PIN_M0_PWM_R, 50, 0)
	pwm.start(PIN_M0_PWM_L)
	pwm.start(PIN_M0_PWM_R)
end




return {
  init = init,
  getOtherCommands = getOtherCommands
}
