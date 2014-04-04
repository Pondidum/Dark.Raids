local addon, ns = ...

local initialise = function()

	ns.features = {}

	local core = Dark.core

	ns.lib = {
		events = core.events,
		ui = core.ui,
		style = core.style,
		layout = core.layout,
		fonts = core.fonts,
		colours = core.colors,
		textures = core.textures,
		slash = core.slash,
		options = core.options.
	}

end

initialise()
