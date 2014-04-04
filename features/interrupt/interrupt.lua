local addon, ns = ...
local config = ns.config.interrupt

local eventStore = ns.lib.events.new()
local slash = ns.lib.slash

local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid
local GetNumPartyMembers = GetNumPartyMembers
local SendChatMessage = SendChatMessage

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

		local this = {

			enable = function()
				eventStore.register("COMBAT_LOG_EVENT_UNFILTERED", onCombatLogUnfiltered)
			end,

			disable = function()
				eventStore.unregister("COMBAT_LOG_EVENT_UNFILTERED")
			end,

			isEnabled = function()
				return eventStore.isRegistered("COMBAT_LOG_EVENT_UNFILTERED")
			end,

			setChannel = function(value)
				config.channel = string.upper(value)
			end,

			getChannel = function()
				return string.upper(config.channel)
			end,

			setSuffix = function(value)
				config.suffix = value
			end,

			getSuffix = function()
				return config.suffix
			end,

			setNotify = function(value)
				config.notify = value
			end,

			getNotify = function()
				return config.notify
			end,
		}

		if config.enabled then
			this.enable()
		end

		return this

	end

}

ns.interrupt = interrupt
