local addon, ns = ...

local config = {

	threat = {
		rowCount = 1,
		rowHeight = 14,
		rowSpacing = 1,
		classColors = true,
		toggleOnCombat = true,
	},

	interrupt = {
		enabled = true,
		channel = "SAY",
		suffix = "Xynk Next",
		notify = "",
	},


	cooldowns = {
		enabled = true,
		channel = "yell",
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

	selfBuffs = {
		buffs = {
			DEATHKNIGHT = {
				57330, -- horn of Winter
				31634, -- strength of earth totem
				6673, -- battle Shout
				93435, -- roar of courage (hunter pet)
			},
			MAGE = {
				7302, -- frost armor
				6117, -- mage armor
				30482, -- molten armor
			},
			PRIEST = {
				588, 	-- inner fire
				73413, 	-- inner will
			},
			SHAMAN = {
				52127, -- water shield
				324, -- lightning shield
				974, -- earth shield
			},
			WARRIOR = {
				469, -- commanding Shout
				6673, -- battle Shout
			},
		},
	},

}

ns.config = config
