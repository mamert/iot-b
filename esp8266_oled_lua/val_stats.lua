local TOOMUCH = bit.lshift(1, 30)

Stats = {minimum=TOOMUCH, maximum=-TOOMUCH, val=0, ravg_prev=0, ravg=0, ravg2=0, ravg3=0, ravg4=0}
Stats.__index = Stats

function Stats:__tostring()
	return string.format("%.3g %.3g %.3g %.3g", self.ravg, self.ravg2, self.ravg3, self.val)
	--return string.format("%.3g", self.ravg)
	--return string.format("%.3g/%.3g/%.3g", self.minimum, self.val, self.maximum)
end

function Stats:new()
	o = {minimum=TOOMUCH, maximum=-TOOMUCH, val=0, ravg=0, ravg2=0, ravg3=0, ravg4=0}
	local self = setmetatable(o, Stats)
	return self
end

function Stats:update(newVal)
	self.val = newVal
	self.minimum = math.min(self.minimum, newVal)
	self.maximum = math.max(self.maximum, newVal)
	self.ravg_prev = self.ravg
	self.ravg = 0.9*self.ravg + 0.1*newVal
	self.ravg2 = 0.7*self.ravg2 + 0.3*newVal
	self.ravg3 = 0.97*self.ravg3 + 0.03*newVal
	self.ravg4 = 0.99*self.ravg4 + 0.01*newVal
end
