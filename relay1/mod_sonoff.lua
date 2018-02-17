-- to call:
-- > local mod_sonoff = require "mod_sonoff"
-- > mod_sonoff.init()
-- if need to unload: package.loaded.mod_sonoff = nil

local PIN_RELAY = 6
local PIN_LED = 7
local PIN_BUTTON = 3
local BTN_THROTTLE_PERIOD = 40000 -- microseconds
local btnLastClick = 0
local TIMER_LED_1 = 6 -- timers range 0-6
local TIMER_LED_2 = 5 -- TODO: use only 1
local LED_TICK = 2000 -- milliseconds
local LED_TICK_DUTY = 128 -- X/1024 of TIMER_LED_TIME_TICK that LED stays on. We're assuming no float support.

local relayToggler = nil
local relayPins = {
    ["sonoff"] = PIN_RELAY
}
function getRelays()
   return relayPins
end

function getOtherCommands()
	return {}
end

function init(relayToggleFunc)
	relayToggler = relayToggleFunc
	gpio.mode(PIN_LED, gpio.OUTPUT)
	gpio.mode(PIN_RELAY, gpio.OUTPUT)
	tmr.alarm(TIMER_LED_1, LED_TICK, tmr.ALARM_AUTO, function () -- timer turns LED on
		gpio.write(PIN_LED, gpio.LOW)
		tmr.alarm(TIMER_LED_2, LED_TICK*LED_TICK_DUTY/1024, tmr.ALARM_SINGLE, function () -- timer turns LED off
			gpio.write(PIN_LED, gpio.HIGH)
		end)
	end)
	prep_button()
end

function btnChanged()
	local b = gpio.read(PIN_BUTTON)
	local now = tmr.now()
	if b>0 then
		print("b="..gpio.read(PIN_BUTTON))
		local delta = now - btnLastClick
		if delta < 0 then delta = delta + 2147483647 end; -- timer.now() uint31 rollover, see http://www.esp8266.com/viewtopic.php?f=24&t=4833&start=5#p29127
		if delta > BTN_THROTTLE_PERIOD then
			relayToggler("sonoff")
		end;
	else
		btnLastClick = now
	end
end
function prep_button()
	gpio.mode(PIN_BUTTON,gpio.INT,gpio.PULLUP)
	gpio.trig(PIN_BUTTON,"both",btnChanged)
end

function setRelay(symbol, isOn)
	gpio.write(relayPins[symbol], isOn) -- gpio.LOW=0, gpio.HIGH=1
end




return {
  init = init,
  getRelays = getRelays,
  setRelay = setRelay,
  getOtherCommands = getOtherCommands
}
