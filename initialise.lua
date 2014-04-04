local addon, ns = ...

local initialise = function()

	ns.features = {}

	local core = Dark.core

	ns.lib = {
		events = core.events,
	}

end

initialise()
