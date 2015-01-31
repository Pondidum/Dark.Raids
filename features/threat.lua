local addon, ns = ...

local class = ns.lib.class
local events = ns.lib.events

local run = class:events({

	ctor = function(self)
		self:include(events)
		self:register("PLAYER_LOGIN")
	end,

	PLAYER_LOGIN = function(self)

		local threat = ns.features.threat
		local cache = ns.unitCache.new()
		local model = threat.model.new(cache)
		local ui = threat.ui.new(model)

	end,

})

ns.features.runThreat = function()
	run:new()
end
