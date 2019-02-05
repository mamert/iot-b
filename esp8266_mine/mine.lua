local hw = require "hw"
local lastFileName=""
local drv


function rewind(drv)
	file.seek("set", 0)
end

function setUpPCM()
	drv = pcm.new(pcm.SD, hw.SPEAKER)
	-- fetch data in chunks of FILE_READ_CHUNK (1024) from file
	drv:on("data", function(drv) return file.read() end)
	-- get called back when all samples were read from the file
	drv:on("drained", rewind)
	drv:on("stopped", rewind)
	drv:on("paused", function(drv) end)
end

function play(fileName)
	if lastFileName==fileName then
		rewind(drv)
	else
		print("Switching to:\""..fileName.."\"")
		lastFileName=fileName
		file.open(fileName,"r")
		if drv==nil then setUpPCM() end
	end
	drv:play(pcm.RATE_8K)
end




tmr.create():alarm(1000, tmr.ALARM_AUTO, function() play("tick.wav") end)



