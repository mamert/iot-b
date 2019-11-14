
function sout(dataSource, mpuData)
	local d = {"AccelX", "AccelY", "AccelZ", "Temperature", "GyroX", "GyroY", "GyroZ"}
	d = d[dataSource+1]
	d = mpuData[d]
	print(tostring(d))
end
