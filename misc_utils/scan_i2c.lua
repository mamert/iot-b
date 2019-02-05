-- based on http://www.esp8266.com/viewtopic.php?f=19&t=771
-- Scan for I2C devices

id=0 -- ALWAYS 0

function testAllAddresses()
	local found = false
	for i=0,127 do
		i2c.start(id)
		resCode = i2c.address(id, i, i2c.TRANSMITTER)
		i2c.stop(id)
		if resCode == true then
			print("We have a device on address 0x" .. string.format("%02x", i) .. " (" .. i ..")")
			found = true
		end
	end
	if(not found) then print("Nothing found") end
end


sda=2
scl=4

i2c.setup(id,sda,scl,i2c.SLOW)
testAllAddresses()

