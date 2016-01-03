-- yellow header 16px 10 for font
-- blue: exactly 7 lines
FONT_S=u8g.font_5x8
FONT_L=u8g.font_7x14

line=0
function drawStr(text)
	if(line <= 1) then
		disp:setFont(line==0 and FONT_L or FONT_S)
		disp:setFontRefHeightExtendedText()
		disp:setFontPosTop()
	end
	disp:drawStr(0, line>0 and (line-1)*7+15 or 0,text)
	line=line+1
end

disp:firstPage()
repeat
	line = 0
	
	drawStr("Sel:"..selectedRelay)
	for k,v in pairs(relayVals) do
		drawStr(k..":"..v)
	end
	
	disp:drawLine(0,15,127,15)
	
	--drawStr(" R0: Offline")
	--drawStr("*R1 Relay 0: 1")
	--drawStr(" R1 Relay 1: 1")
	
	--drawStr("")
	--drawStr("")
	--drawStr("")
	--drawStr("Toggle            Load...")
	
    disp:drawStr270(120, 14, "-*-")
	
until disp:nextPage() == false

