local addon, ns = ...

local core = Dark.core
local events = core.events.new()

local run = function()
	ns.threatUi.new()
	ns.interrupt.new()
	ns.cooldowns.new()
end

ns.markers.new()

events.register("PLAYER_ENTERING_WORLD", run)
