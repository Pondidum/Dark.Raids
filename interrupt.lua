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
			SAY = function()
				return true
			end,

			PARTY = function()
				return UnitInParty("player") and GetNumPartyMembers() > 0
			end,

			RAID = function()
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
			config.channel = string.upper(value)
		end

		this.getChannel = function()
			return string.upper(config.channel)
		end

		this.setSuffix = function(value)
			config.suffix = value
		end

		this.getSuffix = function()
			return config.suffix
		end

		this.setNotify = function(value)
			config.notify = value
		end

		this.getNotify = function()
			return config.notify
		end

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
					actions = {
						save = function(self)
							if self:GetChecked() then
								this.enable()
							else
								this.disable()
							end
						end,
						load = function(self)
							self:SetChecked(this.isEnabled())
						end,
					}
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
					},
					actions = {
						save = function(self)
							this.setChannel(UIDropDownMenu_GetSelectedValue(self))
						end,
						load = function(self)
							UIDropDownMenu_SetSelectedValue(self, this.getChannel())
							UIDropDownMenu_SetText(self, this.getChannel())
						end,
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
					actions = {
						save = function(self)
							this.setSuffix(self:GetText())
						end,
						load = function(self)
							self:SetText(this.getSuffix())
						end,
					}
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
					actions = {
						save = function(self)
							this.setNotify(self:GetText())
						end,
						load = function(self)
							self:SetText(this.getNotify())
						end,
					}
				},
			},
		})

		return this

	end

}

ns.interrupt = interrupt
