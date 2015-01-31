local addon, ns = ...

local class = ns.lib.class
local events = ns.lib.events

local run = class:extend({

	ctor = function(self)
		self:include(events)
		self:register("PLAYER_LOGIN")
	end,

	PLAYER_LOGIN = function(self)

		local controller = interrupt.controller.new()
		local options = interrupt.options.register(controller)

	end,
})

ns.features.runInterrupt = function()
	run:new()
end
