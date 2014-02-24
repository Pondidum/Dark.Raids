local addon, ns = ...

local core = Dark.core
local events = core.events.new()

local run = function()
	ns.threatUi.new()
	ns.cooldowns.new()

	local interrupt = ns.interrupt.new()
	ns.interruptOptions.new(interrupt)

end

ns.markers.new()

events.register("PLAYER_LOGIN", run)
