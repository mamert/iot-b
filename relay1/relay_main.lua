
-- commands the device can repond to
proc = {
   ["zero"] = function(x) states["resets"]=0 end,
   ["lua"] = function(txt) node.input(txt) end
}
availableRelays = {}
states = {}

function initRelays()
	availableRelays = {}
	local mod_sonoff = require "mod_sonoff" -- unload with package.loaded.mod_sonoff = nil
	--local mod_relay2 = require "mod_generic2"
	mod_sonoff.init(relayToggle)
	for k, v in pairs(mod_sonoff.getRelays()) do
		table.insert(availableRelays, k)
		proc[k] = function(x) 
			print('0 setRelayState k='..(k and k or nil))
			print('0 setRelayState x='..(x and x or 'nil'))
			setRelayState(mod_sonoff, k, x)
		end
	local mod_relay = require "mod_motor_l293d"
	mod_relay.init()
	for k, v in pairs(mod_relay.getOtherCommands()) do
		proc[k] = v
	end
	
	--local mod_relay = require "mod_motors"
	--mod_relay.init()
	--for k, v in pairs(mod_relay.getOtherCommands()) do
	--	proc[k] = v
	--end
	
	restore_settings()
end

function relayToggle(symbol)
	callProc(symbol, (states[symbol]+1)%2)
end

function callProc(symbol, value)
	local func=(proc[symbol])
	if func~=nil then
		func(value)
		return true
	end
	return false
end

function setRelayState(relayMod, symbol, isOn)
	symbol = tostring(symbol)
	isOn = tonumber(isOn)
	states[symbol] = isOn
	print('1 setRelayState symbol='..(symbol and symbol or nil))
	print('1 setRelayState isOn='..(isOn and isOn or 'nil'))
	relayMod.setRelay(symbol, isOn)
end

function store_settings()
	--local fname = "settings.txt"
    --file.remove(fname)
    --file.open(fname,"w+")
    --file.write(encodedVars())
    --file.close()
end
function restore_settings()
	local fname = "settings.txt"
	local varString = nil
	--if file.open(fname,"r")~=nil then
	--	varString=file.read()
	--	file.close()
	--end
	decodeVars(varString)
end

function encodedVars()
	return cjson.encode(states)
end
function decodeVars(varString)
	if varString == nil then
		states = {}
		for k, v in ipairs(availableRelays) do
			states[v] = 0
		end
		states["resets"] = 0
	else 
		states = cjson.decode(varString)
	end
	
	for k,v in pairs(states) do
		if tonumber(k)~=nil then
			callProc(k, v)
		end
	end
	local isReset = states == nil
	if isReset then
		states["resets"] = states["resets"]+1
		store_settings()
	end
end





function serve(conn, payload)
	local _, _, method, path, vars = string.find(payload, "([A-Z]+) (.+)?(.+) HTTP")
	if method == nil then
		_, _, method, path = string.find(payload, "([A-Z]+) (.+) HTTP")
	end
	local settingsChanged = false
	
	if vars ~= nil then 
		print(vars..'\n')	
		for k, v in string.gmatch(vars, "(%w+)=([%w-.]+)&*") do
			if callProc(k,v) then
				settingsChanged = true
			end
		end
	end
	
	conn:send(encodedVars())
	conn:close()
	
	if settingsChanged then
		store_settings()
		settingsChanged=false
	end
end



------------begin--------------

print('init\n')
initRelays()

print('init\'d\n')
-- and run server
srv=net.createServer(net.TCP)
srv:listen(80, function(conn)
	conn:on("receive",function(conn,payload)
		serve(conn, payload)
		collectgarbage()
	end) 
end)

print('server started\n')

	
