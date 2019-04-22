-- Scan for I2C devices

id=0 -- ALWAYS 0

function testAllAddresses(sda,scl)
	i2c.setup(id,sda,scl,i2c.SLOW)
	local found = false
	for i=0,127 do
		i2c.start(id)
		resCode = i2c.address(id, i, i2c.TRANSMITTER)
		i2c.stop(id)
		if resCode == true then
			print("We have a device on address 0x" .. string.format("%02x", i) .. " (" .. i .."), sda="..sda..", scl="..scl)
			found = true
		end
	end
	return found
end

function testAllPins(possiblePins)
	local found=false
	for i, sda in ipairs(possiblePins) do
		for j, scl in ipairs(possiblePins) do
			if (sda ~= scl) then
				found = testAllAddresses(sda,scl) or found
			end
		end
	end
	return found
end


found = testAllPins({3,4,2,1,6,7,5}) -- these are the only ones that might work on ESP8266. Others crash.
if(not found) then print("Nothing found") end

