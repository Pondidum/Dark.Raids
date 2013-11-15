local addon, ns = ...

local config = {
	
	threat = {
		rowCount = 5,
		rowHeight = 14,
		rowSpacing = 1,
		classColors = true,
		toggleOnCombat = true,
	},

	interrupt = {
		enabled = true,
		channel = "say",
		suffix = "",
		notify = "",
	},

}

ns.config = config
