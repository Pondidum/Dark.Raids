local addon, ns = ...
local events = ns.lib.events.new()

local run = function()

	local interrupt = ns.features.interrupt

	events.register("PLAYER_LOGIN", function()

		local controller = interrupt.controller.new()
		local options = interrupt.options.register(controller)

	end)
	
end

ns.features.runInterrupt = run
