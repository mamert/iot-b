
function encodedVars()
	return cjson.encode(states)
end
function decodeVars(varString)
	local isReset = states == nil
	states = cjson.decode(varString)
	for k,v in pairs(states) do
		if tonumber(k)~=nil then
			setRelayState(k, tonumber(v))
		end
	end
	if isReset then
		states["resets"] = states["resets"]+1
		store_settings()
	end
end

function store_settings()
	local fname = "settings.txt"
    file.remove(fname)
    file.open(fname,"w+")
    file.write(encodedVars())
    file.close()
end
function restore_settings()
	local fname = "settings.txt"
	local varString = '{"0":"1","1":"1","resets":"0"}'
	if file.open(fname,"r")~=nil then
		varString=file.read()
		file.close()
	end
	decodeVars(varString)
end


function initRelays()
	pins = {
		["0"] = 7, -- 7 is GPIO13
		["1"] = 6 -- 6 is GPIO12
	}
	for k,v in pairs(pins) do
		gpio.mode(v, gpio.OUTPUT)
	end
	restore_settings()
end


function setRelayState(no, isOn)
	states[no] = isOn
	gpio.write(pins[no], isOn) -- LOW=0, HIGH=1
end

function serve(conn, payload)
	local _, _, method, path, vars = string.find(payload, "([A-Z]+) (.+)?(.+) HTTP")
	if(method == nil)then 
		_, _, method, path = string.find(payload, "([A-Z]+) (.+) HTTP")
	end
	local _GET = {}
	local settingsChanged = false
	
	if (vars ~= nil) then 
		for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
			local pin = tostring(k)
			if(pin == nil) then
				_GET[k] = v
			else
				setRelayState(pin, tonumber(v))
				settingsChanged = true
			end
		end 
	end
	
	conn:send(encodedVars())
	conn:close()
	
	if(settingsChanged) then store_settings() end
end



------------begin--------------

initRelays()


-- and run server
srv=net.createServer(net.TCP) 
srv:listen(80, function(conn) 
	conn:on("receive",function(conn,payload)
		serve(conn, payload)
		collectgarbage()
	end) 
end)
	
	
