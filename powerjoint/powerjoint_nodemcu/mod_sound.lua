
local function beep(pin_speaker)
	pwm.setup(pin_speaker, 710, 20)
	pwm.start(pin_speaker)
	tmr.create():alarm(120, tmr.ALARM_SINGLE, function() pwm.stop(pin_speaker) end)
end


local mymodule = {
	beep = beep
}
return mymodule


