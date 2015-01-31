local addon, ns = ...

local initialise = function()

	ns.features = {
		threat = {},
		interrupt = {},
	}

	local dark = Darker

	ns.lib = {
		class = dark.class,
		events = dark.events,
	}

end

initialise()
