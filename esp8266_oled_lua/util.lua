
local function map(n, from0,from1, to0,to1)
    local ret = to0 + (n-from0)*(to1-to0)/(from1-from0)
	ret = math.min(ret, to1)
    return math.max(ret, to0)
end
