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
		layout = dark.layoutEngine,
		style = dark.style,
		media = dark.media,
	}

end

initialise()
