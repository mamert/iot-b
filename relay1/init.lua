--node.compile("relay_main.lua")
--file.remove("relay_main.lua")
--dofile("relay_main.lc")

file.open("restarts.txt", "a+")
file.write('+')
file.close()
	
dofile("relay_main.lua")
