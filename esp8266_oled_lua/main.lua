-- yellow header 16px 10 for font
-- blue: exactly 7 lines

local fw = require "fw"
local hw = require "hw"

function init_OLED()
    local id = 0
    local sla = 0x3c
    i2c.setup(id, hw.SDA, hw.SCL, i2c.SLOW)
	disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)
	--disp:setDrawColor(1) -- 2 ix XOR
	--u8g2.disp:setFontDirection(0)  -- 0-3, it's ROTATION
end

function set_font(font)
	disp:setFont(font)
	disp:setFontRefHeightExtendedText()
	disp:setFontMode(1)--is_transparent
	--disp:setFlipMode(1)--IF supported by HARDWARE
	--disp:setDisplayRotation(U8G2_R2)--software. Eveh has U8G2_MIRROR
	disp:setFontPosTop()
end


function drawItemDesc()
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
end


function draw()
	disp:clearBuffer()
	drawItemDesc()
	disp:sendBuffer()
end


-- program

wifi.setmode(wifi.NULLMODE)
init_OLED()
draw()

