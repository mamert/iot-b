
function init_OLED(sda,scl)
	sla = 0x3c
	i2c.setup(0, sda, scl, i2c.SLOW)
	disp = u8g.ssd1306_128x64_i2c(sla)
	disp:setDefaultForegroundColor()
end


relayIP = "192.168.1.33"
relayVals = {["0"]="0", ["1"]="0"}
selectedRelay=0
function readRelayResponse(jsonString)
	if jsonString ~= nil then
		relayVals = cjson.decode(jsonString)
	end
	dofile("display.lua")
end



function toggleRelay()
	conn=net.createConnection(net.TCP, 0)
	conn:on("receive", function(conn, payload)
			readRelayResponse(payload)
			conn:close()
		end)
	
	conn:on("connection", function(conn, payload)
			local tstr = ""
			for k,v in pairs(relayVals) do
				tstr = tstr..k.."="
				if(tonumber(k) == selectedRelay) then
					tstr = tstr..(tonumber(v)+1)%2
				else
					tstr = tstr..v
				end
				tstr = tstr.."&"
			end
			conn:send("GET /?"..tstr.." HTTP/1.1\r\n".. 
						"Host: \r\n"..
						"Accept: */*\r\n"..
						"User-Agent: Mozilla/4.0 (compatible;)"..
						"\r\n\r\n") 
		end)
	conn:connect(80,'192.168.1.33')
end



button1Pin = 1
function pressed1()
	tmr.delay(10)                   
	gpio.trig(button1Pin,"up",released1)
end
function released1()
	tmr.delay(10)
	gpio.trig(button1Pin,"down",pressed1)
	toggleRelay()
end
function prep_buttonFLASH()
	gpio.mode(button1Pin,gpio.INT,gpio.PULLUP)
	gpio.trig(button1Pin,"down",pressed1)
end

button2Pin = 3
function pressed2()
	tmr.delay(10)                   
	gpio.trig(button2Pin,"up",released2)
end
function released2()
	tmr.delay(10)
	gpio.trig(button2Pin,"down",pressed2)
	selectedRelay = (selectedRelay+1)%2
	dofile("display.lua")
end
function prep_button2()
	gpio.mode(button2Pin,gpio.INT,gpio.PULLUP)
	gpio.trig(button2Pin,"down",pressed2)
end






-- program
init_OLED(7,6)
prep_buttonFLASH()
prep_button2()
