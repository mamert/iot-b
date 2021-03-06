-- to call:
-- > local display = require "display"
-- if need to unload: package.loaded.display = nil

local _fw
local _disp

local function init(fw, i2c_id)
	_fw = fw
    local sla = 0x3c
	_disp = u8g2.ssd1306_i2c_128x64_vcomh0(i2c_id, sla) -- vcomh0 has greater brightness range than noname
	_disp:setContrast(1) -- brightness (1-255). Very little effect.
	--_disp:setDrawColor(1) -- 2 ix XOR
	--u8g2._disp:setFontDirection(0)  -- 0-3, it's ROTATION
end


local function set_font(font)
	_disp:setFont(font)
	_disp:setFontRefHeightExtendedText()
	_disp:setFontMode(1)--is_transparent
	_disp:setFlipMode(1)--IF supported by HARDWARE
	--_disp:setDisplayRotation(U8G2_R2)--software. Eveh has U8G2_MIRROR
	_disp:setFontPosTop()
end


local function drawHUD(inBold, otherTexts)
	local xpos=0
	local ypos=0
	set_font(_fw.FONT.S)
	for k,v in pairs(otherTexts) do
		_disp:drawStr(xpos, ypos, v)
		ypos=ypos+8
		if ypos > 55 then break end
	end
	
	ypos=49
	set_font(_fw.FONT.M)
	_disp:drawStr(xpos+1, ypos, inBold)
end
local function drawMockHUD()
	drawHUD("#reps: --", {"  Lorem ipsum dolor sit","   amet, consectetur","adipiscing elit, sed do"," eiusmod tempor incidi-","dunt ut labore et dolore","magna aliqua. Ut enim ad"})
end


local function drawItemDesc()
	local ypos=0
	local xpos=0
	set_font(_fw.FONT.M)
	_disp:drawStr(xpos+1, ypos, "Cardboard Greave R")
	--_disp:drawStr(xpos+2, ypos, "Cardboard Greave R")


	set_font(_fw.FONT.S)
	ypos=16
	xpos=20
	_disp:drawStr(xpos, ypos, "of Cardboard Armor Set")
	ypos=ypos+8+1
	set_font(_fw.FONT.M)
	xpos=8
	_disp:drawStr(xpos, ypos, "+5")
	set_font(_fw.FONT.S)
	_disp:drawStr(xpos+18, ypos+3, "to Virginity Defense")
	ypos=ypos+15
	xpos=7
	_disp:drawStr(xpos+13, ypos, "Durability:")
	_disp:drawStr(xpos+70, ypos, "1")
	_disp:drawStr(xpos+71, ypos, "1")
	_disp:drawStr(xpos+81, ypos, "of")
	_disp:drawStr(xpos+96, ypos, "1")
	_disp:drawStr(xpos+97, ypos, "1")
	ypos=ypos+8
	xpos=15
	_disp:drawStr(xpos, ypos, "Required Strength: 0")
	ypos=ypos+8
	xpos=7
	_disp:drawStr(xpos, ypos, "Required Confidence: 50")
end


local function draw()
	_disp:clearBuffer()
	drawMockHUD()
	_disp:sendBuffer()
end



local mymodule = {
	init = init,
	draw = draw
}
return mymodule



