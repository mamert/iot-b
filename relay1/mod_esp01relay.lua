
local PIN_RELAY = 3
local PIN_BUTTON = 3
local BTN_THROTTLE_PERIOD = 40000 -- microseconds
local btnLastClick = 0

local relayPins = {
    ["relay"] = PIN_RELAY
}
function getRelays()
   return relayPins
end

function init(relayToggleFunc)
	gpio.mode(PIN_RELAY, gpio.OUTPUT)
end


function setRelay(symbol, isOn)
	gpio.write(relayPins[symbol], isOn) -- gpio.LOW=0, gpio.HIGH=1
end




return {
  init = init,
  getRelays = getRelays,
  setRelay = setRelay
}
