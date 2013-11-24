local addon, ns = ...

local core = Dark.core
local events = core.events.new()

local run = function()
	ns.markers.new()
	ns.threatUi.new()
	ns.interrupt.new()
	ns.cooldowns.new()
end

events.register("PLAYER_ENTERING_WORLD", run)
