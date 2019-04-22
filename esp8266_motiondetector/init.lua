
print("Giving 5s to recover if program crashes on boot")
tmr.create():alarm(5000, tmr.ALARM_SINGLE, function() dofile("main.lua") end)
