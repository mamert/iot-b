-- yellow header 16px 10 for font
-- blue: exactly 7 lines

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

wifi.setmode(wifi.NULLMODE)
init_OLED()


function drawItemDesc()
	disp:firstPage()
	repeat
		local ypos=0
		local xpos=0
		set_font(fw.FONT.M)
		disp:drawStr(xpos+1, ypos, "Cardboard Greave R")
		disp:drawStr(xpos+2, ypos, "Cardboard Greave R")


		set_font(fw.FONT.S)
		ypos=16
		xpos=20
		disp:drawStr(xpos, ypos, "of Cardboard Armor Set")
		ypos=ypos+8+1
		set_font(fw.FONT.M)
		xpos=8
		disp:drawStr(xpos, ypos, "+5")
		set_font(fw.FONT.S)
		disp:drawStr(xpos+18, ypos+3, "to Virginity Defense")
		ypos=ypos+15
		xpos=7
		disp:drawStr(xpos+13, ypos, "Durability:")
		disp:drawStr(xpos+70, ypos, "1")
		disp:drawStr(xpos+71, ypos, "1")
		disp:drawStr(xpos+81, ypos, "of")
		disp:drawStr(xpos+96, ypos, "1")
		disp:drawStr(xpos+97, ypos, "1")
		ypos=ypos+8
		xpos=15
		disp:drawStr(xpos, ypos, "Required Strength: 0")
		ypos=ypos+8
		xpos=7
		disp:drawStr(xpos, ypos, "Required Confidence: 50")
	until disp:nextPage() == false

	-- alt: "Ancient Cymbal"
end


drawItemDesc()

