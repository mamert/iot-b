-- to call:
-- > local mod_sonoff = require "mod_generic2"
-- > mod_generic2.init()
-- if need to unload: package.loaded.mod_generic2 = nil


function getRelayPins()
   return {
		["0"] = 7, -- 7 is GPIO13
		["1"] = 6 -- 6 is GPIO12
	}
end

return {
  getRelayPins = getRelayPins
}
