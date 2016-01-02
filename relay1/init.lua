

function encodedVars()
	temp = {} --TODO: keep them there to begin with
	for k,v in pairs(pins) do
		temp[k] = (pinStates[v])
	end
	return cjson.encode(temp)
end
function decodeVars(varString)
	if varString == nil then varString = '{"0":"1","1":"1"}' end
	temp = cjson.decode(varString)
	for k,v in pairs(pins) do
		setRelayState(v, temp[k])
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



function setUpNet()
	wifi.setmode(wifi.STATIONAP)
	local apCfg={
		ssid="kaay's Relay",
		pwd="12345678",
		auth=AUTH_WPA2_PSK,
		channel=11,
		hidden=0,
		beacon=800
	}
	wifi.ap.config(apCfg)
	local apIpCfg={
		ip="192.168.64.1",
		netmask="255.255.255.0",
		gateway="192.168.64.1"
	}
	wifi.ap.setip(apIpCfg)
	
	wifi.sta.config(wifiSSID, wifiPass)
	tmr.alarm(0, 5000,0,function() print(wifi.sta.getip()) end)
end


function initRelays()
	pins = {
		["0"] = 7, -- 7 is GPIO13
		["1"] = 6 -- 6 is GPIO12
	}
	pinStates = {}
	for k,v in pairs(pins) do
		gpio.mode(v, gpio.OUTPUT)
	end
	restore_settings()
end


function setRelayState(pin, isOn)
	pinStates[pin] = isOn and "1" or "0"
	gpio.write(pin, isOn and gpio.HIGH or gpio.LOW)
end


selectedString = " selected"

function printRelayForms(conn)
	temp = {}
	for k,v in pairs(pins) do
		temp[k] = (pinStates[v])
	end
	conn:send(encodedVars())
end


function serve(conn, payload)
	local _, _, method, path, vars = string.find(payload, "([A-Z]+) (.+)?(.+) HTTP")
	if(method == nil)then 
		_, _, method, path = string.find(payload, "([A-Z]+) (.+) HTTP")
	end
	local _GET = {}
	
	if (vars ~= nil) then 
		for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
			local pin = (pins[tostring(k)])
			if(pin == nil) then
				_GET[k] = v
			else
				setRelayState(pin, tonumber(v) == 1)
			end
		end 
	end
	
	printRelayForms(conn)
	
	conn:close()
	
	store_settings()
end



------------begin--------------

dofile("consts.lua")

initRelays()
setUpNet()


-- and run server
srv=net.createServer(net.TCP) 
srv:listen(80, function(conn) 
	conn:on("receive",function(conn,payload)
		serve(conn, payload)
		collectgarbage()
	end) 
end)
	
	
