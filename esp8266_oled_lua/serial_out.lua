
function sout(AccelX, AccelY, AccelZ, Temperature, GyroX, GyroY, GyroZ)
	--print(string.format("Ax:%s Ay:%s Az:%s T:%s Gx:%s Gy:%s Gz:%s",
	print(string.format("%s %s %s",
                        tostring(mpuData[dataSource == 0 and "AccelX" or "GyroX"]),
						tostring(mpuData[dataSource == 0 and "AccelY" or "GyroY"]),
						tostring(mpuData[dataSource == 0 and "AccelZ" or "GyroZ"])))
end
