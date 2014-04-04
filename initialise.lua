local addon, ns = ...

local initialise = function()

	ns.features = {}

	local core = Dark.core

	ns.lib = setmetatable({ }, { __index = core })

end

initialise()
