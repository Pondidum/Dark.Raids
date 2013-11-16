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


	cooldowns = {
		enabled = true,
		channel = "yell",

		SHAMAN = {
			["Enhancement"] = {
				[120668] = "%s Up.", -- stormlash
				[108280] = "%s Up.", -- healing tide
			},
		},
	},

}

ns.config = config
