-- to call:
-- > local mod_sonoff = require "mod_sonoff"
-- > mod_sonoff.init()
-- Yay for Hello world examples.
-- if need to unload: package.loaded.mod_sonoff = nil

local PIN_RELAY = 6
local PIN_LED = 7
local TIMER_LED_1 = 6 -- timers range 0-6
local TIMER_LED_2 = 5 -- TODO: use only 1
local LED_TICK = 1000 -- milliseconds
local LED_TICK_DUTY = 128 -- X/1024 of TIMER_LED_TIME_TICK that LED stays on. We're assuming no float support.


local mod_sonoff = {}

function mod_sonoff.init()
	gpio.mode(PIN_LED, gpio.OUTPUT)
	tmr.alarm(TIMER_LED_1, LED_TICK, tmr.ALARM_AUTO, function () -- timer turns LED on
		gpio.write(PIN_LED, gpio.LOW)
		tmr.alarm(TIMER_LED_2, LED_TICK*LED_TICK_DUTY/1024, tmr.ALARM_SINGLE, function () -- timer turns LED off
			gpio.write(PIN_LED, gpio.HIGH)
		end)
	end)
end

function mod_sonoff.relay(val)
	gpio.write(GPIO_SWITCH, val and gpio.HIGH or gpio.LOW)
end


return mod_sonoff