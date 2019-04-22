
print("Giving 3s to recover if program crashes on boot")
tmr.create():alarm(3000, tmr.ALARM_SINGLE, function() dofile("mine.lua") end)
