local hw = require "hw"


function main()
	print("started")
	sigma_delta.setup(hw.SPEAKER)
	sigma_delta.setpwmduty(100) --0..255 (255 is NOT 100%!)
end


print("delayed start")
tmr.create():alarm(3000, tmr.ALARM_SINGLE, main) --3s to recover if program crashes on boot
