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
		channel = "SAY",
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

	errorFilter = {
		mode = "blacklist",
		blacklist = {
			ERR_ABILITY_COOLDOWN = true,
			ERR_GENERIC_NO_TARGET = true,
			ERR_SPELL_COOLDOWN = true,
			SPELL_FAILED_SPELL_IN_PROGRESS = true,
			ACTION_SPELL_INTERRUPT = true,
			INTERRUPTED = true,
			SPELL_FAILED_MOVING = true,
		},
		whitelist = {
			INVENTORY_FULL = true,
		},
	},

}

ns.config = config
