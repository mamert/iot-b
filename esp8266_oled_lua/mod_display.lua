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
	--_disp:setFlipMode(1)--IF supported by HARDWARE
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
	_disp:drawStr(xpos+9, ypos, "Eyepiece of OLED")

	set_font(_fw.FONT.S)
	ypos=16
	xpos=18
	_disp:drawStr(xpos+3, ypos, "of Prototype Acc. Set")
	ypos=ypos+8+1
	set_font(_fw.FONT.M)
	xpos=8
	_disp:drawStr(xpos, ypos, "+5")
	set_font(_fw.FONT.S)
	_disp:drawStr(xpos+21, ypos+3, "to Base Badassery")
	ypos=ypos+15
	xpos=8
	_disp:drawStr(xpos+13, ypos, "Durability:")
	_disp:drawStr(xpos+70, ypos, "3")
	_disp:drawStr(xpos+71, ypos, "3")
	_disp:drawStr(xpos+81, ypos, "of")
	_disp:drawStr(xpos+96, ypos, "3")
	_disp:drawStr(xpos+97, ypos, "3")
	ypos=ypos+8
	xpos=11
	_disp:drawStr(xpos, ypos, "Required Hackitude: 40")
	ypos=ypos+8
	xpos=22
	_disp:drawStr(xpos, ypos, "Required Tech: 15")
	_disp:drawLine(0, 16, 0, 47)
	_disp:drawLine(127, 16, 127, 47)
end


local function draw(t)
	_disp:clearBuffer()
	tmp6 = math.floor(t / 100000) % 1000000
	tmp1 = tmp6 % 10
	tmp2 = math.floor(tmp6 / 10)
	if tmp1 < 2 then
		set_font(_fw.FONT.L_DIGITS)
		_disp:drawStr(0, 25, tmp2)
	else
		drawItemDesc()
	end
	_disp:sendBuffer()
end



local mymodule = {
	init = init,
	draw = draw
}
return mymodule



