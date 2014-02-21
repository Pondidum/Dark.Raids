local addon, ns = ...
local config = ns.config.interrupt

local core = Dark.core
local eventStore = core.events.new()
local slash = core.slash
local options = core.options

local interrupt = {

	new = function()

		local playerName = UnitName("player")

		local shouldAnnounce = {
			say = function()
				return true
			end,

			party = function()
				return UnitInParty("player") and GetNumPartyMembers() > 0
			end,

			raid = function()
				return UnitInRaid("player")
			end,
		}

		local messages = {

			SPELL_INTERRUPT = function(targetSpellID, sourceSpellID)
				return "Interrupted " .. GetSpellLink(targetSpellID) .. "."
			end,

			SPELL_STOLEN = function(targetSpellID, sourceSpellID)
				return "Spellstole " .. GetSpellLink(targetSpellID) .. "."
			end
		}

		local onCombatLogUnfiltered = function(self, event, ...)

			local timestamp, eventType, hideCaster, sourceGuid, sourceName, sourceFlags, sourceRaidFlags, destGuid, destName, destFlags, destRaidFlags, spellID, arg1, arg2, extraskillID = ...

			if sourceName ~= playerName then
				return
			end

			if messages[eventType] == nil then
				return
			end

			if shouldAnnounce[config.channel] == nil then
				return
			end

			local message = messages[eventType](extraskillID, spellID) .. " " .. config.suffix

			SendChatMessage(message, config.channel)

			if config.notify ~= nil and config.notify ~= "" then
				SendChatMessage(message, "WHISPER", nil, config.notify)
			end


		end

		local this = {}

		this.enable = function()
			eventStore.register("COMBAT_LOG_EVENT_UNFILTERED", onCombatLogUnfiltered)
		end

		this.disable = function()
			eventStore.unregister("COMBAT_LOG_EVENT_UNFILTERED")
		end

		this.isEnabled = function()
			return eventStore.isRegistered("COMBAT_LOG_EVENT_UNFILTERED")
		end

		this.setChannel = function(value)
			config.channel = string.lower(value)
		end

		this.setSuffix = function(value)
			config.suffix = value
		end

		this.setNotify = function(value)
			config.notify = value
		end

		--[[

			/dark interrupt enable
			/dark interrupt disable
			/dark interrupt channel party
			/dark interrupt suffix "wrinkle next"
			/dark interrupt whisper wrinkle

		]]--
		local slashHandler = {

			enable = function()
				this.enable()
				print("Interrupt Announce: Enabled.")
			end,

			disable = function()
				this.disable()
				print("Interrupt Announce: Disabled.")
			end,

			channel = function(value)
				this.setChannel(value)
				print(string.format("Interrupt Announce: Annoncing to %s.", value))
			end,

			suffix = function(value)
				this.setSuffix(value)
				print(string.format("Interrupt Announce: Appending messages with '%s'.", value))
			end,

			whisper = function(value)
				this.setNotify(value)
				print(string.format("Interrupt Announce: Whispering %s on interrupt.", value))
			end,
		}

		local helpHandler = {
			enable = "Enables the interrupt announce.",
			disable = "Disable the interrupt announce.",
			channel = "The channel to announce to\n\tArg1: 'Channel Name'",
			suffix = "A message to append to the announce\n\tArg1: 'suffix message'",
			whisper = "",
		}


		slash.register("interrupt", slashHandler, helpHandler)
		slash.register("int", slashHandler, helpHandler)

		if config.enabled then
			this.enable()
		end

		local inputOffset = 5
		local groupSpacing = 20

		options.register("Interrupt", {
			description = "An Interrupt announcer.",

			children = {
				{
					type = "label",
					name = "$parentEnabledLabel",
					points = {
						{ "TOPLEFT" , "$parent", "TOPLEFT", 10, -10 },
					},
					text = "Enabled",
				},
				{
					type = "checkbox",
					template = "OptionsCheckButtonTemplate",
					name = "$parentEnabled",
					points = {
						{ "TOP", "$parentEnabledLabel", "BOTTOM", 0, -5 },
						{ "LEFT", "$parentEnabledLabel", "LEFT", inputOffset, 0 },
					},
				},
				{
					type = "label",
					name = "$parentChannelLabel",
					points = {
						{ "TOP", "$parentEnabled", "BOTTOM", 0, -groupSpacing},
						{ "LEFT", "$parentEnabledLabel", "LEFT", 0, 0 },
					},
					text = "Announce to Channel:"
				},
				{
					type = "dropdown",
					name = "$parentChannel",
					points = {
						{ "TOP", "$parentChannelLabel", "BOTTOM", 0, -5 },
						{ "LEFT", "$parentEnabledLabel", "LEFT", inputOffset-20, 0 },
					},
					items = {
						PARTY = "Party",
						SAY = "Say",
						RAID = "Raid",
					}
				},
				{
					type = "label",
					name = "$parentSuffixLabel",
					points = {
						{ "TOP", "$parentChannel", "BOTTOM", 0, -groupSpacing},
						{ "LEFT", "$parentEnabledLabel", "LEFT", 0, 0 },
					},
					text = "Suffix messages with:"
				},
				{
					type = "textbox",
					name = "$parentSuffix",
					points = {
						{ "TOP", "$parentSuffixLabel", "BOTTOM", 0, -5},
						{ "LEFT", "$parentEnabledLabel", "LEFT", inputOffset, 0 },
					},
					size = { 250, 20 },
				},
				{
					type = "label",
					name = "$parentWhisperLabel",
					points = {
						{ "TOP", "$parentSuffix", "BOTTOM", 0, -groupSpacing},
						{ "LEFT", "$parentEnabledLabel", "LEFT", 0, 0 },
					},
					text = "Whisper a player on successful interrupt:"
				},
				{
					type = "textbox",
					name = "$parentWhisper",
					points = {
						{ "TOP", "$parentWhisperLabel", "BOTTOM", 0, -5},
						{ "LEFT", "$parentEnabledLabel", "LEFT", inputOffset, 0 },
					},
					size = { 150, 20 },
				},
			},
		})

		return this

	end

}

ns.interrupt = interrupt
