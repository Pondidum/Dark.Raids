local addon, ns = ...

local run = function()
	ns.markers.new()
	ns.threatUi.new()
	ns.interrupt.new()
	ns.cooldowns.new()
end

run()
Dark.raids = ns