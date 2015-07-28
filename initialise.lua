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
		mixins = dark.mixins,
		layout = dark.layoutEngine,
		style = dark.style,
		media = dark.media,
		options = dark.options
	}

end

initialise()
