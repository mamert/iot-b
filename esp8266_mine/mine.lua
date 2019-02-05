local hw = require "hw"


function main()
	print("started")
	pwm.setup(hw.SPEAKER, 400, 512)
	pwm.start(hw.SPEAKER)
end


print("delayed start")
tmr.create():alarm(3000, tmr.ALARM_SINGLE, main) --3s to recover if program crashes on boot
