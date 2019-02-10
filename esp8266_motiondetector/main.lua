local hw = require "hw"
local buzzTmrId = 3

function beepStop()
	pwm.stop(hw.PIEZO)
end

function beepStart()
	print("Beep")
	pwm.start(hw.PIEZO)
	tmr.alarm(buzzTmrId, 300, tmr.ALARM_SINGLE, beepStop)
end

function initDetection()
	print("Starting motion detection")
	pwm.setup(hw.PIEZO, 500, 512)
	gpio.mode(hw.TRIGGER,gpio.INT)
	gpio.trig(hw.TRIGGER, "up", beepStart)
end


local currentFreq = 150.0
function freqSweep()
	currentFreq = currentFreq*1.005
	pwm.setclock(hw.PIEZO, currentFreq)
	if(currentFreq > 1000) then
		tmr.unregister(buzzTmrId)
		initDetection()
	end
end



pwm.setup(hw.PIEZO, currentFreq, 512)
pwm.start(hw.PIEZO)
print("Starting frequency sweep")
tmr.alarm(buzzTmrId, 60, tmr.ALARM_AUTO, freqSweep)


