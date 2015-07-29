local addon, ns = ...
local config = ns.config.threat

local options = ns.lib.options
local class = ns.lib.class
local events = ns.lib.events

local run = class:extend({

	ctor = function(self)
		self:include(events)
		self:register("PLAYER_LOGIN")

		self:registerOptions()
	end,

	registerOptions = function(self)

		options:addPanel("Threatmeter", function(control)

			return {
				control:input(config, "rowCount", "text"),
				control:input(config, "rowHeight", "text"),
				control:input(config, "rowSpacing", "text"),
				control:input(config, "classColors", "boolean"),
				control:input(config, "toggleOnCombat", "boolean")
			}
		end)

	end,

	PLAYER_LOGIN = function(self)

		local threat = ns.features.threat
		local cache = ns.unitCache.new()
		local model = threat.model:new(cache)
		local ui = threat.ui.new(model)

	end,

})

ns.features.runThreat = function()
	run:new()
end
