for k,v in pairs(file.list()) do  print(k .. "\t" .. v)end -- print SOMETHING for ESPlorer's sake


tmr.create():alarm(1000, tmr.ALARM_SINGLE, function()
	dofile("main.lua")
end)
