
function encodedVars()
	return cjson.encode(states)
end
function decodeVars(varString)
	if varString == nil then varString = '{"0":"1","1":"1"}' end
	states = cjson.decode(varString)
	for k,v in pairs(states) do
		setRelayState(k, v)
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
    file.open(fname,"r")
    decodeVars(file.read())
    file.close()
end


function initRelays()
	pins = {
		["0"] = 7, -- 7 is GPIO13
		["1"] = 6 -- 6 is GPIO12
	}
	states = {}
	for k,v in pairs(pins) do
		gpio.mode(v, gpio.OUTPUT)
	end
	restore_settings()
end


function setRelayState(no, isOn)
	states[no] = isOn and "1" or "0"
	gpio.write(pins[no], isOn and gpio.HIGH or gpio.LOW)
end

function serve(conn, payload)
	local _, _, method, path, vars = string.find(payload, "([A-Z]+) (.+)?(.+) HTTP")
	if(method == nil)then 
		_, _, method, path = string.find(payload, "([A-Z]+) (.+) HTTP")
	end
	local _GET = {}
	
	if (vars ~= nil) then 
		for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
			local pin = tostring(k)
			if(pin == nil) then
				_GET[k] = v
			else
				setRelayState(pin, tonumber(v) == 1)
			end
		end 
	end
	
	conn:send(encodedVars())
	
	conn:close()
	
	store_settings()
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
	
	
