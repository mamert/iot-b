
local PIN_M0EN = 1 -- GPIO5
local PIN_M0A = 2 -- GPIO4
local PIN_M0B = 0 -- GPIO16, no PWM!
local PIN_M1A = 5 -- GPIO14
local PIN_M1B = 6 -- GPIO12
local PIN_M1EN = 7 -- GPIO13


function getOtherCommands()
	return {
		["M0"] = function(x) controlMotor(PIN_M0A, PIN_M0B, x) end,
		["M1"] = function(x) controlMotor(PIN_M1A, PIN_M1B, x) end,
		["DUTY0"] = function(x) pwm.setduty(PIN_M0EN, x) end,
		["DUTY1"] = function(x) pwm.setduty(PIN_M1EN, x) end
	}
end

local motorStates = { -- TODO: PWM EN pins
   ["F"] = function(pinA, pinB) gpio.write(pinA, gpio.LOW) gpio.write(pinB, gpio.HIGH) end,
   ["R"] = function(pinA, pinB) gpio.write(pinB, gpio.LOW) gpio.write(pinA, gpio.HIGH) end,
   ["S"] = function(pinA, pinB) gpio.write(pinA, gpio.LOW) gpio.write(pinB, gpio.LOW) end
}


function controlMotor(pinA, pinB, state)
	local func=(motorStates[state])
	if func~=nil then
		func(pinA, pinB)
		return true
	end
end

function init()
	gpio.mode(PIN_M0EN, gpio.OUTPUT)
	gpio.mode(PIN_M0A, gpio.OUTPUT)
	gpio.mode(PIN_M0B, gpio.OUTPUT)
	gpio.mode(PIN_M1A, gpio.OUTPUT)
	gpio.mode(PIN_M1B, gpio.OUTPUT)
	gpio.mode(PIN_M1EN, gpio.OUTPUT)
	gpio.write(PIN_M0EN, gpio.HIGH)
	gpio.write(PIN_M1EN, gpio.HIGH)
	pwm.setup(PIN_M0EN, 500, 1023) -- 0~1023
	pwm.setup(PIN_M1EN, 500, 1023)
	pwm.start(PIN_M0EN)
	pwm.start(PIN_M1EN)
end




return {
  init = init,
  getOtherCommands = getOtherCommands
}
