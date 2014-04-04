local addon, ns = ...

local initialise = function()

	ns.features = {
		threat = {},
		interrupt = {},
	}

	local core = Dark.core

	ns.lib = setmetatable({ }, { __index = core })

end

initialise()
