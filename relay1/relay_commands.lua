
function getOtherCommands()
	return {
		["lua"] = function(txt) node.input(txt) end
	}
end



return {
  getOtherCommands = getOtherCommands
}
