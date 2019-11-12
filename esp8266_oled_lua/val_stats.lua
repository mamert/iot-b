local TOOMUCH = bit.lshift(1, 30)

Stats = {minimum=TOOMUCH, maximum=-TOOMUCH, val=0, ravg=0}
Stats.__index = Stats

function Stats:__tostring()
	return string.format("%.3g/%.3g/%.3g", self.minimum, self.val, self.maximum)
end

function Stats:new()
	o = {minimum=TOOMUCH, maximum=-TOOMUCH, val=0, ravg=0}
	local self = setmetatable(o, Stats)
	return self
end

function Stats:update(newVal)
	self.val = newVal
	self.minimum = math.min(self.minimum, newVal)
	self.maximum = math.max(self.maximum, newVal)
	self.ravg = 0.9*self.ravg + 0.1*newVal
end
