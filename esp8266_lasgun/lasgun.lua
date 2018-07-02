local fw = require "fw"
local hw = require "hw"

function init_OLED()
    local sla = 0x3c
    i2c.setup(0, hw.SDA, hw.SCL, i2c.SLOW)
    disp = u8g.ssd1306_128x64_i2c(sla)
end

function set_font(font)
	disp:setFont(font)
	disp:setFontRefHeightExtendedText()
	disp:setDefaultForegroundColor()
	disp:setFontPosTop()
end


-- program
local charge = 100 --%
local RECHARGE_STEP = 0.01 -- of %
local RECHARGE_INT = 100 --ms
local mode = {
	single={
		seq={20},
		name="SINGLE",
		cooldown=30,
		mult=1,
		postfix="%"
	},
	triple={
		seq={20, 110, 20, 110, 20},
		name="TRIPLE",
		cooldown=903,
		mult=5,
		postfix="%"
	},
	cont1={
		seq={1000},
		name="CONTINUOUS",
		cooldown=5903,
		mult=500,
		postfix="%"
	}
}

local power={
	live={
		name="LIVE",
		subt="        [LOCKED]",
		duty=0
	},
	calibration={
		name="CALIBRATION",
		subt="        2014/59/EU",-- EU laser safety
		duty=14
	},
	demo={
		name="DEMO",
		subt="        RESTRICTED",
		duty=1023
	}
}
local pwrCycle = {power.calibration, power.demo, power.live}
local pwrIndex = 0
--isrecharging

selMode = mode.single
capacityString = "81%"

wifi.setmode(wifi.NULLMODE)
init_OLED(1,2)

local BTN_THROTTLE_PERIOD = 40000 -- microseconds
function btnChanged()
	local b = gpio.read(hw.PWR)
	local now = tmr.now()
	if b>0 then
		print("b="..gpio.read(hw.PWR))
		local delta = now - btnLastClick
		if delta < 0 then delta = delta + 2147483647 end; -- timer.now() uint31 rollover, see http://www.esp8266.com/viewtopic.php?f=24&t=4833&start=5#p29127
		if delta > BTN_THROTTLE_PERIOD then
			pwrIndex = (pwrIndex + 1) % table.getn(pwrCycle)
			disp_all()
		end;
	else
		btnLastClick = now
	end
end
function prep_button()
	gpio.mode(hw.PWR,gpio.INT,gpio.PULLUP)
	gpio.trig(hw.PWR,"both",btnChanged)
end


function disp_all()
	disp:firstPage()
	repeat
		local ypos=-1
		local xpos=0
		set_font(fw.FONT.M)
		disp:drawStr(xpos+1, ypos, "Mode: "..selMode.name)
		ypos=13
		disp:drawStr(xpos+1, ypos, "Pwr : "..pwrCycle[pwrIndex].name)
		ypos=26
		set_font(fw.FONT.S)
		disp:drawStr(xpos+44, ypos, pwrCycle[pwrIndex].subt)


		set_font(fw.FONT.XL)
		ypos=25
		xpos=0
		disp:drawStr(xpos, ypos, capacityString)
		
	until disp:nextPage() == false
end


tmr.create():alarm(1000, tmr.ALARM_SINGLE, disp_all)

-- short pulse on trigger

